/**
 * @description Clase cuyo objetivo es definir la estructura a utilizar en las peticiones y en las respuestas 
 * de la API de Actualizacion de fechas de contrato
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 20-08-2024 - Creación
 */
public with sharing class ContractDatesUpdateAPIWrapper {
    // Atributos usados para guardar los logs
    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public Request request { get; set; }
    public Response response { get; set; }
    public Params params { get; set; }

    public ContractDatesUpdateAPIWrapper(){
        this.request = new Request();  // Inicialización de Request
        this.response = new Response();  // Inicialización de Response
        this.params = new Params();  // Inicialización de Params
    }

    public class Request{
        public Date invoiceDate{ get; set; }
        public Date deliveryActDate{ get; set; }
        public Date openingDate{ get; set; }
    }

    public class Response{
        public String message{ get; set; }
    }

    public class Params{
        public String companyCode{ get; set; }
        public String contractId{ get; set; }
    }
}