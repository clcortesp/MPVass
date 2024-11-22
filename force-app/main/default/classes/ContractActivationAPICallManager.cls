/**
 * @description Clase que administra las llamadas una a la API de activación de contratos y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 22-08-2024 - Creación
 */
public with sharing class ContractActivationAPICallManager implements ICallManager {

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractActivation').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private ContractActivationAPIWrapper contractActivationWrapper;
    /** Contrato el cual se va a actualizar en sistemas externos */
    private Contract contract;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
    /** Log de la integración */
    private MPIntegrationStatus__c integrationStatus;

    public ContractActivationAPICallManager(Contract contract, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.contractActivationWrapper = new ContractActivationAPIWrapper();
        this.contract = contract;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
    }

    /**
    * @description Método con el cual se inician los procesos.
    * @author Juan Felipe Muriel | 22-08-2024 
    **/
    public void execute(){
        try {
            prepareRequestData();   // Obtener datos necesarios para hacer la petición
            executeCallout();       // Hacer llamada a la API
            updateContract();       // Actualizar Contrato según resultado
            modifyIntegrationLog(); // Agregar datos al log
        } catch (Exception e) {
            handleException(e);     // Acciones a tomar despues de una exepción de Salesforce (diferente al callout)
        } finally{
            updateIntegrationLog(); // Actualizar el log de integración
            handleRetries();        // Lógica de reintentos
        }
    }

    private void prepareRequestData(){
        this.contractActivationWrapper.params = BusinessRuleDataFactory.getContractActivationAPIParams(this.contract);
    }
    
    private void executeCallout(){
        this.contractActivationWrapper = ContractActivationAPICallOutService.makeCallout(this.contractActivationWrapper);
    }

    private void updateContract(){
        ContractActivationAPIUtils.updateContract(this.contract.id, this.integrationStatus.id);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = ContractActivationAPIUtils.modifyIntegrationLog(this);
    }

    private void updateIntegrationLog(){
        Utilities_cls.updateIntegrationStatus(this.integrationStatus);
    }

    private void handleException(Exception e){
        this.contractActivationWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.contractActivationWrapper.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
        modifyIntegrationLog();
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.contractActivationWrapper.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            ContractActivationAPICallManager newCallManager = new ContractActivationAPICallManager(this.contract,this.retryEnabled, this.integrationStatus);
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    }

    // Getters para permitir el acceso a atributos privados
    public ContractActivationAPIWrapper getContractActivationWrapper() {
        return this.contractActivationWrapper;
    }

    public Contract getContract(){
        return this.contract;
    }

    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }
}