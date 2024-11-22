/**
 * @description Clase encargada de hacer la llamada a la API de Terminación de contrato.
 * @group Proyecto MP
 * @author Miller
 * @since 22-10-2024 - Creación
 */
public with sharing class RejectContrRescissionAPCallOutService {

     /** Códigos HTTP de exito */
     public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPSuccessfulHttpCodes__c;
     /** Método HTTP */
     public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPMethod__c;
     /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
     public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPNamedCredential__c;
     /** Ruta especifica para acceder a la API */
     public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPApi_Path__c;
     /** Tiempo máximo de espera para una respuesta de la API */
     public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPTimeout__c;
     /** Signo '/' */
     public static final String SLASH = '/';
     /** Path adicioinal */
     public static final String API_PATH_ADICIONAL = MPIntegrationSetting__mdt.getInstance('MPRejectContractRescission').MPApi_Path_2__c;

     public static RejectContrRescissionAPIWrapper makeCallout(RejectContrRescissionAPIWrapper rejectContrRescissionAPIWrapper) {

        rejectContrRescissionAPIWrapper.requestDateTime = System.now();
        String params = rejectContrRescissionAPIWrapper.params.companyCode + SLASH + rejectContrRescissionAPIWrapper.params.contractId + SLASH;
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HttpRequest request;
        HTTPResponse response;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_ADICIONAL );
            System.debug('request.setEndpoint: ' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_ADICIONAL);
            String requestBody = JSON.serialize(rejectContrRescissionAPIWrapper.request);
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
                rejectContrRescissionAPIWrapper = handleSuccess(rejectContrRescissionAPIWrapper, response);
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
            rejectContrRescissionAPIWrapper = handleError(rejectContrRescissionAPIWrapper, e, response);
        }

        return rejectContrRescissionAPIWrapper;

    }

    
    private static RejectContrRescissionAPIWrapper handleSuccess(RejectContrRescissionAPIWrapper rejectContrRescissionAPIWrapper, HTTPResponse response){
        if(response != null){
            rejectContrRescissionAPIWrapper.response.message = response.getBody();
            rejectContrRescissionAPIWrapper.httpCode = response.getStatusCode();
        }
        rejectContrRescissionAPIWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        rejectContrRescissionAPIWrapper.responseDateTime = System.now();
        return rejectContrRescissionAPIWrapper;
    }


    private static RejectContrRescissionAPIWrapper handleError(RejectContrRescissionAPIWrapper rejectContrRescissionAPIWrapper, Exception e, HTTPResponse response){
        if(response != null){
            rejectContrRescissionAPIWrapper.httpCode = response.getStatusCode();
        }
        rejectContrRescissionAPIWrapper.responseDateTime = System.now();
        rejectContrRescissionAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        rejectContrRescissionAPIWrapper.response.message = e.getMessage();
        return rejectContrRescissionAPIWrapper;
    }
}