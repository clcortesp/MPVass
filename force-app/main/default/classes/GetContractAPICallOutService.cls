public with sharing class GetContractAPICallOutService {
   /** Códigos HTTP de exito */
   public static final Integer SUCCESSFUL_HTTP_CODES = 200;
   /** Método HTTP */
   public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPGETContract').MPMethod__c;
   /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
   public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPGETContract').MPNamedCredential__c;
   /** Ruta especifica para acceder a la API */
   public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPGETContract').MPApi_Path__c;
   /** Tiempo máximo de espera para una respuesta de la API */
   public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPGETContract').MPTimeout__c;
   /** Signo '/' */
   public static final String SLASH = '/';

   public static GetContractAPIWrapper makeCallout(GetContractAPIWrapper getContractAPIWrapper) {

        getContractAPIWrapper.requestDateTime = System.now();
        String params = getContractAPIWrapper.params.companyCode + SLASH + getContractAPIWrapper.params.contractId + SLASH;
        HttpRequest request;
        HTTPResponse response;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params );
            System.debug('request.setEndpoint: ' + NAMED_CREDENTIAL + API_PATH + params);
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);

            if (response.getStatusCode() == SUCCESSFUL_HTTP_CODES) {
                System.debug('LLAMADA CORRECTA');
                getContractAPIWrapper = handleSuccess(getContractAPIWrapper, response);
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        }catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            getContractAPIWrapper = handleError(getContractAPIWrapper, e, response);
        }

        return getContractAPIWrapper;

    }


    private static GetContractAPIWrapper handleSuccess(GetContractAPIWrapper getContractAPIWrapper, HTTPResponse response){
        if(response != null){
            getContractAPIWrapper.response.message = response.getBody();
            getContractAPIWrapper.httpCode = response.getStatusCode();
        }
        getContractAPIWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        getContractAPIWrapper.responseDateTime = System.now();
        return getContractAPIWrapper;
    }


    private static GetContractAPIWrapper handleError(GetContractAPIWrapper getContractAPIWrapper, Exception e, HTTPResponse response){
        if(response != null){
            getContractAPIWrapper.httpCode = response.getStatusCode();
        }
        getContractAPIWrapper.responseDateTime = System.now();
        getContractAPIWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        getContractAPIWrapper.response.message = e.getMessage();
        return getContractAPIWrapper;
    }




}