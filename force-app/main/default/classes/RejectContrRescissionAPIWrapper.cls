public with sharing class RejectContrRescissionAPIWrapper {

    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public Request request { get; set; }
    public Response response { get; set; }
    public Params params { get; set; }

    public RejectContrRescissionAPIWrapper() {
        this.request = new Request();  // Inicialización de Request
        this.response = new Response();  // Inicialización de Response
        this.params = new Params();  // Inicialización de Params
    }

    public class Request{

        public String description { get; set; }  
        public List<String> itemCodes { get; set; }  
        public String closeContractSheetId { get; set; } 
        public List<String> categories { get; set; }  

        public Request() {
            this.itemCodes = new List<String>();  
            this.categories = new List<String>(); 
        }
    }

    public class Response{
        public String message{ get; set; }
    }

    public class Params{
        public String companyCode{ get; set; }
        public String contractId{ get; set; }
    }

}