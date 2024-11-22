/**
 * @description Apex class exposed as a REST web service. Receives elements to associate with a 
 * contract termination record (FTC), which represents everything that will be charged to the 
 * customer in their contract termination process. 
 * @group MP Project
 * @author Juan Felipe Muriel
 * @since 10-30-2024 - Creation
 * @TestClass ContractTermAmountsAPITest
 */
@RestResource(urlMapping='/closeContracts/*/amounts/calculated/')
global class ContractTermAmountsAPI {
    /** Integration name */
    public static final String  INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractTermAmounts').DeveloperName;
    /** Http code to send */
    public static final Integer  SUCCESS_HTTP_CODE = Integer.valueOf(Label.MPIntegrationHTTPSuccessCode);

    /**
    * @description Method exposed for POST requests
    * @author Juan Felipe Muriel | 10-30-2024 
    **/
    @HttpPost
    global static void createTerminationRecord() {

        MPIntegrationStatus__c log = new MPIntegrationStatus__c();
        String ftcId = null;

        try {
            /* Adding initial log's data */
            log.MPIntegrationName__c    = INTEGRATION_NAME;
            log.MPParams__c             = RestContext.request.requestURI;
            log.MPRequest__c            = RestContext.request.requestBody.toString();
            log.MPRequestDateTime__c    = System.now();
            log.MPStatus__c             = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');

            /* Process the request */
            String contractId = ContractTermAmountsService.getContractIdByURI(RestContext.request.requestURI);
            Contract contractRelated = ContractTermAmountsService.getContractById(contractId);
            ftcId = ContractTermAmountsService.getFTCIdByContractId(contractId);
            List<ContractTermWrapper>  wrapperList = ContractTermAmountsService.getWrapper(RestContext.request.requestBody.toString());
            wrapperList = ContractTermAmountsService.filterWrapper(wrapperList, contractRelated.CurrencyIsoCode, ftcId);
            ContractTermAmountsService.createTerminationRecords(wrapperList);

        } catch (Exception e) {
            /* Error handling */
            log.MPSalesforceException__c= Utilities_cls.getSalesforceStackTrace(e);
            log.MPStatus__c             = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
            System.debug(e.getMessage());

        } finally {
            /** Completing log values ​​*/
            log.MPResponseDateTime__c   = System.now();
            log.MPParentId__c           = ftcId != null ? ftcId : null;
            log.MPHttpCode__c           = SUCCESS_HTTP_CODE;
            insert log;

            /** Associate the log with the FTC record */
            if(ftcId != null){
                MPContractTerminationRecords__c ftcTemp = new MPContractTerminationRecords__c(id=ftcId, MPContractTermAmountsAPIStatus__c = log.Id );
                update ftcTemp;
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