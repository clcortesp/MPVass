/**
 * @description Clase cuyo objetivo es proveer datos de prueba para integraciones
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
@isTest
public with sharing class HttpMock implements HttpCalloutMock {

    private String responseData;
    private Integer statusCodeResponse;
    private Map<String, String> headers;
    private final Integer SUCCESS_CODE = 200;
    private final Integer ERROR_CODE = 500;

    public HttpMock(String responseData, Integer statusCodeResponse, Map<String, String> headers){
        this.responseData = responseData;
        this.statusCodeResponse = statusCodeResponse;
        this.headers = headers;
    }

    /**
    * @description: Método que imita la respuesta de un servicio externo
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param req 
    * @return HttpResponse 
    **/
    public HttpResponse respond(HttpRequest request) {

        HttpResponse response = new HttpResponse();

        if (headers != null) {
            for (String headerName : headers.keySet()) {
                response.setHeader(headerName, headers.get(headerName));
            }
        }
        if(statusCodeResponse == SUCCESS_CODE){
            response.setBody(this.responseData);
            response.setStatusCode(this.statusCodeResponse);
        }else{
            response.setBody(this.responseData);
            Integer statusCodeInt = this.statusCodeResponse != null ? this.statusCodeResponse : ERROR_CODE;
            response.setStatusCode(statusCodeInt);
        }
        return response;
    } 
}