/**
 * @description       : Servicio para manejar la lógica de negocio en la recepción de facturas documentadas.
 * @author            : Luis Sandoval
 * @group             : 
 * @last modified on  : 01-01-2024
 * @last modified by  : Luis Sandoval
**/
public with sharing class InvoiceDocumentService { 
    public static final String SLASH = '/';
    public static final String EMPTY = '';
    public static final String INVOICEID_NOT_PROVIDED_MESSAGE = 'Invoice ID was not provided';
    public static final String INVOICE_NOT_FOUND_MESSAGE = 'Invoice not found';
    public static final String WRAPPER_MAPPING_ERROR_MESSAGE = 'Error mapping JSON to InvoiceDocumentWrapper';
	 

    /**
     * @description Update the `Invoice__c` record.
     * @param wrapper The processed `InvoiceWrapper`.
     * @return The ID of the updated invoice record.
     **/    
    public static String updateInvoiceDocument(InvoiceWrapper wrapper) {
        System.debug('wrapper '+wrapper);
        try{
        MPInvoice__c invoice = [Select Id,MPCreatedAt__c,MPDocumentId__c,MPDocumentType__c,MPDescription__c
                                From MPInvoice__c Where MPInvoiceNumber__c =: wrapper.invoiceNumber];
                System.debug('invoice '+invoice);
            invoice.MPCreatedAt__c = wrapper.createdAt;
        /*if(wrapper.relatedDocs != null){
            invoice.MPDocumentId__c = wrapper.relatedDocs[0].docId;
            invoice.MPDocumentType__c = wrapper.relatedDocs[0].docType;
            invoice.MPDescription__c = wrapper.relatedDocs[0].description;
        }*/
        update invoice; 
                System.debug('invoice '+invoice);
        return invoice.Id;
       }catch(Exception e){
			System.debug('Error--'+e.getMessage());
           return e.getMessage();
		}
    }

}