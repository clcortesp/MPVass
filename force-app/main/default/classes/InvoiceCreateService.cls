/**
 * @description       : Servicio para manejar la lógica de negocio en la creación de facturas.
 * @author            : Luis Sandoval
 * @group             : 
 * @last modified on  : 31-10-2024
 * @last modified by  : Luis Sandoval
**/
public with sharing class InvoiceCreateService {
    
    public static final String SLASH = '/';
    public static final String EMPTY = '';
    public static final String INVOICEID_NOT_PROVIDED_MESSAGE = 'Invoice ID was not provided';
    public static final String INVOICE_NOT_FOUND_MESSAGE = 'Invoice not found';
    public static final String WRAPPER_MAPPING_ERROR_MESSAGE = 'Error mapping JSON to InvoiceCreateWrapper';

   

    /**
     * @description Retrieves an `MPInvoice__c` record based on the invoice number.
     * @param invoiceNumber The invoice number.
     * @return The corresponding `MPInvoice__c` record. No se utiliza de momento
     **/
    /*
    public static MPInvoice__c getInvoiceByNumber(String invoiceNumber) {
                System.debug('invoiceNumber '+invoiceNumber);
        List<MPInvoice__c> invoicesList = [
            SELECT Id, CurrencyIsoCode
            FROM   MPInvoice__c
            WHERE  MPInvoiceNumber__c =: invoiceNumber
        ];
                System.debug('invoicesList '+invoicesList);

        if (invoicesList.isEmpty()) {
            throw new IntegrationExceptions.BusinessException(INVOICE_NOT_FOUND_MESSAGE);
        }
        return invoicesList[NumbersEnum.CERO.ordinal()];
    }*/

    /**
     * @description Validates and adjusts the wrapper based on specific business rules.
     * @param wrapper The received `InvoiceWrapper` instance.
     * @return The validated and adjusted wrapper.
     **/
    public static InvoiceWrapper validateAndFilterWrapper(InvoiceWrapper wrapper) {
        wrapper.grossAmount = getAdjustedGrossAmount(wrapper.grossAmount, wrapper.currencyIsoCode);
        return wrapper;
    }

    /**
     * @description Adjusts the gross amount based on the currency.
     * @param grossAmount The initial gross amount.
     * @param currencyIsoCode The currency ISO code.
     * @return The adjusted amount.
     **/
    private static Decimal getAdjustedGrossAmount(Decimal grossAmount, String currencyIsoCode) {
        // Adjustment logic based on the currency code (you can add specific conditions here)
        return grossAmount;  // In this example, the value is returned unchanged
    }

    /**
     * @description Creates the `Invoice__c` record and related documents.
     * @param wrapper The processed `InvoiceWrapper`.
     * @return The ID of the created invoice record.
     **/    
    public static String createInvoiceRecords(InvoiceWrapper wrapper) {
        System.debug('wrapper '+wrapper);
        Order ord = [SELECT Id, Contract.MPExternalCode__c, MP_Local__r.MPSociety__r.MPExternalCode__c
                     FROM   Order 
                     Where Contract.MPExternalCode__c =: wrapper.contractId 
                     AND  RecordType.Name = 'Término'
                     AND MPStage__c != 'Cerrado Ganado' AND MPStage__c !='Cerrado Perdido'
                     LIMIT 1]; 
        MPInvoice__c invoice = new MPInvoice__c();
        invoice.MPInvoiceNumber__c    = wrapper.invoiceNumber;
        invoice.MPCreatedAt__c        = wrapper.createdAt;
        invoice.MPGrossAmount__c      = wrapper.grossAmount;
        invoice.CurrencyIsoCode  = wrapper.currencyIsoCode;
        invoice.Orden__c = ord.Id;
        if(wrapper.relatedDocs != null){
            invoice.MPDocumentId__c = wrapper.relatedDocs[0].docId;
            invoice.MPDocumentType__c = wrapper.relatedDocs[0].docType;
            invoice.MPDescription__c = wrapper.relatedDocs[0].description;
        }
        insert invoice; 
        return invoice.Id;
    }
}