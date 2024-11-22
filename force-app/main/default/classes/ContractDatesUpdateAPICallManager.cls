/**
 * @description Clase que administra las llamadas una a la API de Actualzacion de fechas de contratos y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractDatesUpdateAPICallManager implements ICallManager {

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private ContractDatesUpdateAPIWrapper contractDatesWrapper;
    /** Contrato el cual se va a actualizar en sistemas externos */
    private Contract contract;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
    /** Log de la integración */
    private MPIntegrationStatus__c integrationStatus;

    public ContractDatesUpdateAPICallManager(Contract contract, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus){
        this.contractDatesWrapper = new ContractDatesUpdateAPIWrapper();
        this.contract = contract;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
    }

    /**
    * @description Método con el cual se inician los procesos.
    * @author Juan Felipe Muriel | 20-08-2024 
    **/
    public void execute(){
        try {
            prepareRequestData();   // Obtener datos necesarios para hacer la petición
            executeCallout();       // Hacer llamada a la API
            updateContract();       // Actualizar Contrato según resultado
            modifyIntegrationLog(); // Agregar datos al log
        } catch (Exception e) {
            handleException(e);     // Acciones a tomar despues de una exepción de Salesforce (diferente al callout)
            modifyIntegrationLog(); // Agregar datos al log
        } finally{
            updateIntegrationLog(); // Actualizar el log de integración
            changeContractStatus(); // Cambiar el estado del contrato si la llamada a la API es correcta
            handleRetries();        // Lógica de reintentos
        }
    }

    private void changeContractStatus(){
        ContractDatesUpdateAPIUtils.changeContractStatus(this.contract, this.contractDatesWrapper.status);
    }

    private void prepareRequestData(){
        this.contractDatesWrapper.request = BusinessRuleDataFactory.getContractDatesUpdateAPIRequest(this.contract);
        this.contractDatesWrapper.params = BusinessRuleDataFactory.getContractDatesUpdateAPIParams(this.contract);
    }
    
    private void executeCallout(){
        this.contractDatesWrapper = ContractDatesUpdateAPICallOutService.makeCallout(this.contractDatesWrapper);
    }

    private void updateContract(){
        ContractDatesUpdateAPIUtils.updateContract(this.contract.id, this.integrationStatus.id);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = ContractDatesUpdateAPIUtils.modifyIntegrationLog(this);
    }

    private void updateIntegrationLog(){
        Utilities_cls.updateIntegrationStatus(this.integrationStatus);
    }

    private void handleException(Exception e){
        this.contractDatesWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.contractDatesWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.contractDatesWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            ContractDatesUpdateAPICallManager newCallManager = new ContractDatesUpdateAPICallManager(this.contract,this.retryEnabled, this.integrationStatus);
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    }

    // Getters para permitir el acceso a atributos privados
    public ContractDatesUpdateAPIWrapper getContractDatesWrapper() {
        return this.contractDatesWrapper;
    }

    public Contract getContract(){
        return this.contract;
    }

    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }
}