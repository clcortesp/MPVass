/**
 * @description Clase que administra las llamadas una a la API de modificación de contratos y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 28-08-2024 - Creación
 */
public with sharing class ContractModificationAPICallManager implements ICallManager {

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractModification').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractModification').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractModification').MPSecondsBetweenRetries__c;
    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private ContractWrapperSAP contractWrapperSAP;
    /** Contrato el cual se va a actualizar en sistemas externos */
    private Contract contract;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
    /** Log de la integración */
    private MPIntegrationStatus__c integrationStatus;

    public ContractModificationAPICallManager(Contract contract, Boolean retryEnabled, MPIntegrationStatus__c integrationStatus) {
        this.contractWrapperSAP = new ContractWrapperSAP();
        this.contract = contract;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatus = integrationStatus;
    }

    /**
    * @description Método con el cual se inician los procesos.
    * @author Juan Felipe Muriel | 28-08-2024 
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

        /** INICIO REUTILIZACION MINERIA DE DATOS DE API CREACIÓN DE CONTRATO */
        List<Id> lstContract = new List<Id>();
        Map<Id, ContractWrapperSAP.Request> contractRequestMap =  new Map<Id, ContractWrapperSAP.Request>();
        lstContract.add(this.contract.Id);// Agregar contrato a lista para procesar masivamente
        // Obtengo el request
        contractRequestMap = ContractCreationAPIUtils.prepareContractRequestMap(lstContract, this.contractWrapperSAP);
        this.contractWrapperSAP.request = contractRequestMap.get(this.contract.Id);// extraer el request individual
        /** FIN REUTILIZACION MINERIA DE DATOS DE API CREACION DE CONTRATO */
        
        // Obtener parámetros para agregar en la URL
        this.contractWrapperSAP.params = BusinessRuleDataFactory.getContractModificationAPIParams(this.contract);
        // agregar el External Id del contrato al request
        this.contractWrapperSAP.request.id = this.contractWrapperSAP.params.contractId;
    }
    
    private void executeCallout(){
        ContractModificationAPICallOutService.makeCallout(this.contractWrapperSAP);
    }

    private void updateContract(){
        ContractModificationAPIUtils.updateContract(this.contract.id, this.integrationStatus.id);
    }

    private void modifyIntegrationLog(){
        this.integrationStatus = ContractModificationAPIUtils.modifyIntegrationLog(this);
    }

    private void updateIntegrationLog(){
        Utilities_cls.updateIntegrationStatus(this.integrationStatus);
    }

    private void handleException(Exception e){
        this.contractWrapperSAP.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        this.contractWrapperSAP.salesforceErrorMessage = Utilities_cls.getSalesforceStackTrace(e);
        modifyIntegrationLog();
    }

    private void handleRetries(){
        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.contractWrapperSAP.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            ContractModificationAPICallManager newCallManager = new ContractModificationAPICallManager(this.contract,this.retryEnabled, this.integrationStatus);
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar +1 al contador
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    }

    // Getters para permitir el acceso a atributos privados
    public ContractWrapperSAP getContractWrapperSAP() {
        return this.contractWrapperSAP;
    }

    public Contract getContract(){
        return this.contract;
    }

    public MPIntegrationStatus__c getIntegrationStatus(){
        return this.integrationStatus;
    }
}