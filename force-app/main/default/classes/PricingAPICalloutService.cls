/**
 * @description Clase encargada de hacer la llamada a la API de precios.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
public with sharing class PricingAPICalloutService {
    /** Códigos HTTP de exito */
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPPricing').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPPricing').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPPricing').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPPricing').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPPricing').MPTimeout__c;
    
    /**
    * @description Método que hace la llamada a la API de precios.
    * @author Juan Felipe Muriel | 05-08-2024
    * @param pricingWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @return pricingWrapper Respuesta de la API de precios en el formato del objeto PricingAPIWrapper.
    **/
    public static PricingAPIWrapper makeCallout(PricingAPIWrapper pricingWrapper) {
        pricingWrapper.requestDateTime = System.now();
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HTTPResponse response;
        HttpRequest request;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH);
            request.setBody(JSON.serialize(pricingWrapper.requestData));
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);
            
            /*
             * Example of successful response
             * '{"message": [{"code": "X0002","description": "RentalObject no fue encontrado, calculo no considera pasillo"}],"pricing": 0.24145688653950015}'
            */
    
            if (successfulCodes.contains(response.getStatusCode())) {
                pricingWrapper = handleSuccess(pricingWrapper, response);
                System.debug('LLAMADA CORRECTA');
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        } catch (Exception e) {
            System.debug('Excepción general en CallOut: ' + e.getMessage());
            pricingWrapper = handleError(pricingWrapper, e, response);
        }
        return pricingWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta exitosa de la API de precios.
    * @author Juan Felipe Muriel | 05-08-2024
    * @param pricingWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param response Respuesta de la API.
    * @return pricingWrapper Respuesta de la API de precios en el formato del objeto PricingAPIWrapper.
    **/
    private static PricingAPIWrapper handleSuccess(PricingAPIWrapper pricingWrapper, HTTPResponse response){
        if(response != null){
            pricingWrapper.responseData = (PricingAPIWrapper.Response) JSON.deserialize(response.getBody(), PricingAPIWrapper.Response.class);
            pricingWrapper.httpCode = response.getStatusCode();
        }
        pricingWrapper.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        pricingWrapper.responseDateTime = System.now();
        return pricingWrapper;
    }

    /**
    * @description Método encargado de devolver la respuesta fallida de la API de precios.
    * @author Juan Felipe Muriel | 05-08-2024
    * @param pricingWrapper Clase Wrapper que contiene datos de la llamada a la API.
    * @param e Excepción capturada al momento de hacer la llamada a la API.
    * @return pricingWrapper Respuesta de la API de precios en el formato del objeto PricingAPIWrapper.
    **/
    private static PricingAPIWrapper handleError(PricingAPIWrapper pricingWrapper, Exception e, HTTPResponse response){
        if(response != null){
            pricingWrapper.httpCode = response.getStatusCode();
        }
        pricingWrapper.responseDateTime = System.now();
        pricingWrapper.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        // Verificar el tipo de excepción y guardar el mensaje
        if (e instanceof CalloutException) {
            pricingWrapper.callOutErrorMessage = e.getMessage();
        } else {
            pricingWrapper.salesforceErrorMessage = e.getMessage();
        }
        return pricingWrapper;
    }
}