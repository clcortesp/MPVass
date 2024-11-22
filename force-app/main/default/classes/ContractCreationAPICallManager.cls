/**
 * @description Clase que administra las llamadas una a la API de la creacion de contratos en SAP y 
 * controla acciones relacionadas como creación de Logs, reintentos, actualización de registros, entre otros.
 * @group Proyecto MP
 * @author Miller Mora
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractCreationAPICallManager implements ICallManager {

    /** Número máximo de reintentos a la API */
    public static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPMaximumRetries__c;
    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractCreation').DeveloperName;
    /** Segundos entre cada intento */
    public static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPSecondsBetweenRetries__c;

    /** Objeto wrapper que contiene el request, response y demás detalles de la llamada */
    private ContractWrapperSAP contractWrapperSAP;
    /** Contrato el cual se va a actualizar en sistemas externos */
    private List<Id> lstContract;
    /** Boolean que indica si se deben hacer reintentos despues de un error */
    private Boolean retryEnabled;
    /** Conteo de los reintentos */
    private Integer retryCount;
    /** Log de la integración */
    //private MPIntegrationStatus__c integrationStatus;
    private Id integrationStatusId;
    
    public ContractCreationAPICallManager(List<Id> lstContract, Boolean retryEnabled, Id integrationStatusId){
        System.debug('Constructor started');
        this.contractWrapperSAP = new ContractWrapperSAP();
        this.lstContract = lstContract;
        this.retryEnabled = retryEnabled;
        this.retryCount = 0;
        this.integrationStatusId =  integrationStatusId;
        System.debug('Constructor completed');
    }

    /**
    * @description Método con el cual se inician los procesos.
    * @author Miller Mora | 20-08-2024 
    **/
    public void execute(){
        System.debug('LOG ENTRA 2  ::::::::::: ' );

        Map<Id, ContractWrapperSAP.Request> contractRequestMap = new Map<Id, ContractWrapperSAP.Request>();
        Map<String, Id> contractNumberToIdMap = ContractCreationAPIUtils.createContractNumberToIdMap(this.lstContract);


        try {

            contractRequestMap = ContractCreationAPIUtils.prepareContractRequestMap(this.lstContract, this.contractWrapperSAP); // Preparo Data Wrapper y llenamos mapa contractRequestMap 
            executeCallout(); // Hacer llamada a la API
            if (this.contractWrapperSAP.status == 'Success') {
                System.debug('eNTRO AQUI: ');
                ContractCreationAPIUtils.updateContractExternalIds(contractNumberToIdMap, this.contractWrapperSAP.lstResponse);
            }
            ContractCreationAPIUtils.updateIntegrationLogs(this.integrationStatusId, this.contractWrapperSAP.status, JSON.serialize(contractWrapperSAP.lstResponse), contractWrapperSAP.errorMessage,contractRequestMap, contractWrapperSAP.httpCode);
            //ContractCreationAPIUtils.updateIntegrationLogs(integrationLogs, this.contractWrapperSAP.status, JSON.serialize(contractWrapperSAP.lstResponse), contractWrapperSAP.errorMessage);
            
            handleRetries(); // Lógica de reintentos

        } catch (Exception e) {
            System.debug('Error durante el proceso: ' + e.getMessage()); 
            ContractCreationAPIUtils.updateIntegrationLogs(this.integrationStatusId, this.contractWrapperSAP.status, JSON.serialize(contractWrapperSAP.lstResponse), contractWrapperSAP.errorMessage,contractRequestMap, contractWrapperSAP.httpCode);
            //integrationLogs = ContractCreationAPIUtils.createIntegrationLogs(INTEGRATION_NAME, contractRequestMap, JSON.serialize(contractWrapperSAP.lstRequest));
            //ContractCreationAPIUtils.updateIntegrationLogs(integrationLogs, this.contractWrapperSAP.status,JSON.serialize(contractWrapperSAP.lstResponse), e.getMessage());
        }
    }


    private void executeCallout(){
        this.contractWrapperSAP = ContractCreationAPICallOutService.makeCallout(this.contractWrapperSAP);
        System.debug('responseData > ' + this.contractWrapperSAP); 
    }

    private void handleRetries(){

        if( this.retryEnabled && MAX_RETRIES != null && this.retryCount < MAX_RETRIES 
            && this.contractWrapperSAP.status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){

            System.debug('Se encola el reintento # ' + (this.retryCount + 1 ));
            ContractCreationAPICallManager newCallManager = new ContractCreationAPICallManager(this.lstContract,true, this.integrationStatusId);
            newCallManager.retryCount = (this.retryCount + NumbersEnum.UNO.ordinal()); // Agregar el contador anterior
            Utilities_cls.handleCalloutRetries(newCallManager, SECONDS_BETWEEN_RETRIES, INTEGRATION_NAME);
        }
    }

  
}