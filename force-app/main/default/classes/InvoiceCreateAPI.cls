/**
 * @description       : API para crear facturas recibidas desde SAP.
 * @author            : Luis Sandoval
 * @group             : 
 * @last modified on  : 29-10-2024
 * @last modified by  : Luis Sandoval
**/
@RestResource(urlMapping='/invoices/created')
global class InvoiceCreateAPI { 

    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPInvoiceCreate').DeveloperName;
    public static final Integer SUCCESS_HTTP_CODE = Integer.valueOf(Label.MPIntegrationHTTPSuccessCode);

    @HttpPost
    global static void createInvoiceRecord() {

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
            String invoiceNumber = wrapper.invoiceNumber;
            wrapper = InvoiceCreateService.validateAndFilterWrapper(wrapper);
            invoiceId = InvoiceCreateService.createInvoiceRecords(wrapper);

        } catch (Exception e) {
            /* Handling errors */
            log.MPSalesforceException__c= Utilities_cls.getSalesforceStackTrace(e);
            log.MPStatus__c             = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
            System.debug(e.getMessage());

        } finally {
            /** Complete log's data */
            log.MPResponseDateTime__c   = System.now();
            log.MPParentId__c           = invoiceId != null ? invoiceId : null;
            log.MPHttpCode__c           = SUCCESS_HTTP_CODE;
            insert log;

            /** Add log to the FTC record*/
            if(invoiceId != null){
               MPInvoice__c invoiceRecord = new MPInvoice__c(Id=invoiceId, MPInvoiceAPIStatus__c = log.Id);
               update invoiceRecord;
            }
            /** Always respond with success http code */ 
            RestContext.response.statusCode = SUCCESS_HTTP_CODE;
        }
    }
}