/**
 * @description Apex class exposed as a REST web service responsible for receiving all invoices 
 * paid from SAP.
 * @group MP Project
 * @author Juan Felipe Muriel
 * @since 10-30-2024 - Creation
 * @TestClass InvoicePaidAPITest
 */
@RestResource(urlMapping='/invoices/paid')
global with sharing class InvoicePaidAPI {
    /** Integration name */
    public static final String  INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPInvoicePaid').DeveloperName;
    /** Http code to send */
    public static final Integer  SUCCESS_HTTP_CODE = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);

    /**
    * @description Method exposed for POST requests
    * @author Juan Felipe Muriel | 30-10-2024 
    **/
    @HttpPost
    global static void updateInvoice() {

        MPIntegrationStatus__c log = new MPIntegrationStatus__c();
        InvoicePaidService.InvoicePaidWrapper invoiceWrapper = new InvoicePaidService.InvoicePaidWrapper();
        MPInvoice__c invoiceRecord = null;

        try {
            /* Adding initial log's data */
            log.MPIntegrationName__c    = INTEGRATION_NAME;
            log.MPParams__c             = RestContext.request.requestURI;
            log.MPRequest__c            = RestContext.request.requestBody.toString();
            log.MPRequestDateTime__c    = System.now();
            log.MPStatus__c             = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');

            /* Process the request */
            invoiceWrapper = InvoicePaidService.getWrapper(RestContext.request.requestBody.toString());
            InvoicePaidService.validateWrapper(invoiceWrapper);
            invoiceRecord = InvoicePaidService.getInvoice(invoiceWrapper);
            invoiceRecord = InvoicePaidService.addInvoiceData(invoiceWrapper, invoiceRecord);
            InvoicePaidService.updateInvoice(invoiceRecord);

        } catch (Exception e) {
            /* Error handling */
            log.MPSalesforceException__c= Utilities_cls.getSalesforceStackTrace(e);
            log.MPStatus__c             = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
            System.debug(e.getMessage());

        } finally {
            /** Completing log values ​​*/
            log.MPResponseDateTime__c   = System.now();
            log.MPParentId__c           = invoiceRecord != null ? invoiceRecord.Id : null;
            log.MPHttpCode__c           = SUCCESS_HTTP_CODE;
            insert log;

            /** Associate the log with the Invoice record */
            if(invoiceRecord != null){
                invoiceRecord.MPInvoicePaidAPIStatus__c = log.Id;
                update invoiceRecord;
            }

            /**
            The client uses a middleware that makes the call to the Salesforce web service, but it cannot handle 
            failures. For this reason:

            1. Even if the integration fails due to business logic, a successful http code will always be responded 
               to the server that makes the call to the web service; however, the log record will indicate the 
               error to the Salesforce administrator.
            2. It is not possible to send a success code during server errors and/or those that cannot be captured 
               from the try catch block
            */            
            RestContext.response.statusCode = SUCCESS_HTTP_CODE;
        }
    }
}