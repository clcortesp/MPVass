public with sharing class ContractRescissionAPIWrapper {

    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public Request request { get; set; }
    public Response response { get; set; }
    public Params params { get; set; }

    public ContractRescissionAPIWrapper(){
        this.request = new Request();  // Inicialización de Request
        this.response = new Response();  // Inicialización de Response
        this.params = new Params();  // Inicialización de Params
    }

    public class Request{
        public Request(){
            this.requester = new Requester(); 
        }
        public Date closeDate{ get; set; }
        public Boolean doCalculation{ get; set; }
        public Boolean doContractBlocking{ get; set; }
        public Requester requester { get; set; }
    }

    public class Requester{
        public String fullName { get; set; }
        public String email { get; set; }
    }

    public class Response{
        public String message{ get; set; }
    }

    public class Params{
        public String companyCode{ get; set; }
        public String contractId{ get; set; }
    }

}