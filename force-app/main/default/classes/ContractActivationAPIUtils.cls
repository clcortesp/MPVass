/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 27-08-2024
 * @last modified by  : Juan Felipe Muriel
**/
public with sharing class ContractActivationAPIUtils {
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractActivation').DeveloperName;
    public static final String EMPTY = '';


    /**
    * @description Método el cual actualza el contrato con el Lookup de la integración
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param contractId Id del contrato a actualizar
    * @param integrationStatusId Id del registro del log de la transacción
    **/
    public static void updateContract(Id contractId,  Id integrationStatusId){
        if(contractId != null && integrationStatusId != null){
            Contract contractToUpdate = new Contract(Id = contractId,MPContractActivationStatus__c = integrationStatusId );
            update contractToUpdate;
        }
    }

    /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Juan Felipe Muriel | 22-08-2024 
    * @param callManager Instancia del callManager
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(ContractActivationAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getContract() != null ? callManager.getContract().Id : null;
        updatedIntStat.MPStatus__c             = callManager.getContractActivationWrapper().status;
        updatedIntStat.MPRequest__c            = EMPTY;
        updatedIntStat.MPRequestDateTime__c    = callManager.getContractActivationWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.getContractActivationWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.getContractActivationWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.getContractActivationWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.getContractActivationWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.getContractActivationWrapper().httpCode;

        return updatedIntStat;
    }
}