/**
 * @description Clase tipo invocable que llama la clase manager de la intergracion 4.0 de creacion de contratos
 * @group Proyecto MP
 * @author Miller Mora
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractCreationAPI_Inv {

    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractCreation').DeveloperName;
    /** Número máximo de reintentos a la API */
    public static final Boolean RETRY = MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPRetry__c;

    /**
     * @description Método invocable para ser llamado desde un Flow.
     * Este método encola un trabajo Queueable que ejecutará la lógica del ContractCreationAPICallManager.
     * @author Miller Mora | 26-08-2024 
     * @param contractIds List<Id> - Lista de IDs de contratos que serán procesados.
     */
    @InvocableMethod(label='Invoke Call Manager from Flow ContractCreationAPI' description='Invokes the Call Manager Queueable from Flow')
    public static void invokeFromFlow(List<Id> contractIds) {
        for (Id contractId : contractIds) {
            
            MPIntegrationStatus__c intStatus = getIntStatus(contractId);
            insert intStatus;
            Id integrationStatusId = intStatus.Id;

            List<Id> singleContractIdList = new List<Id>{contractId};
            ContractCreationAPICallManager manager = new ContractCreationAPICallManager(singleContractIdList, RETRY, integrationStatusId);
            System.debug('Manager created, now enqueueing job');
            System.enqueueJob(new CallManagerQueueable(manager));
            System.debug('Job enqueued');
            //System.enqueueJob(queueableJob);
        }
    }

    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Miller Mora | 26-08-2024 
     * @param contractId Id de la Opp de renovacion
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