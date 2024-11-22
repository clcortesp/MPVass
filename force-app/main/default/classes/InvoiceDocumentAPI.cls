/**
 * @description       : API para recibir facturas documentadas desde SAP.
 * @author            : Luis Sandoval
 * @group             : 
 * @last modified on  : 01-11-2024
 * @last modified by  : Luis Sandoval
**/
@RestResource(urlMapping='/invoices/documented/')
global class InvoiceDocumentAPI {  

    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPInvoiceDocument').DeveloperName;
    public static final Integer SUCCESS_HTTP_CODE = Integer.valueOf(Label.MPIntegrationHTTPSuccessCode);

    @HttpPost
    global static void recieveInvoiceDocumented() {

        MPIntegrationStatus__c log = new MPIntegrationStatus__c();
        String invoiceId = null;

        try {
            /* Adding initial log's data */
            log.MPIntegrationName__c    = INTEGRATION_NAME;
            log.MPParams__c             = RestContext.request.requestURI;
            log.MPRequest__c            = RestContext.request.requestBody.toString();
            log.MPRequestDateTime__c    = System.now();
            log.MPStatus__c             = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');

            /* Process the request */
            InvoiceWrapper wrapper = (InvoiceWrapper) JSON.deserialize(RestContext.request.requestBody.toString(), InvoiceWrapper.class);
            System.debug('wrapper '+wrapper);
            String invoiceNumber = wrapper.invoiceNumber;
            System.debug('invoiceNumber '+invoiceNumber);
            invoiceId = InvoiceDocumentService.updateInvoiceDocument(wrapper);
             System.debug('invoiceId '+invoiceId);

        } catch (Exception e) {
            /* Handling errors */
            System.debug('e.getMessage() '+e.getMessage());
            log.MPSalesforceException__c= Utilities_cls.getSalesforceStackTrace(e);
            log.MPStatus__c             = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
            System.debug(e.getMessage());

        } finally {
            /** Complete log's data */
            log.MPResponseDateTime__c   = System.now();
            log.MPParentId__c           = invoiceId != null ? invoiceId : null;
            log.MPHttpCode__c           = SUCCESS_HTTP_CODE;
            insert log;
            System.debug('log '+log);
            System.debug('invoiceId '+invoiceId);

            /** Add log to the FTC record*/
            if(invoiceId != null){

               MPInvoice__c invoiceRecord = new MPInvoice__c(Id=invoiceId, MPInvoiceDocumentAPIStatus__c = log.Id);
               System.debug('invoiceRecord '+invoiceRecord);
               update invoiceRecord;
               System.debug('invoiceRecord au '+invoiceRecord);
            }
            /** Always respond with success http code */ 
            RestContext.response.statusCode = SUCCESS_HTTP_CODE;
        }
    }
}