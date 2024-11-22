/**
 * @description Clase utils para crear metodos emergentes de la integracion 4.0 Creacion de contratos
 * @group Proyecto MP
 * @author Miller Mora
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractCreationAPIUtils {

    //Variables para manejo de reintentos
    private static final String EMPTY = '';
    private static final String SCRIPT = '-';
    private static final String QUESTION_MARK = ' ? ';
    private static final String SPACE = ' ';
    /** Número máximo de reintentos a la API */
    private static final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPMaximumRetries__c;
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractCreation').DeveloperName;
    /** Segundos entre cada intento */
    private static final Integer SECONDS_BETWEEN_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPSecondsBetweenRetries__c;


    /**
    * @description Prepara el mapa que relaciona los IDs de contratos con sus requests.
    * @param lstContract Lista de IDs de contratos.
    * @param contractWrapperSAP Wrapper que contiene la lista de requests.
    * @return Mapa que relaciona IDs de contratos con sus requests.
    */
    public static Map<Id, ContractWrapperSAP.Request> prepareContractRequestMap(List<Id> lstContract, ContractWrapperSAP contractWrapperSAP) {
        // Obtener datos necesarios para hacer la petición 
        contractWrapperSAP.lstRequest = BusinessRuleDataFactory.getContractDetails(lstContract);

        Map<Id, ContractWrapperSAP.Request> contractRequestMap = new Map<Id, ContractWrapperSAP.Request>();
        for (Integer i = 0; i < lstContract.size(); i++) {
            contractRequestMap.put(lstContract[i], contractWrapperSAP.lstRequest[i]);
        }
        return contractRequestMap;
    }

    /**
    * @description Crea un mapa que relaciona el número de contrato con su ID.
    * @param contractIds Lista de IDs de contratos.
    * @return Mapa que relaciona el número de contrato con su ID.
    */
    public static Map<String, Id> createContractNumberToIdMap(List<Id> contractIds) {
        Map<String, Id> contractNumberToIdMap = new Map<String, Id>();

        // Obtener los contratos y mapear ContractNumber a Id
        List<Contract> contracts = [SELECT Id, ContractNumber, MPExternalCode__c FROM Contract WHERE Id IN :contractIds];
        for (Contract contract : contracts) {
            contractNumberToIdMap.put(contract.ContractNumber, contract.Id);
        }
        return contractNumberToIdMap;
    }

    /**
    * @description Actualiza los IDs externos de los contratos basándose en la respuesta de la API.
    * @param contractNumberToIdMap Mapa que relaciona el número de contrato con su ID.
    * @param responses Lista de respuestas de la API.
    */
    public static void updateContractExternalIds(Map<String, Id> contractNumberToIdMap, List<ContractWrapperSAP.Response> responses) {
        List<Contract> contractsToUpdate = new List<Contract>();

        for (ContractWrapperSAP.Response response : responses) {
            if (contractNumberToIdMap.containsKey(response.offerId)) {
                Contract contractToUpdate = new Contract();
                contractToUpdate.Id = contractNumberToIdMap.get(response.offerId);
                contractToUpdate.MPExternalCode__c = response.contractId;
                contractsToUpdate.add(contractToUpdate);
            }
        }

        if (!contractsToUpdate.isEmpty()) {
            update contractsToUpdate;
        }
    }

    /**
    * @description Actualiza los registros de integración con la respuesta de la API.
    * @param integrationLogs Los registros de integración que se actualizarán.
    * @param status El estado de la integración (Exito/Error).
    * @param responseBody El cuerpo de la respuesta de la API.
    * @param errorMessage Mensaje de error en caso de que exista.
    */
    public static void updateIntegrationLogs(Id integrationStatusId, String status, String responseBody, String errorMessage,Map<Id, ContractWrapperSAP.Request> contractRequestMap, Decimal httpCode) {

        MPIntegrationStatus__c integrationLog = [SELECT Id, MPParentId__c FROM MPIntegrationStatus__c WHERE Id = :integrationStatusId LIMIT 1];
            integrationLog.MPStatus__c = status;
            integrationLog.MPResponse__c = responseBody;
            integrationLog.MPResponseDateTime__c = System.now();
            integrationLog.MPSalesforceException__c = errorMessage;
            String individualRequestPayload = JSON.serialize(contractRequestMap.get(integrationLog.MPParentId__c));
            integrationLog.MPRequest__c = individualRequestPayload;
            integrationLog.MPRequestDateTime__c = System.now();
            integrationLog.MPHttpCode__c = httpCode;

            System.debug('integrationLog > ' + integrationLog); 


        update integrationLog;
    }

}