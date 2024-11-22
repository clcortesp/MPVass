/**
 * @description Class that manages calls to the GET CONTRACT 4.1 API and
 * controls related actions such as log creation, retries, record updates, among others.
 * @group Proyecto MP
 * @author Miller Mora
 * @since 28-08-2024 - Creation
 */
public with sharing class GetContractAPICallManager implements ICallManager{

    /** Maximum number of API retries */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPGETContract').MPMaximumRetries__c;
    /** Integration name */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPGETContract').DeveloperName;
    /** Seconds between each attempt */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPGETContract').MPSecondsBetweenRetries__c;
    /** Wrapper object that contains the request, response and other details of the callOut */
    private GetContractAPIWrapper getContractAPIWrapper;
    /** Opportunity related */
    private Opportunity opportunity;
    /** Termination order */
    private Order order;
    /** Boolean indicating whether retries should be made after an error */
    private Boolean retryEnabled;
    /** Retry count */
    private Integer retryCount;
    /** Integration log */
    private MPIntegrationStatus__c integrationStatus;
    /** Id of the record in which the log will be left */
    private String parentId;

    public GetContractAPICallManager(Opportunity opportunity, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.getContractAPIWrapper = new GetContractAPIWrapper();
        this.opportunity = opportunity;
        this.retryEnabled = retryEnabled;
        this.retryCount = NumbersEnum.CERO.ordinal();
        this.integrationStatus = integrationStatus;
        this.parentId = opportunity.Id;  
    }

    public GetContractAPICallManager(Order order, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.getContractAPIWrapper = new GetContractAPIWrapper();
        this.order = order;
        this.retryEnabled = retryEnabled;
        this.retryCount = NumbersEnum.CERO.ordinal();
        this.integrationStatus = integrationStatus;
        this.parentId = order.Id;      
    }

    public void execute(){
        try {
            prepareParamsData();    // Obtain the data necessary to make the request
            executeCallout();       // Make API call
            modifyIntegrationLog(); // Add data to the log record
            updateRelatedRecords(); // Update related records
        } catch (Exception e) {
            handleException(e);     // Actions to take after a Salesforce exception (different from callout exceptions)
            modifyIntegrationLog(); // Add data to the log record
        } finally{
            updateIntegrationLog(); // Update log record
            handleRetries();        // retry logic
        }
    }

    private void prepareParamsData() {
        if(this.opportunity != null) {
            this.getContractAPIWrapper.params = BusinessRuleDataFactory.getContractAPIParams(this.opportunity);
        }
        else if(this.order != null) {
            this.getContractAPIWrapper.params = BusinessRuleDataFactory.getContractAPIParams(this.order);
        }
    }
    
    private void executeCallout() {
        this.getContractAPIWrapper = GetContractAPICallOutService.makeCallout(this.getContractAPIWrapper);
    }
    
    private void modifyIntegrationLog(){
        this.integrationStatus = GetContractAPIUtils.modifyIntegrationLog(this);
    }

    private void updateIntegrationLog(){
        /**
        * Updates the log based on the following cases:
        * 1. Retries disabled.
        * 2. Retries enabled and no errors in integration status.
        * 3. Retries enabled, but maximum attempts have already been reached.
        */
         
        // Condition 1: Retries disabled.
        Boolean noRetryEnabled = !this.retryEnabled;
        
        // Condition 2: Retries enabled and no errors in the integration.
        Boolean successStatus = this.retryEnabled && this.getContractAPIWrapper.status == Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        
        // Condition 3: Retries enabled and maximum retries reached.
        Boolean maxRetriesReached = this.retryEnabled &&  MAX_RETRIES != null && this.retryCount == MAX_RETRIES;
        
        if (noRetryEnabled || successStatus || maxRetriesReached) {
            Utilities_cls.updateIntegrationStatus(this.integrationStatus);
        }
    }

    private void updateRelatedRecords() {
        if(this.opportunity != null){
            // Update the MPContractEndDate__c field on the opportunity
            GetContractAPIUtils.updateOpportunityWithEndDate(this.opportunity, this.getContractAPIWrapper.response.message);
        }else if(this.order != null){
            // Update termination order with data from SAP
            GetContractAPIUtils.updateOrder(this.parentId, this.getContractAPIWrapper.response.message);
        }
    }

    private void handleException(Exception e){
        this.getContractAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.getContractAPIWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.getContractAPIWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            
            GetContractAPICallManager newCallManager;
            if(this.opportunity != null) {
                newCallManager = new GetContractAPICallManager(this.opportunity,this.retryEnabled, this.integrationStatus);
            }
            else if(this.order != null) {
                newCallManager = new GetContractAPICallManager(this.order,this.retryEnabled, this.integrationStatus);
            }
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal());
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    } 

    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }

    public GetContractAPIWrapper getContractAPIWrapper() {
        return this.getContractAPIWrapper;
    }

    public String getParentId() {
        return this.parentId;
    }
}