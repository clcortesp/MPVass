/**
 * @description Clase usada desde 'Screen Flows' para invocar la integración de actualización de fechas de contrato.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 26-08-2024 - Creación
 */
public with sharing class ContractDatesUpdateAPI_Inv {
    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').DeveloperName;
    /** Permitir o no hacer reintentos */
    public static final Boolean IS_RETRY_ENABLED = false;

    /**
     * @description Método encargado de ejecutar la integración de actualizacion de fechas de contratos.
     * @author Juan Felipe Muriel | 26-08-2024 
     * @param contractList Contratos a activar.
     */
    @InvocableMethod(label='Call the Contract Dates Update API' description='Call the Contract Dates Update API.' category='Contract')
    public static void contractDatesUpdateAPI(List<Contract> contractList) {

        Map<Id,MPIntegrationStatus__c> intStatusByContractIdMap = new Map<Id,MPIntegrationStatus__c>();
        List<Contract> contractsToUpdateList = new List<Contract>();

        // Recorrer todos los contratos y organizar mapa
        for(Contract contract : contractList){
            if(!intStatusByContractIdMap.containsKey(contract.Id)){
                MPIntegrationStatus__c newLog = getIntStatus(contract.Id);
                intStatusByContractIdMap.put(contract.Id, newLog);
            }
        }
        
        // Insertar logs de la integración (MPIntegrationStatus__c)
        if(!intStatusByContractIdMap.isEmpty()){
            insert intStatusByContractIdMap.values();
        }

        // asignar a los contratos la lupa al log de integraciones
        for(Contract contract : contractList){
            if(intStatusByContractIdMap.containsKey(contract.Id)){
                Contract contractTemp = new Contract(
                    id = contract.Id,
                    MPContractDatesUpdateStatus__c = intStatusByContractIdMap.get(contract.Id).Id
                );
                contractsToUpdateList.add(contractTemp);
            }
        }

        // Actualizar contratos
        if(!contractsToUpdateList.isEmpty()){
            update contractsToUpdateList;
        }

        // Recorrer contratos y encolar trabajos
        for(Contract contract : contractList ){
            if(intStatusByContractIdMap.containsKey(contract.Id) && !Test.isRunningTest()){
                ContractDatesUpdateAPICallManager callManager = new ContractDatesUpdateAPICallManager(contract,IS_RETRY_ENABLED,intStatusByContractIdMap.get(contract.Id));
                System.enqueueJob(new CallManagerQueueable(callManager));
            }
        }
    }

    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Juan Felipe Muriel | 26-08-2024 
     * @param contractId Id de un contrato
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id contractId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c    = INTEGRATION_NAME;
        newLog.MPParentId__c           = String.valueOf(contractId);
        newLog.MPStatus__c             = IN_PROGRESS_STATUS;
        return newLog;
    }
}