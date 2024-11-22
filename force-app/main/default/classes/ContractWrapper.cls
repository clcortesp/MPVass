/**
 * @description Apex class representing a contract object, with all the attributes necessary for communication between SAP and SALESFORCE
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 21-10-2024 - Creación
 */
public virtual class ContractWrapper {
    public ContractWrapper() {
        this.condition = new List<Condition>();
        this.rentalObject = new List<RentalObject>();
        this.partner = new List<Partner>();
        this.salesBasedRentAgreement = new List<SalesBasedRentAgreement>();
        this.subClause = new List<SubClause>();
        this.meas = new List<Meas>();
        this.termAdjust = new List<TermAdjust>();
    } 

    public String otype { get; set; } 
    public String id { get; set; }
    public String name { get; set; }
    public String cebe { get; set; }
    public String startDate { get; set; }
    public String currencyIsoCode { get; set; }
    public String offerId { get; set; }
    public String endDate { get; set; }
    public String adjustmentRule { get; set; }
    public String salesCurrencyIsoCode { get; set; }
    public String salesStartDate { get; set; }
    public String indexSeriesBaseYear { get; set; }
    public String indexSeries { get; set; }
    public Decimal percSalesAsRent { get; set; }
    public String paymentCondition { get; set; }
    public String sector { get; set; }
    public Boolean isSalesRelated { get; set; }
    public Boolean isMainContract { get; set; }
    public String note { get; set; }
    public String adjmFirstDate { get; set; }
    public String indexFirstDate { get; set; }
    public String lastInvoiceDate { get; set; }
    public Boolean isProRataMethod { get; set; }
    public String companyCode { get; set; }
    public List<Condition> condition { get; set; }
    public List<RentalObject> rentalObject { get; set; }
    public List<Partner> partner { get; set; }
    public List<SalesBasedRentAgreement> salesBasedRentAgreement { get; set; }
    public List<SubClause> subClause { get; set; }
    public List<Meas> meas { get; set; }
    public List<TermAdjust> termAdjust { get; set; }

    public class Condition {
        public String calcRule { get; set; }
        public String otype { get; set; } //it's the 'type' atribute but used in Contract Creation
        public String type { get; set; }
        public String currencyIsoCode { get; set; }
        public String distributionRule { get; set; }
        public String externalPurpose { get; set; }
        public Decimal unitPrice { get; set; }
        public String validFrom { get; set; }
        public String validTo { get; set; }
    }

    public class RentalObject {
        public String id { get; set; }
        public String otype { get; set; }
        public Boolean isInfo { get; set; }
    }

    public class Partner {
        public String id { get; set; } 
        public String otype { get; set; } 
        public String validFrom { get; set; } 
        public String validTo { get; set; } 
         // public String idContact{get;set;} 
        //public String otypeContact {get;set;}
    }

    public class SalesBasedRentAgreement {
        public Decimal valueFrom { get; set; }
        public Decimal valueTo { get; set; }
        public Decimal percent { get; set; }
    }

    public class SubClause {}

    public class Meas {}

    public class TermAdjust {
        public String termNo { get; set; }
        public String termText { get; set; }
        public String adjustmentRule { get; set; }
        public String elementaryAdjRule { get; set; }
        public String indexSeries { get; set; }
        public String conditionType { get; set; }
        public String indexPointsAdoptionDate { get; set; }
        public String firstAdjustmentDate { get; set; }
    }
}