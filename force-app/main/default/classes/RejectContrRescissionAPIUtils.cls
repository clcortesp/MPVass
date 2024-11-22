/**
 * @description Clase utlitaria de RejectContrRescissionAPICallManager
 * @group Proyecto MP
 * @author Miller
 * @since 22-10-2024 - Creación
 */
public with sharing class RejectContrRescissionAPIUtils {
    
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').DeveloperName;

     /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Miller Mora | 22-08-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(RejectContrRescissionAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getParentId();
        updatedIntStat.MPStatus__c             = callManager.rejectContrRescissionAPIWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.rejectContrRescissionAPIWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.rejectContrRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.rejectContrRescissionAPIWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.rejectContrRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.rejectContrRescissionAPIWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.rejectContrRescissionAPIWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.rejectContrRescissionAPIWrapper().httpCode;
        System.debug('updatedIntStat' + updatedIntStat);
        return updatedIntStat;
    }
}