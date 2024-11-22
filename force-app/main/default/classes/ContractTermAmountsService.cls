/**
 * @description Service class containing logic required for the ContractTermAmountsAPI class
 * @group MP Project
 * @author Juan Felipe Muriel
 * @since 10-30-2024 - Creation
 * @TestClass ContractTermAmountsAPITest
 */
public with sharing class ContractTermAmountsService {
    /** FTC Approved status */
    public static final string APPROVED_STATUS = Label.MPApprovedFTCStatus;
    /** Error message when the contractId is not provided */
    public static final string CONTRACTID_NOT_PROVIDED_MESSAGE = Label.MPContractIdNotProvidedMsg;
    /** Error message when the contractId is not found */
    public static final string CONTRACTID_NOT_FOUND_MESSAGE = Label.MPContractNotFound;
    /** Error message when the FTC is not found */
    public static final string FTC_NOT_FOUND_MESSAGE = Label.MPFtcNotFound;
    /** Error message when the request body is not as expected */
    public static final string WRAPPER_MAPPING_ERROR_MESSAGE = Label.MPMappingError;
    /** Initial FTC Status, to validate if this integration should run or not */
    public static final string FTC_STATUS = Label.MPFTCStatus;
    public static final String SLASH = '/';
    public static final String EMPTY = '';

    /**
    * @description Extracts the contractId from the request URL. If the contractId is not found in 
    * the URI, a custom exception is thrown.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param fullUri requestURI
    * @return Contract external Id (Used in SAP).
    */
    public static String getContractIdByURI(String fullUri){
        List<String> uriParts = fullUri.split(SLASH);
        String contractId = uriParts[NumbersEnum.TRES.ordinal()] != EMPTY ? uriParts[NumbersEnum.TRES.ordinal()] : null;
        if(contractId == null){
            throw new IntegrationExceptions.BusinessException(CONTRACTID_NOT_PROVIDED_MESSAGE);
        }
        return contractId;
    }

    /**
    * @description Gets the contract according to the external Id, If the contract cannot be found,
    * a custom exception is thrown.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param contractId Contract external Id (Used in SAP)
    * @return related Contract object.
    */
    public static Contract getContractById(String contractId){
        List<Contract> contractsRelatedList = new List<Contract>();
        contractsRelatedList = [
            SELECT Id,
                   CurrencyIsoCode
            FROM   Contract 
            WHERE  MPExternalCode__c =: contractId
        ];

        if(contractsRelatedList.isEmpty()){
            throw new IntegrationExceptions.BusinessException(CONTRACTID_NOT_FOUND_MESSAGE);
        }
        Contract contractRelated = contractsRelatedList[NumbersEnum.CERO.ordinal()];
        return contractRelated;
    }

    /**
    * @description Gets the FTC record related to the contract according to the contract external Id.
    * If the contract cannot be found, a custom exception is thrown.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param contractId Contract external Id (Used in SAP)
    * @return FTC Id.
    */
    public static String getFTCIdByContractId(String contractId){
        String ftcId = null;
        List<MPContractTerminationRecords__c> ftcList = new List<MPContractTerminationRecords__c>();
        ftcList = [
            SELECT Id, MPOrder__c,MPOrder__r.ContractId, MPOrder__r.Contract.MPExternalCode__c
            FROM   MPContractTerminationRecords__c 
            WHERE  MPOrder__r.Contract.MPExternalCode__c =: contractId
            AND    MPStatus__c =: FTC_STATUS 
        ];

        if(ftcList.isEmpty()){
            throw new IntegrationExceptions.BusinessException(FTC_NOT_FOUND_MESSAGE);
        }else{
            ftcId = ftcList[NumbersEnum.CERO.ordinal()].Id;
        }
        return ftcId;
    }
    
    /**
    * @description Converts the request body (JSON) to a ContractTermWrapper class structure that contains
    * all the attributes that are supposed to be received via the web service. If the request body is empty 
    * or does not match the expected one, a custom exception is thrown.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param requestJson request body
    * @return Request body in ContractTermWrapper format.
    */
    public static List<ContractTermWrapper> getWrapper(String requestJson){
        List<ContractTermWrapper> wrapperList = new List<ContractTermWrapper>();
        try {
            wrapperList = (List<ContractTermWrapper>) JSON.deserialize(requestJson, List<ContractTermWrapper>.class);
        } catch (Exception e) { 
            throw new IntegrationExceptions.BusinessException(WRAPPER_MAPPING_ERROR_MESSAGE + ' ' + Utilities_cls.getSalesforceStackTrace(e));
        }
        return wrapperList;
    }

    /**
    * @description Iterates through all wrapper elements and adds related information such as the 
    * FTC record id.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param wrapperList Information received in the request body and transformed to the ContractTermWrapper type
    * @param contractCurrency Currency according to Contract record
    * @param ftcId FTC Id related to the request
    * @return processed wrapperList.
    */
    public static List<ContractTermWrapper> filterWrapper(List<ContractTermWrapper> wrapperList, String contractCurrency, String ftcId){
        for(ContractTermWrapper wrapper : wrapperList){
            wrapper.itemValue = getItemValueByCurrency(wrapper.itemValues, contractCurrency);
            wrapper.ftc = ftcId;
        }
        return wrapperList;
    }

    /**
    * @description Iterates through all itemElements (ContractTermWrapper.ItemValue) and extracts only 
    * the 'item.oValue' field of the item that has the same currency as the contract.
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param itemsList List of itemValues ​​with different currencies
    * @param contractCurrency Currency according to Contract record
    * @return item value.
    */
    private static Decimal getItemValueByCurrency(List<ContractTermWrapper.ItemValue> itemsList, String contractCurrency){
        if(!itemsList.isEmpty()){
            for(ContractTermWrapper.ItemValue item : itemsList){
                if(item.currencyIsoCode == contractCurrency){
                    return item.oValue;
                }
            }
        }

        return null;
    }

    /**
    * @description Creates all 'MPTerminationRecord__c' records that have already been processed previously
    * @author Juan Felipe Muriel | 30-10-2024 
    * @param wrapperList Information received in the request body and transformed to the ContractTermWrapper type
    */
    public static void createTerminationRecords(List<ContractTermWrapper>  wrapperList){
        List<MPTerminationRecord__c> termRecordList = new List<MPTerminationRecord__c>();
        for(ContractTermWrapper wrapper : wrapperList){
            MPTerminationRecord__c termRecordTemp = new MPTerminationRecord__c();
            termRecordTemp.MPCategory__c            = wrapper.category;
            termRecordTemp.MPItemCode__c            = wrapper.itemCode;
            termRecordTemp.MPDescription__c         = wrapper.description;
            termRecordTemp.MPReferenceDocument__c   = wrapper.documentReference;
            termRecordTemp.MPDocumentDueDate__c     = wrapper.documentDueDate;
            termRecordTemp.MPDocumentDate__c        = wrapper.documentDate;
            termRecordTemp.MPDocumentNumber__c      = wrapper.documentNumber;
            termRecordTemp.MPSubcategory__c         = wrapper.subcategory;
            termRecordTemp.MPDocumentType__c        = wrapper.documentType;
            termRecordTemp.MPOperationType__c       = wrapper.operationType;
            termRecordTemp.MPStatus__c              = APPROVED_STATUS;
            termRecordTemp.FTC__c                   = wrapper.ftc;
            termRecordTemp.MPItemValue__c           = wrapper.itemValue;
            // Add termRecord to insert
            termRecordList.add(termRecordTemp);
        }

        if(!termRecordList.isEmpty()){
            insert termRecordList;
        }
    }    
}