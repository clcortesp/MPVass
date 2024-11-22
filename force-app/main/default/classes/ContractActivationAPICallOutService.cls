/**
 * @description Clase encargada de hacer la llamada a la API de Activación de contrato.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 22-08-2024 - Creación
 */
public with sharing class ContractActivationAPICallOutService {
    /** Códigos HTTP de exito */
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPTimeout__c;
    /** Signo '/' */
    public static final String SLASH = '/';
    /** Path adicioinal */
    public static final String API_PATH_2 = MPIntegrationSetting__mdt.getInstance('MPContractActivation').MPApi_Path_2__c;

    public static ContractActivationAPIWrapper makeCallout(ContractActivationAPIWrapper contractActivationWrapper) {
        contractActivationWrapper.requestDateTime = System.now();
        String params = contractActivationWrapper.params.companyCode + SLASH + contractActivationWrapper.params.contractId;
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HTTPResponse response;
        HttpRequest request;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params + API_PATH_2);
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);

            if (successfulCodes.contains(response.getStatusCode())) {
                System.debug('LLAMADA CORRECTA');
                contractActivationWrapper = handleSuccess(contractActivationWrapper, response);
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        }catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            contractActivationWrapper = handleError(contractActivationWrapper, e, response);
        }
        return contractActivationWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta exitosa de la API.
    * @author Juan Felipe Muriel | 22-08-2024
    * @param contractActivationWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractActivationWrapper Respuesta de la API en el formato del objeto ContractActivationAPIWrapper.
    **/
    private static ContractActivationAPIWrapper handleSuccess(ContractActivationAPIWrapper contractActivationWrapper, HTTPResponse response){
        if(response != null){
            contractActivationWrapper.response.message = response.getBody();
            contractActivationWrapper.httpCode = response.getStatusCode();
        }
        contractActivationWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractActivationWrapper.responseDateTime = System.now();
        return contractActivationWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta fallida de la API.
    * @author Juan Felipe Muriel | 05-08-2024
    * @param contractActivationWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param e Excepción capturada al momento de hacer la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractActivationWrapper Respuesta de la API de precios en el formato del objeto ContractActivationAPIWrapper.
    **/
    private static ContractActivationAPIWrapper handleError(ContractActivationAPIWrapper contractActivationWrapper, Exception e, HTTPResponse response){
        if(response != null){
            contractActivationWrapper.httpCode = response.getStatusCode();
        }
        contractActivationWrapper.responseDateTime = System.now();
        contractActivationWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractActivationWrapper.response.message = e.getMessage();

        return ContractActivationWrapper;
    }
}