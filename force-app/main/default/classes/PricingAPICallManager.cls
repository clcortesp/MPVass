/**
 * @description Clase que administra las llamadas una a la API de precios y controla acciones
 * relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
public with sharing class PricingAPICallManager implements ICallManager{

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPPricing').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPPricing').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPPricing').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private PricingAPIWrapper pricingWrapper;
    /** Objeto que se guardará en la BD como Log de la transacción */
    private MPIntegrationStatus__c integrationStatus;
    /** Registro MPQuoteCondition__c el cual desencadena la llamada a la API*/
    private MPQuoteCondition__c mpqc;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
 
    public PricingAPICallManager(MPQuoteCondition__c mpqc, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus){
        this.pricingWrapper = new PricingAPIWrapper();
        this.mpqc = mpqc;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
    }

    /**
    * @description Método con el cual se inician los procesos.
    * @author Juan Felipe Muriel | 05-08-2024 
    **/
    public void execute() {
        try {
            prepareRequestData();     // Obtener datos necesarios para hacer la petición
            executeCallout();         // Hacer llamada a la API
            validateResponse();       // Validar si la respuesta de la API es correcta
            updateQuoteCondition();   // Actualizar QuoteCondition con el nuevo precio sugerido
            updateQuoteRecord();      // Actualizar Quote
            modifyIntegrationLog();   // Agregar datos al log
        } catch (Exception e) {
            handleException(e);       // Acciones a tomar despues de una exepción de Salesforce (diferente al callout)
            modifyIntegrationLog();   // Agregar datos del error al log
            updateQuoteCondition();   // Actualizar QuoteCondition con error
            updateQuoteRecord();      // Actualizar Quote con error
        } finally{
            updateIntegrationLog();   // Actualizar el log en base de datos
            handleRetries();          // Lógica de reintentos
        }
    }
    
    private void prepareRequestData() {
        this.pricingWrapper.requestData = BusinessRuleDataFactory.getPricingData(this.mpqc);
        System.debug('requestData > ' + this.pricingWrapper.requestData);
    }
    
    private void executeCallout() {
        this.pricingWrapper = PricingAPICalloutService.makeCallout(this.pricingWrapper);
        System.debug('responseData > ' + this.pricingWrapper.responseData);
    }

    private void validateResponse(){
        PricingAPIUtils.validateResponse(this.pricingWrapper.responseData);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = PricingAPIUtils.modifyIntegrationLog(this, false); // No hacer UPDATE aún
    }

    private void updateIntegrationLog(){
        this.integrationStatus = PricingAPIUtils.modifyIntegrationLog(this, true); // Hacer UPDATE
    }

    private void updateQuoteCondition(){
        this.mpqc = PricingAPIUtils.updateQuoteCondition(this, true); // Hacer UPDATE aún
    }

    private void updateQuoteRecord(){
        PricingAPIUtils.updateQuote(this);
    }

    private void handleException(Exception e){
        this.pricingWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.pricingWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
    }  

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.pricingWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
                PricingAPICallManager newCallManager = new PricingAPICallManager(this.mpqc,this.retryEnabled, this.integrationStatus);
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    }

    // Getters para permitir el acceso a atributos privados
    public PricingAPIWrapper getPricingWrapper() {
        return this.pricingWrapper;
    }

    public MPIntegrationStatus__c getIntegrationStatus() {
        return this.integrationStatus;
    }

    public MPQuoteCondition__c getMpqc() {
        return this.mpqc;
    }
}