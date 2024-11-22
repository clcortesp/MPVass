/**
 * @description Clase encargada de hacer la llamada a la API de Actualizacion de fechas de contrato.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractDatesUpdateAPICallOutService {
    /** Códigos HTTP de exito */
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPTimeout__c;
    /** Signo '/' */
    public static final String SLASH = '/';
    /** Path adicioinal */
    public static final String API_PATH_ADICIONAL = MPIntegrationSetting__mdt.getInstance('MPContractDatesUpdate').MPApi_Path_2__c;

    public static ContractDatesUpdateAPIWrapper makeCallout(ContractDatesUpdateAPIWrapper contractDatesWrapper) {
        contractDatesWrapper.requestDateTime = System.now();
        String params = contractDatesWrapper.params.companyCode + SLASH + contractDatesWrapper.params.contractId + SLASH;
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HTTPResponse response;
        HttpRequest request;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_ADICIONAL);
            request.setBody(JSON.serialize(contractDatesWrapper.request));
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);
    
            if (successfulCodes.contains(response.getStatusCode())) {
                System.debug('LLAMADA CORRECTA');
                contractDatesWrapper = handleSuccess(contractDatesWrapper, response);
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        }catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            contractDatesWrapper = handleError(contractDatesWrapper, e, response);
        }
        return contractDatesWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta exitosa de la API.
    * @author Juan Felipe Muriel | 20-08-2024
    * @param contractDatesWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractDatesWrapper Respuesta de la API de precios en el formato del objeto ContractDatesUpdateAPIWrapper.
    **/
    private static ContractDatesUpdateAPIWrapper handleSuccess(ContractDatesUpdateAPIWrapper contractDatesWrapper, HTTPResponse response){
        if(response != null){
            contractDatesWrapper.response.message = response.getBody();
            contractDatesWrapper.httpCode = response.getStatusCode();
        }
        contractDatesWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractDatesWrapper.responseDateTime = System.now();
        return contractDatesWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta fallida de la API.
    * @author Juan Felipe Muriel | 20-08-2024
    * @param contractDatesWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param e Excepción capturada al momento de hacer la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractDatesWrapper Respuesta de la API de precios en el formato del objeto ContractDatesUpdateAPIWrapper.
    **/
    private static ContractDatesUpdateAPIWrapper handleError(ContractDatesUpdateAPIWrapper contractDatesWrapper, Exception e, HTTPResponse response){
        if(response != null){
            contractDatesWrapper.httpCode = response.getStatusCode();
        }
        contractDatesWrapper.responseDateTime = System.now();
        contractDatesWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractDatesWrapper.response.message = e.getMessage();
        return contractDatesWrapper;
    }
}