/**
 * @description Clase usada para invocar la integración.
 * @group Proyecto MP
 * @author Miller Mora
 * @since 26-08-2024 - Creación
 */
public with sharing class GetContractAPI_Inv {

    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPGETContract').DeveloperName;
    /** Número máximo de reintentos a la API */
    public static final Boolean RETRY = MPIntegrationSetting__mdt.getInstance('MPGETContract').MPRetry__c;
    public static final String ORDER_ENTITY_PREFIX = '801';
    public static final String OPPORTUNITY_ENTITY_PREFIX = '006';

    /**
     * @description Método invocable para ser llamado desde un Flow.
     * Este método recibe una lista de IDs de contratos u órdenes y los procesa.
     * @param recordsIdListList List<List<Id>> - Lista de IDs de contratos u órdenes que serán procesados.
     */
    @InvocableMethod(label='Invoke Call Manager from Flow GetContractAPI' description='Invokes the Call Manager Queueable from Flow')
    public static void invokeGetContractAPI(List<List<Id>> recordsIdListList) {
        System.debug(recordsIdListList);
        // Validamos si la lista está vacía o nula
        if(recordsIdListList == null || recordsIdListList.isEmpty()) {
            return;
        }

        List<Id> recordsIdList = new List<Id>();
        for (List<Id> idList : recordsIdListList) {
            recordsIdList.addAll(idList);
        }
        
        // Listas separadas para Oportunidades y Órdenes
        List<Id> opportunityIds = new List<Id>();
        List<Id> orderIds = new List<Id>();

        // Clasificamos los IDs según su prefijo
        for(Id recordId : recordsIdList) {
            if (String.valueOf(recordId).startsWith(OPPORTUNITY_ENTITY_PREFIX)) {
                opportunityIds.add(recordId);
            } else if (String.valueOf(recordId).startsWith(ORDER_ENTITY_PREFIX)) {
                orderIds.add(recordId);
            }
        }

        // Procesamos las Oportunidades. La asociacion del IntegrationStatus y la Oportunidad se hace en un Trigger Flow de IntegrationStatus
        if (!opportunityIds.isEmpty()) {
            List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Id IN :opportunityIds];
            processOpportunities(opportunities);
        }

        // Procesamos las Órdenes
        if (!orderIds.isEmpty()) {
            List<Order> orders = [SELECT Id FROM Order WHERE Id IN :orderIds];
            processOrders(orders);
        }
    }

    /**
     * @description Procesa la lista de Oportunidades.
     * @param lstOpportunities List<Opportunity> - Lista de Oportunidades a procesar.
     */
    private static void processOpportunities(List<Opportunity> lstOpportunities) {
        Opportunity oppRenov = lstOpportunities[NumbersEnum.CERO.ordinal()];
        if(oppRenov != null){
            MPIntegrationStatus__c intStatus = getIntStatus(oppRenov.Id);
            insert intStatus;
            GetContractAPICallManager callManager = new GetContractAPICallManager(oppRenov, RETRY, intStatus);
            System.enqueueJob(new CallManagerQueueable(callManager));
        }
    }

    /**
     * @description Procesa la lista de Órdenes.
     * @param orderList List<Order> - Lista de Órdenes a procesar.
     */
    private static void processOrders(List<Order> orderList) {
        Map<Id,MPIntegrationStatus__c> intStatusByOrderIdMap = new Map<Id,MPIntegrationStatus__c>();
        List<Order> ordersToUpdateList = new List<Order>();

        // Recorrer todas las ordenes y organizar mapa
        for(Order order : orderList){
            if(!intStatusByOrderIdMap.containsKey(order.Id)){
                MPIntegrationStatus__c newLog = getIntStatus(order.Id);
                intStatusByOrderIdMap.put(order.Id, newLog);
            }
        }
        
        // Insertar logs de la integración (MPIntegrationStatus__c)
        if(!intStatusByOrderIdMap.isEmpty()){
            insert intStatusByOrderIdMap.values();
        }

        // asignar a las ordenes la lupa al log de integraciones
        for(Order order : orderList){
            if(intStatusByOrderIdMap.containsKey(order.Id)){
                Order orderTemp = new Order(
                    id = order.Id,
                    MPGetContractStatus__c = intStatusByOrderIdMap.get(order.Id).Id
                );
                ordersToUpdateList.add(orderTemp);
            }
        }

        // Actualizar ordenes
        if(!ordersToUpdateList.isEmpty()){
            update ordersToUpdateList;
        }

        // Recorrer ordenes y encolar trabajos
        for(Order order : orderList ){
            if(intStatusByOrderIdMap.containsKey(order.Id) && !Test.isRunningTest()){
                GetContractAPICallManager callManager = new GetContractAPICallManager(order, RETRY, intStatusByOrderIdMap.get(order.Id));
                System.enqueueJob(new CallManagerQueueable(callManager));
            }
        }
    }

    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @param recordId Id del objeto a procesar
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id recordId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c = INTEGRATION_NAME;
        newLog.MPParentId__c = String.valueOf(recordId);
        newLog.MPStatus__c = IN_PROGRESS_STATUS;
        return newLog;
    }
}