public with sharing class GetContractAPIWrapper {
    
    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public Request request { get; set; }
    public Response response { get; set; }
    public Params params { get; set; }

    public GetContractAPIWrapper(){
        this.request = new Request();  // Inicialización de Request
        this.response = new Response();  // Inicialización de Response
        this.params = new Params();  // Inicialización de Params
    }

    public class Request{
    }

    public class Response{
        public String message{ get; set; }
    }

    public class Params{
        public String companyCode{ get; set; }
        public String contractId{ get; set; }
    }

}