/**
 * @description Clase encargada de hacer la llamada a la API de Terminación de contrato.
 * @group Proyecto MP
 * @author Miller
 * @since 17-10-2024 - Creación
 */
public with sharing class contractRescissionAPICallOutService {
    /** Códigos HTTP de exito */
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPTimeout__c;
    /** Signo '/' */
    public static final String SLASH = '/';
    /** Path adicioinal */
    public static final String API_PATH_ADICIONAL = MPIntegrationSetting__mdt.getInstance('MPContractRescission').MPApi_Path_2__c;

    public static ContractRescissionAPIWrapper makeCallout(ContractRescissionAPIWrapper contractRescissionAPIWrapper) {

        contractRescissionAPIWrapper.requestDateTime = System.now();
        String params = contractRescissionAPIWrapper.params.companyCode + SLASH + contractRescissionAPIWrapper.params.contractId + SLASH;
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HttpRequest request;
        HTTPResponse response;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_ADICIONAL );
            System.debug('request.setEndpoint: ' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_ADICIONAL);
            String requestBody = JSON.serialize(contractRescissionAPIWrapper.request);
            System.debug('Cuerpo de la solicitud: ' + requestBody);
            request.setBody(requestBody);
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);

            System.debug('Código de estado de la respuesta: ' + response.getStatusCode());
            System.debug('Cuerpo de la respuesta: ' + response.getBody());

            if (successfulCodes.contains(response.getStatusCode())) {
                System.debug('LLAMADA CORRECTA');
                contractRescissionAPIWrapper = handleSuccess(contractRescissionAPIWrapper, response);
            }else{
                System.debug('LLAMADA INCORRECTA - Código de estado: ' + response.getStatusCode());
                throw new CalloutException(response.getBody());
            }
        }catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            if (response != null) {
                System.debug('Código de estado HTTP: ' + response.getStatusCode());
                System.debug('Cuerpo de la respuesta: ' + response.getBody());
            } else {
                System.debug('No se recibió respuesta del servidor');
            }
            contractRescissionAPIWrapper = handleError(contractRescissionAPIWrapper, e, response);
        }

        return contractRescissionAPIWrapper;

    }

    private static ContractRescissionAPIWrapper handleSuccess(ContractRescissionAPIWrapper contractRescissionAPIWrapper, HTTPResponse response){
        if(response != null){
            contractRescissionAPIWrapper.response.message = response.getBody();
            contractRescissionAPIWrapper.httpCode = response.getStatusCode();
        }
        contractRescissionAPIWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractRescissionAPIWrapper.responseDateTime = System.now();
        return contractRescissionAPIWrapper;
    }


    private static ContractRescissionAPIWrapper handleError(ContractRescissionAPIWrapper contractRescissionAPIWrapper, Exception e, HTTPResponse response){
        if(response != null){
            contractRescissionAPIWrapper.httpCode = response.getStatusCode();
        }
        contractRescissionAPIWrapper.responseDateTime = System.now();
        contractRescissionAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractRescissionAPIWrapper.response.message = e.getMessage();
        return contractRescissionAPIWrapper;
    }
}