/**
 * @description Clase utlitaria de ContractRescissionAPICallManager
 * @group Proyecto MP
 * @author Miller
 * @since 17-10-2024 - Creación
 */
public with sharing class ContractRescissionAPIUtils {
   
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractRescission').DeveloperName;

     /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Miller Mora | 20-08-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(ContractRescissionAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getParentId();
        updatedIntStat.MPStatus__c             = callManager.contractRescissionAPIWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.contractRescissionAPIWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.contractRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.contractRescissionAPIWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.contractRescissionAPIWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.contractRescissionAPIWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.contractRescissionAPIWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.contractRescissionAPIWrapper().httpCode;
        System.debug('updatedIntStat' + updatedIntStat);
        return updatedIntStat;
    }

}