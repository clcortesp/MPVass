/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 29-08-2024
 * @last modified by  : Juan Felipe Muriel
**/
public with sharing class ContractModificationAPIUtils {
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractModification').DeveloperName;

    /**
    * @description Método el cual actualza el contrato con el Lookup de la integración
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param contractId Id del contrato a actualizar
    * @param integrationStatusId Id del registro del log de la transacción
    **/
    public static void updateContract(Id contractId,  Id integrationStatusId){
        if(contractId != null && integrationStatusId != null){
            Contract contractToUpdate = new Contract(Id = contractId, MPContractModificationStatus__c = integrationStatusId );
            update contractToUpdate;
        }
    }

    /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Juan Felipe Muriel | 22-08-2024 
    * @param callManager Instancia del callManager
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(ContractModificationAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getContract() != null ? callManager.getContract().Id : null;
        updatedIntStat.MPStatus__c             = callManager.getContractWrapperSAP().status;
        updatedIntStat.MPRequest__c            = JSON.Serialize(callManager.getContractWrapperSAP().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.getContractWrapperSAP().requestDateTime;
        updatedIntStat.MPResponse__c           = JSON.Serialize(callManager.getContractWrapperSAP().response);
        updatedIntStat.MPResponseDateTime__c   = callManager.getContractWrapperSAP().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.getContractWrapperSAP().params);
        updatedIntStat.MPSalesforceException__c= callManager.getContractWrapperSAP().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.getContractWrapperSAP().httpCode;

        // Si la transacción está marcada como error, solo agregar en la respuesta el error de callOut
        if(callManager.getContractWrapperSAP().status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            updatedIntStat.MPResponse__c = callManager.getContractWrapperSAP().errorMessage != null ? callManager.getContractWrapperSAP().errorMessage : null;
        }else{
            updatedIntStat.MPResponse__c = callManager.getContractWrapperSAP().response != null ? JSON.serialize(callManager.getContractWrapperSAP().response) : null ;
        }
        return updatedIntStat;
    }
}