/**
 * @description Clase tipo invocable que llama la clase manager de la intergracion 4.9 Termino de Contrato Rechazo
 * @group Proyecto MP
 * @author Miller Mora
 * @since 21-10-2024 - Creación
 */
public with sharing class RejectContractRescissionAPI_Inv {

    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').DeveloperName;
    /** Número máximo de reintentos a la API */
    public static final Boolean RETRY = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPRetry__c;

    /**
     * @description Método invocable para ser llamado desde un Flow.
     * Este método encola un trabajo Queueable que ejecutará la lógica del RejectContractRescissionAPICallManager.
     * @author Miller Mora | 21-10-2024
     * @param FTCIds List<Id> - Lista de IDs de los FTC que serán procesadas.
     */
    @InvocableMethod(label='Invoke Call Manager from Flow RejectContractRescissionAPI' description='Invokes the Call Manager Queueable from Flow')
    public static void invokeFromFlowRejectContractRescissionAPI(List<MPContractTerminationRecords__c> lstFTC) {

        MPContractTerminationRecords__c objFTC = lstFTC[NumbersEnum.CERO.ordinal()];
        if(objFTC != null){
            // Creación del log de integración
            MPIntegrationStatus__c intStatus = getIntStatus(objFTC.Id);
            insert intStatus;

            System.debug('intStatus intStatus' + intStatus.MPStatus__c);
            // Ejecutar integración
            RejectContrRescissionAPICallManager callManager = new RejectContrRescissionAPICallManager(objFTC,RETRY,intStatus);
            System.enqueueJob(new CallManagerQueueable(callManager));
        }

   }


    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Miller Mora | 21-10-2024 
     * @param FTCId Id de la FTC
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id FTCId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c    = INTEGRATION_NAME;
        newLog.MPParentId__c           = String.valueOf(FTCId);
        newLog.MPStatus__c             = IN_PROGRESS_STATUS;
        return newLog;
    }
}