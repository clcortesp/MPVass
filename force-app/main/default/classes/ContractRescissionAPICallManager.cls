/**
 * @description Clase que administra las llamadas una a la API de Terminación de contratos y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Miller
 * @since 17-10-2024 - Creación
 */
public with sharing class ContractRescissionAPICallManager implements ICallManager{

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractRescission').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private ContractRescissionAPIWrapper contractRescissionAPIWrapper;
    /** Orden de terminación de contrato */
    private Order order;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
    /** Log de la integración */
    private MPIntegrationStatus__c integrationStatus;
    /** Id del registro en el cual se va a dejar la traza*/
    private String parentId;

    public ContractRescissionAPICallManager(Order order, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.contractRescissionAPIWrapper = new ContractRescissionAPIWrapper();
        this.order = order;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
        this.parentId = order.Id;      
    }

    public void execute(){
        try {
            prepareParamsData();   // Obtener los parametros para hacer la petición
            prepareRequestData();   // Obtener datos necesarios para hacer la petición
            executeCallout();       // Hacer llamada a la API
            modifyIntegrationLog(); // Agregar datos al log
            //updateRelatedRecords(); // Actualizar registros relacionados
        } catch (Exception e) {
            handleException(e);     // Acciones a tomar despues de una exepción de Salesforce (diferente al callout)
            modifyIntegrationLog(); // Agregar datos al log
        } finally{
            updateIntegrationLog(); // Actualizar el log de integración
            handleRetries();        // Lógica de reintentos
        }
    }

    private void prepareParamsData() {
        if(this.order != null) {
            this.contractRescissionAPIWrapper.params = BusinessRuleDataFactory.ContractRescissionAPIParams(this.order);
        }
    }

    private void prepareRequestData(){
        this.contractRescissionAPIWrapper.request = BusinessRuleDataFactory.getContractRescissionAPIRequest(this.order);
       // this.contractDatesWrapper.params = BusinessRuleDataFactory.getContractDatesUpdateAPIParams(this.contract);
    }
    private void executeCallout() {
        this.contractRescissionAPIWrapper = contractRescissionAPICallOutService.makeCallout(this.contractRescissionAPIWrapper);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = ContractRescissionAPIUtils.modifyIntegrationLog(this);
    }

    private void handleException(Exception e){
        this.contractRescissionAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.contractRescissionAPIWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
    }

    private void updateIntegrationLog(){
        /**
         * Actualiza el log basado en los siguientes casos:
         * 1. Reintentos deshabilitados.
         * 2. Reintentos habilitados y sin errores en el estado de integración.
         * 3. Reintentos habilitados, pero ya se alcanzó el máximo de intentos.
         */
         
        // Condición 1: Reintentos deshabilitados.
        Boolean noRetryEnabled = !this.retryEnabled;
        
        // Condición 2: Reintentos habilitados y sin errores en la integración.
        Boolean successStatus = this.retryEnabled && this.contractRescissionAPIWrapper.status == Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        
        // Condición 3: Reintentos habilitados y se alcanzó el máximo de reintentos.
        Boolean maxRetriesReached = this.retryEnabled &&  MAX_RETRIES != null && this.retryCount == MAX_RETRIES;
        
        if (noRetryEnabled || successStatus || maxRetriesReached) {
            Utilities_cls.updateIntegrationStatus(this.integrationStatus);
        }
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.contractRescissionAPIWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            
            ContractRescissionAPICallManager newCallManager;
            if(this.order != null) {
                newCallManager = new ContractRescissionAPICallManager(this.order,this.retryEnabled, this.integrationStatus);
            }
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    } 


    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }

    public ContractRescissionAPIWrapper contractRescissionAPIWrapper() {
        return this.contractRescissionAPIWrapper;
    }

    public String getParentId() {
        return this.parentId;
    }
}