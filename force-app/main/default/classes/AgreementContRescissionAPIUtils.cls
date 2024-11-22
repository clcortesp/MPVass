/**
 * @description Clase utlitaria de AgreementContRescissionAPICallManager
 * @group Proyecto MP
 * @author Miller
 * @since 28-10-2024 - Creación
 */
public with sharing class AgreementContRescissionAPIUtils {
   
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPAgreementContRescission').DeveloperName;

     /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Miller Mora | 28-08-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(AgreementContRescissionAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getParentId();
        updatedIntStat.MPStatus__c             = callManager.agreementContRescissionAPIWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.agreementContRescissionAPIWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.agreementContRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.agreementContRescissionAPIWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.agreementContRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.agreementContRescissionAPIWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.agreementContRescissionAPIWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.agreementContRescissionAPIWrapper().httpCode;
        System.debug('updatedIntStat' + updatedIntStat);
        return updatedIntStat;
    }
}