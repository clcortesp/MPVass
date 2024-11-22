/**
 * @description Clase encargada de hacer la llamada a la API de Modificación de contrato.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 28-08-2024 - Creación
 */
public with sharing class ContractModificationAPICallOutService {

    /** Códigos HTTP de exito */
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPContractModification').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPContractModification').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPContractModification').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPContractModification').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractModification').MPTimeout__c;
    /** Signo '/' */
    public static final String SLASH = '/';

    public static ContractWrapperSAP makeCallout(ContractWrapperSAP contractWrapperSAP) {
        contractWrapperSAP.requestDateTime = System.now();
        String params = contractWrapperSAP.params.companyCode + SLASH + contractWrapperSAP.params.contractId;
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);

        HTTPResponse response;
        HttpRequest request;

        try {
            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH + params);
            request.setMethod(HTTP_METHOD);
            /** This one example of the the expected request we must send to the endpoint 
             *  String fakeRequest = '{"adjustmentRule":"PE24MES-10","cebe":"1202101","companyCode":"1200","condition":[{"calcRule":"MPAD","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","otype":"AD10","unitPrice":1,"validFrom":"2023-01-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AM","otype":"AM10","unitPrice":1.3774122035280507,"validFrom":"2023-06-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP05","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AP","otype":"AP10","unitPrice":8.1,"validFrom":"2010-01-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP03","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","otype":"FD10","unitPrice":10,"validFrom":"2023-01-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP03","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"FPAM","otype":"FP20","unitPrice":10,"validFrom":"2023-06-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP03","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"FPAP","otype":"FP30","unitPrice":10,"validFrom":"2023-03-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"G0","otype":"G010","unitPrice":0.37774,"validFrom":"2023-06-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"G3","otype":"G300","unitPrice":0.09326,"validFrom":"2023-06-01T00:00:00","validTo":"2031-01-27T00:00:00"},{"calcRule":"MP03","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"G6","otype":"G600","unitPrice":5,"validFrom":"2023-06-01T00:00:00","validTo":"2031-01-27T00:00:00"}],"currencyIsoCode":"UF","endDate":"2031-10-31T00:00:00","id":"0000000007395","indexSeries":"REAJ%","indexSeriesBaseYear":"2003","isMainContract":false,"isSalesRelated":true,"name":"Gema_PLA","note":"false","offerId":"8007g000001DobUAAS","otype":"M101","partner":[{"id":"76126306","otype":"TR0600","validFrom":"2003-01-28T00:00:00","validTo":""}],"paymentCondition":null,"percSalesAsRent":8.1,"rentalObject":[{"id":"1200/1202/00002148","isInfo":false,"otype":"IM"},{"id":"1200/1202/00002152","isInfo":false,"otype":"IM"}],"salesBasedRentAgreement":[],"salesCurrencyIsoCode":"UF","salesStartDate":"2003-01-28T00:00:00","sector":"RU036","startDate":"2003-01-28T00:00:00","termAdjust":[{"adjustmentRule":"PE24MES-10","conditionType":"AM10","elementaryAdjRule":"PE24MES-10","firstAdjustmentDate":"2031-01-27T00:00:00","indexPointsAdoptionDate":"2023-06-01T00:00:00","indexSeries":"REAJ%","termNo":"10","termText":"PE24MES-10"}]}';
             *  request.setBody(fakeRequest);
            */
            request.setBody(JSON.serialize(contractWrapperSAP.Request));
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);

            if (successfulCodes.contains(response.getStatusCode())) {
                System.debug('LLAMADA CORRECTA');
                contractWrapperSAP = handleSuccess(contractWrapperSAP, response);
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        }catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            contractWrapperSAP = handleError(contractWrapperSAP, e, response);
        }
        return contractWrapperSAP;
    }

    /**
    * @description Método encargado de devolver la respuesta exitosa de la API.
    * @author Juan Felipe Muriel | 22-08-2024
    * @param contractWrapperSAP Clase Wrapper que contiene datos de la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractWrapperSAP Respuesta de la API en el formato del objeto contractWrapperSAP.
    **/
    private static ContractWrapperSAP handleSuccess(ContractWrapperSAP contractWrapperSAP, HTTPResponse response){
        if(response != null){
            ContractWrapperSAP.response = (ContractWrapperSAP.Response) JSON.deserialize(response.getBody(), ContractWrapperSAP.Response.class);
            contractWrapperSAP.httpCode = response.getStatusCode();
        }
        contractWrapperSAP.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractWrapperSAP.responseDateTime = System.now();
        return contractWrapperSAP;
    }

    /**
    * @description Método encargado de devolver la respuesta fallida de la API.
    * @author Juan Felipe Muriel | 05-08-2024
    * @param contractWrapperSAP Clase Wrapper que contiene datos de la llamada a la API.
    * @param e Excepción capturada al momento de hacer la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractWrapperSAP Respuesta de la API de precios en el formato del objeto contractWrapperSAP.
    **/
    private static ContractWrapperSAP handleError(ContractWrapperSAP contractWrapperSAP, Exception e, HTTPResponse response){
        if(response != null){
            contractWrapperSAP.httpCode = response.getStatusCode();
        }
        contractWrapperSAP.responseDateTime = System.now();
        contractWrapperSAP.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractWrapperSAP.errorMessage = e.getMessage();

        return contractWrapperSAP;
    }
}