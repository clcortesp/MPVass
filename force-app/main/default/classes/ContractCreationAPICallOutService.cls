/**
 * @description Clase call out de la integracion 4.0 Creacion de contratos
 * @group Proyecto MP
 * @author Miller Mora
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractCreationAPICallOutService {
    
    /** Código HTTP 200 */
    //public static final Integer SUCCESS_CODE = 201;
    public static final String SUCCESSFUL_HTTP_CODES = MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPSuccessfulHttpCodes__c;
    /** Método HTTP */
    public static final String HTTP_METHOD = MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPMethod__c;
    /** API name del Named Credential creado en Salesforce, el cual tiene parametrizado las credenciales de autenticación, encabezados y la URL Raiz de la API a consumir */
    public static final String  NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPNamedCredential__c;
    /** Ruta especifica para acceder a la API */
    public static final String  API_PATH = MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPApi_Path__c;
    /** Tiempo máximo de espera para una respuesta de la API */
    public static final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance('MPContractCreation').MPTimeout__c;
    

    public static ContractWrapperSAP makeCallout(ContractWrapperSAP contractWrapperSAP) {
        List<Integer> successfulCodes = Utilities_cls.getSuccessfulHttpCodes(SUCCESSFUL_HTTP_CODES);
        String FakeRes = '[{"offerId": "00000195","companyCode": "1200","contractId": "35083"},{"offerId": "00000194","companyCode": "1200","contractId": "35083"}]';
        String Req = '[{"Name":"ALDO_XI_PTR","StartDate":"2022-03-01T00:00:00","CurrencyIsoCode":"UF","OfferId":"SF0002","EndDate":"2027-02-28T00:00:00","AdjustmentRule":"PE24MES-10","CompanyCode":"1200","Type":"M101","SalesCurrencyIsoCode":"UF","SalesStartDate":"2022-03-01T00:00:00","IndexSeriesBaseYear":"2023","IndexSeries":"REAJ%","PercSalesAsRent":"1","PaymentCondition":"MP12","Cebe":"1201101","Sector":"SR421","IsSalesRelated":"true","IsMainContract":"true","Note":"Nota cualquier descripcion","Condition":[{"CalcRule":"MPAD","Type":"AD10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AMD","UnitPrice":"1","ValidFrom":"2022-03-01T00:00:00","ValidTo":""},{"CalcRule":"MP02","Type":"AM10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AM","UnitPrice":"5","ValidFrom":"2022-03-01T00:00:00","ValidTo":""},{"CalcRule":"MP05","Type":"AP10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AP","UnitPrice":"1","ValidFrom":"2022-03-01T00:00:00","ValidTo":""}],"RentalObject":[{"Id":"1200/1201/100045","Type":"IM"}],"Partner":[{"Id":"23095730","Type":"TR0600","ValidFrom":"2022-03-01T00:00:00","ValidTo":""}],"SalesBasedRentAgreement":[{"From":"0","To":"100000","Percent":"8"},{"From":"100001","To":"0","Percent":"6"}],"SubClause":[{"Type":"CL01","SubType":"2","Enabled":"true","GeneralClauseNotificationDays":"36","GeneralClauseNotificationType":"M","GeneralClauseNotificationDate":"2022-03-01T00:00:00","ComercialNotificationDays":"6","ComercialNotificationType":"M","ComercialClauseNotificationDate":"2022-03-01T00:00:00","RegisteredMailNotificationDays":"3","RegisteredMailNotificationType":"M","RegisteredMailNotificationDate":"2022-03-01T00:00:00","PreviewDateNotificationType":"M","PreviewDateNotificationDays":"2","PreviewDateNotificationDate":"2022-03-01T00:00:00","RealStartDate":"2022-03-01T00:00:00","Description":"Clausula de Salida"}]},{"Name":"ALDO_XI_PTR","StartDate":"2022-03-01T00:00:00","CurrencyIsoCode":"UF","OfferId":"SF0010","EndDate":"2027-02-28T00:00:00","AdjustmentRule":"PE24MES-10","CompanyCode":"1200","Type":"M101","SalesCurrencyIsoCode":"UF","SalesStartDate":"2022-03-01T00:00:00","IndexSeriesBaseYear":"2023","IndexSeries":"REAJ%","PercSalesAsRent":"1","PaymentCondition":"MP12","Cebe":"1201101","Sector":"SR421","IsSalesRelated":"true","IsMainContract":"false","Note":"Nota cualquier descripcion","Condition":[{"CalcRule":"MPAD","Type":"AD10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AMD","UnitPrice":"1","ValidFrom":"2022-03-01T00:00:00","ValidTo":""},{"CalcRule":"MP02","Type":"AM10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AM","UnitPrice":"5","ValidFrom":"2022-03-01T00:00:00","ValidTo":""},{"CalcRule":"MP05","Type":"AP10","CurrencyIsoCode":"UF","DistributionRule":"MP01","ExternalPurpose":"AP","UnitPrice":"1","ValidFrom":"2022-03-01T00:00:00","ValidTo":""}],"RentalObject":[{"Id":"1200/1201/443486","Type":"IM"}],"Partner":[{"Id":"23095730","Type":"TR0600","ValidFrom":"2022-03-01T00:00:00","ValidTo":""}],"SalesBasedRentAgreement":[{"From":"0","To":"100000","Percent":"8"},{"From":"100001","To":"0","Percent":"6"}],"SubClause":[{"Type":"CL01","SubType":"2","Enabled":"true","GeneralClauseNotificationDays":"36","GeneralClauseNotificationType":"M","GeneralClauseNotificationDate":"2022-03-01T00:00:00","ComercialNotificationDays":"6","ComercialNotificationType":"M","ComercialClauseNotificationDate":"2022-03-01T00:00:00","RegisteredMailNotificationDays":"3","RegisteredMailNotificationType":"M","RegisteredMailNotificationDate":"2022-03-01T00:00:00","PreviewDateNotificationType":"M","PreviewDateNotificationDays":"2","PreviewDateNotificationDate":"2022-03-01T00:00:00","RealStartDate":"2022-03-01T00:00:00","Description":"Clausula de Salida"}]}]';
        contractWrapperSAP.requestDateTime = System.now();
        String jsonPayload;
        HTTPResponse response;
        HttpRequest request;

        try {

            jsonPayload = JSON.serialize(contractWrapperSAP.lstRequest);

            request = new HttpRequest();
            request.setEndpoint('callout:' + NAMED_CREDENTIAL + API_PATH); 
            //req = jsonPayload;
            request.setBody(jsonPayload);
            //request.setBody(Req);
            System.debug('JSONNNNN:::::::' + JSON.serialize(contractWrapperSAP.lstRequest));
            request.setMethod(HTTP_METHOD);
            request.setTimeout(TIME_OUT);

            Http http = new Http();
            response = http.send(request);
    
            if (successfulCodes.contains(response.getStatusCode())) {
                System.debug('LLAMADA CORRECTA');
                contractWrapperSAP = handleSuccess(contractWrapperSAP, response);
                //contractWrapperSAP = handleSuccess(contractWrapperSAP, FakeRes);
            }else{
                System.debug('LLAMADA INCORRECTA');
                throw new CalloutException(response.getBody());
            }
        } catch (Exception e) {
            System.debug('Excepción general: ' + e.getMessage());
            //contractWrapperSAP = handleSuccess(contractWrapperSAP, FakeRes);
            contractWrapperSAP = handleError(contractWrapperSAP, e, response );
        }

        return contractWrapperSAP;
    }

    /**
    * @description Método encargado de devolver la respuesta exitosa de la API.
    * @author Miller Mora | 05-08-2024
    * @param contractWrapperSAP Clase Wrapper que contiene datos de la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractDatesWrapper Respuesta de la API de precios en el formato del objeto ContractDatesUpdateAPIWrapper.
    **/
    private static ContractWrapperSAP handleSuccess(ContractWrapperSAP contractWrapperSAP, HTTPResponse response){

        if(response != null){
            ContractWrapperSAP.lstResponse = (List<ContractWrapperSAP.Response>) JSON.deserialize(response.getBody(), List<ContractWrapperSAP.Response>.class);
            contractWrapperSAP.httpCode = response.getStatusCode();
        }
        contractWrapperSAP.status = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractWrapperSAP.responseDateTime = System.now();

        return contractWrapperSAP;
    }

    /**
    * @description Método encargado de devolver la respuesta fallida de la API.
    * @author Miller Mora | 05-08-2024
    * @param contractWrapperSAP Clase Wrapper que contiene datos de la llamada a la API.
    * @param e Excepción capturada al momento de hacer la llamada a la API.
    * @param response Respuesta de la API.
    * @return contractDatesWrapper Respuesta de la API de precios en el formato del objeto ContractDatesUpdateAPIWrapper.
    **/
    private static ContractWrapperSAP handleError(ContractWrapperSAP contractWrapperSAP, Exception e , HTTPResponse response){

        if(response != null){
            contractWrapperSAP.httpCode = response.getStatusCode();
        }
        contractWrapperSAP.responseDateTime = System.now();
        contractWrapperSAP.status = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        contractWrapperSAP.errorMessage = e.getMessage();

        return contractWrapperSAP;
    }


    
}