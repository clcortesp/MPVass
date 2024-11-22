/**
 * @description Clase tipo invocable que llama la clase manager de la intergracion 4.5 de Rescición de Contrato
 * @group Proyecto MP
 * @author Miller Mora
 * @since 17-10-2024 - Creación
 */
public with sharing class ContractRescissionAPI_Inv {

    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractRescission').DeveloperName;
    /** Número máximo de reintentos a la API */
    public static final Boolean RETRY = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPRetry__c;

    /**
     * @description Método invocable para ser llamado desde un Flow.
     * Este método encola un trabajo Queueable que ejecutará la lógica del ContractCreationAPICallManager.
     * @author Miller Mora | 26-08-2024 
     * @param OrderIds List<Id> - Lista de IDs de las ordenes que serán procesadas.
     */
    @InvocableMethod(label='Invoke Call Manager from Flow ContractRescissionAPI' description='Invokes the Call Manager Queueable from Flow')
    public static void invokeFromFlowContractRescissionAPI(List<Order> lstorders) {

        Order orderRescission = lstorders[NumbersEnum.CERO.ordinal()];
        if(orderRescission != null){
            // Creación del log de integración
            MPIntegrationStatus__c intStatus = getIntStatus(orderRescission.Id);
            insert intStatus;

            System.debug('intStatus intStatus' + intStatus.MPStatus__c);
            // Ejecutar integración
            ContractRescissionAPICallManager callManager = new ContractRescissionAPICallManager(orderRescission,RETRY,intStatus);
            System.enqueueJob(new CallManagerQueueable(callManager));
        }

   }


    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Miller Mora | 26-08-2024 
     * @param contractId Id de la Opp de renovacion
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id orderId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c    = INTEGRATION_NAME;
        newLog.MPParentId__c           = String.valueOf(orderId);
        newLog.MPStatus__c             = IN_PROGRESS_STATUS;
        return newLog;
    }

}