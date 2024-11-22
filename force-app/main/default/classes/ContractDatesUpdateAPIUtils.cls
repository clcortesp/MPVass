/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 27-08-2024
 * @last modified by  : Juan Felipe Muriel
**/
public with sharing class ContractDatesUpdateAPIUtils {
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').DeveloperName;

    /**
    * @description Método el cual actualza el contrato con el Lookup de la integración
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param contractId Id del contrato a actualizar
    * @param integrationStatusId Id del registro del log de la transacción
    **/
    public static void updateContract(Id contractId,  Id integrationStatusId){
        if(contractId != null && integrationStatusId != null){
            Contract contractToUpdate = new Contract(Id = contractId,MPContractDatesUpdateStatus__c = integrationStatusId );
            update contractToUpdate;
        }
    }

    /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Juan Felipe Muriel | 20-08-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(ContractDatesUpdateAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getContract() != null ? callManager.getContract().Id : null;
        updatedIntStat.MPStatus__c             = callManager.getContractDatesWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.getContractDatesWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.getContractDatesWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.getContractDatesWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.getContractDatesWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.getContractDatesWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.getContractDatesWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.getContractDatesWrapper().httpCode;

        return updatedIntStat;
    }

    public static void changeContractStatus(Contract contract, String status){
        String successValue = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        if(contract != null && status == successValue){
            contract.MPStatus__c = Label.MPContractInProcessOfActivation;
            update contract;
        }
    }
}