/**
 * @description Clase utlitaria de CancellationContrRescAPICallManager
 * @group Proyecto MP
 * @author Miller
 * @since 29-10-2024 - Creación
 */
public with sharing class CancellationContrRescAPIUtils {
   
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').DeveloperName;

     /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Miller Mora | 29-10-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(CancellationContrRescAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getParentId();
        updatedIntStat.MPStatus__c             = callManager.cancellationContrRescAPIWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.cancellationContrRescAPIWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.cancellationContrRescAPIWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.cancellationContrRescAPIWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.cancellationContrRescAPIWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.cancellationContrRescAPIWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.cancellationContrRescAPIWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.cancellationContrRescAPIWrapper().httpCode;
        System.debug('updatedIntStat' + updatedIntStat);
        return updatedIntStat;
    }
}