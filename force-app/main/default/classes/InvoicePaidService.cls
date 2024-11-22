/**
 * @description Service class containing logic required for the InvoicePaidAPI class
 * @group MP Project
 * @author Juan Felipe Muriel
 * @since 10-31-2024 - Creation
 * @TestClass InvoicePaidAPITest
 */
public with sharing class InvoicePaidService {

    /** Error message when the request body is not as expected */
    public static final string WRAPPER_MAPPING_ERROR_MESSAGE = Label.MPMappingError;
    /** Error message when the contractId is not provided */
    public static final string CONTRACTID_NOT_PROVIDED_MESSAGE = Label.MPContractIdNotProvidedMsg;
    /** Error message when the invoice number is not provided */
    public static final string INVOICE_NUMBER_NOT_PROVIDED_MESSAGE = Label.MPInvoiceNumberNotProvidedMsg;
    /** Error message when the invoice is not found */
    public static final string INVOICE_NOT_FOUND_MESSAGE = Label.MPInvoiceNotFound;
    /** Error message when the invoice is not found */
    public static final String INVOICE_ERROR_UPDATE_MESSAGE = Label.MPInvoiceErrorUpdateMsg;
    public static final String CLOSED_WON_ORDER_STATUS = Label.MPOrderClosedWonStatus;
    public static final String CLOSED_LOST_ORDER_STATUS = Label.MPOrderClosedLostStatus;
    public static final Id TERMINATION_ORDER_RT_ID = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MPTermination').getRecordTypeId();
    
    /**
     * @description This class extends the InvoiceWrapper class which contains the main attributes of the 
     * invoice in SAP. Additional fields used in the 24.2 integration are added. 
     */
    public class InvoicePaidWrapper extends InvoiceWrapper{
        public InvoicePaidWrapper() {
            super();
        }
        /** Additional request atributes for 24.2 SAP integration */
        public String validFrom { get; set; } 
        public String paymentDate { get; set; } 
        public String percentagePayment { get; set; }
    }

    /**
    * @description Takes the information received in the request body and transforms it into a data 
    * structure corresponding to InvoicePaidWrapper class, that contains the expected attributes.
    * @author Juan Felipe Muriel | 10-31-2024
    * @param requestJson request body
    * @return Request body in ContractTermWrapper format.
    */
    public static InvoicePaidWrapper getWrapper(String requestJson){
        InvoicePaidWrapper invoiceWrapper = new InvoicePaidWrapper();
        try {
            invoiceWrapper = (InvoicePaidWrapper) JSON.deserialize(requestJson, InvoicePaidWrapper.class);
        } catch (Exception e) { 
            throw new IntegrationExceptions.BusinessException(WRAPPER_MAPPING_ERROR_MESSAGE + ' ' + Utilities_cls.getSalesforceStackTrace(e));
        }
        return invoiceWrapper;
    }

    /** 
    * @description Run data validations
    * @author Juan Felipe Muriel | 10-31-2024
    * @param requestJson request body
    */
    public static void validateWrapper(InvoicePaidService.InvoicePaidWrapper invoiceWrapper){
        if(String.isBlank(invoiceWrapper.contractId)){
            throw new IntegrationExceptions.BusinessException(CONTRACTID_NOT_PROVIDED_MESSAGE);
        }
        if(String.isBlank(invoiceWrapper.invoiceNumber)){
            throw new IntegrationExceptions.BusinessException(INVOICE_NUMBER_NOT_PROVIDED_MESSAGE);
        }
    }

    /**
    * @description Gets the invoice record that matches the external contract id and other order conditions
    * @author Juan Felipe Muriel | 10-31-2024 
    * @param invoiceWrapper Invoice data in wrapper format
    * @return Invoice record.
    */
    public static MPInvoice__c getInvoice(InvoicePaidService.InvoicePaidWrapper invoiceWrapper){
        List<MPInvoice__c> invoiceList = new List<MPInvoice__c>();
        invoiceList = [
            SELECT   Id
            FROM     MPInvoice__c 
            WHERE    MPInvoiceNumber__c =:  invoiceWrapper.invoiceNumber
            AND      Orden__r.RecordType.Id =: TERMINATION_ORDER_RT_ID
            AND      Orden__r.Contract.MPExternalCode__c =: invoiceWrapper.contractId
            AND      (Orden__r.MPStage__c !=: CLOSED_WON_ORDER_STATUS OR Orden__r.MPStage__c !=: CLOSED_LOST_ORDER_STATUS)
            ORDER BY CreatedDate DESC
        ];

        if(invoiceList.isEmpty()){
            throw new IntegrationExceptions.BusinessException(INVOICE_NOT_FOUND_MESSAGE);
        }
        return invoiceList[NumbersEnum.CERO.ordinal()];
    }

    /**
    * @description Add new invoice data with the incoming information from the integration.
    * @author Juan Felipe Muriel | 10-31-2024
    * @param invoiceWrapper Invoice data in wrapper format
    * @param invoiceRecord Invoice record to update
    * @return invoice to update
    */
    public static MPInvoice__c addInvoiceData(InvoicePaidService.InvoicePaidWrapper invoiceWrapper, MPInvoice__c invoiceRecord){
        
        invoiceRecord.MPInvoiceNumber__c = String.isNotBlank(invoiceWrapper.invoiceNumber) ? invoiceWrapper.invoiceNumber : null;
        invoiceRecord.MPValidFrom__c = String.isNotBlank(invoiceWrapper.validFrom) ? Date.valueOf(invoiceWrapper.validFrom) : null;
        invoiceRecord.MPPaymentDate__c = String.isNotBlank(invoiceWrapper.paymentDate) ? Date.valueOf(invoiceWrapper.paymentDate) : null;
        String percentagePaymentSt = String.isNotBlank(invoiceWrapper.percentagePayment) ? invoiceWrapper.percentagePayment : null;
        if(String.isNotBlank(percentagePaymentSt)){
            invoiceRecord.MPPercentagePayment__c = Decimal.valueOf(percentagePaymentSt);
        }
        if(!invoiceWrapper.relatedDocs.isEmpty()){
            InvoiceWrapper.RelatedDoc relDoc =invoiceWrapper.relatedDocs[NumbersEnum.CERO.ordinal()];
            invoiceRecord.MPDocumentId__c = String.isNotBlank(relDoc.docId) ? relDoc.docId : null;
            invoiceRecord.MPDocumentType__c = String.isNotBlank(relDoc.docType) ? relDoc.docType : null;
            invoiceRecord.MPDescription__c = String.isNotBlank(relDoc.description) ? relDoc.description : null;
        }
        return invoiceRecord;
    }

    /**
    * @description Updates the invoice in the database with the incoming information from the integration
    * @author Juan Felipe Muriel | 10-31-2024
    * @param invoiceRecord Invoice record to update
    */
    public static void updateInvoice(MPInvoice__c invoiceRecord){
        try {
            update invoiceRecord;
        } catch (Exception e) {
            throw new IntegrationExceptions.BusinessException(INVOICE_ERROR_UPDATE_MESSAGE + ' ' + Utilities_cls.getSalesforceStackTrace(e));
        }
    }
}