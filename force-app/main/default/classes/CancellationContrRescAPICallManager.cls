/**
 * @description Clase que administra las llamadas una a la API de Cancelación Terminación de contratos y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Miller
 * @since 9-10-2024 - Creación
 */
public with sharing class CancellationContrRescAPICallManager implements ICallManager {

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private CancellationContrRescAPIWrapper cancellationContrRescAPIWrapper;
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

    public CancellationContrRescAPICallManager(Order order, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.cancellationContrRescAPIWrapper = new CancellationContrRescAPIWrapper();
        this.order = order;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
        this.parentId = order.Id;      
    }

    public void execute(){
        try {
            prepareParamsData();   // Obtener los parametros para hacer la petición
            //prepareRequestData();   // Obtener datos necesarios para hacer la petición
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
            this.cancellationContrRescAPIWrapper.params = BusinessRuleDataFactory.CancellationContrRescAPIParams(this.order);
        }
    }

    private void executeCallout() {
        this.cancellationContrRescAPIWrapper = CancellationContRescAPICallOutService.makeCallout(this.cancellationContrRescAPIWrapper);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = CancellationContrRescAPIUtils.modifyIntegrationLog(this);
    }

    private void handleException(Exception e){
        this.cancellationContrRescAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.cancellationContrRescAPIWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
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
        Boolean successStatus = this.retryEnabled && this.cancellationContrRescAPIWrapper.status == Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        
        // Condición 3: Reintentos habilitados y se alcanzó el máximo de reintentos.
        Boolean maxRetriesReached = this.retryEnabled &&  MAX_RETRIES != null && this.retryCount == MAX_RETRIES;
        
        if (noRetryEnabled || successStatus || maxRetriesReached) {
            Utilities_cls.updateIntegrationStatus(this.integrationStatus);
        }
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.cancellationContrRescAPIWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            
            CancellationContrRescAPICallManager newCallManager;
            if(this.order != null) {
                newCallManager = new CancellationContrRescAPICallManager(this.order,this.retryEnabled, this.integrationStatus);
            }
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    } 


    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }

    public CancellationContrRescAPIWrapper cancellationContrRescAPIWrapper() {
        return this.cancellationContrRescAPIWrapper;
    }

    public String getParentId() {
        return this.parentId;
    }

}