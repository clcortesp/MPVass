public with sharing class AgreementContRescissionAPIWrapper {

    public Datetime requestDateTime;
    public Datetime responseDateTime;
    public String status;
    public String salesforceErrorMessage;
    public Integer httpCode;
    public Request request { get; set; }
    public Response response { get; set; }
    public Params params { get; set; }

    public AgreementContRescissionAPIWrapper() {
        this.request = new Request();  // Inicialización de Request
        this.response = new Response();  // Inicialización de Response
        this.params = new Params();  // Inicialización de Params
    }

    public class Request{
        public String mallName { get; set; }  
        public CloseContractTotal closeContractTotal { get; set; } 
        public String manager { get; set; }  
        public List<compensation> compensation { get; set; }
        public String companyName { get; set; }  
        public String assistantManager { get; set; }  
        public Contract contract { get; set; }  
        public String collectionExecutive { get; set; }  
        public Date validFrom { get; set; } 
        public String closeContractSheetId { get; set; }  
        public Date invoiceLastDate { get; set; }  
        public List<LegalRepresentative> legalRepresentative { get; set; }  
        public String commercialManager { get; set; }  
        public Decimal installments { get; set; }  
        public String methodOfPayment { get; set; }  
        public Boolean applyWarranty { get; set; }  
        public String taxId { get; set; } 
        public String brand { get; set; }  
        public List<Item> items { get; set; }  
        public Date applicationDate { get; set; } 
        
        public Request() {
            this.closeContractTotal = new CloseContractTotal();
            this.contract = new Contract();
            this.legalRepresentative = new List<LegalRepresentative>();
            this.items = new List<Item>();
            this.compensation = new List<compensation>();
        }
    }

    public class  CloseContractTotal{
        public Decimal oValue { get; set; }  
        public String currencyIsoCode { get; set; } 
    }

    public class compensation {
        public Decimal oValue { get; set; }  
        public String operationType { get; set; } 
        public String currencyIsoCode { get; set; } 
    }

    public class Contract {
        public Date terminationDate { get; set; } 
        public String name { get; set; } 
        public String pdfUrl { get; set; } 
        public String id { get; set; }  
    }

    
    public class LegalRepresentative {
        public String fullName { get; set; }  
        public String address { get; set; } 
        public String taxId { get; set; }  
    }

    
    public class Item {
        public String documentType { get; set; } 
        public String documentNumber { get; set; }  
        public String itemCode { get; set; }  
        public String description { get; set; } 
        public String operationType { get; set; }  
        public String documentReference { get; set; }  
        public String category { get; set; }  
        public List<ItemValue> itemValues { get; set; }  

        public Item() {
            this.itemValues = new List<ItemValue>();
        }
    }

   
    public class ItemValue {
        public Decimal oValue { get; set; }  
        public String currencyIsoCode { get; set; }  
    }


    public class Response{
        public String message{ get; set; }
    }

    public class Params{
        public String companyCode{ get; set; }
        public String contractId{ get; set; }
    }
}