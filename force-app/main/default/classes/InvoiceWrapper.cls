/**
 * @description       : Wrapper para manejar la creación de una factura recibido desde SAP.
 * @author            : Luis Sandoval
 * @group             : 
 * @last modified on  : 31-10-2024
 * @last modified by  : Juan Felipe Muriel
**/
public virtual class InvoiceWrapper {

    // Constructor 
    public InvoiceWrapper() {
        this.relatedDocs = new List<RelatedDoc>();
    }

    // Request atributes
    public String invoiceNumber;           
    public String contractId;              // Contract Id, external Id
    public Date createdAt;                 
    public Decimal grossAmount;            
    public String currencyIsoCode;         
    public String companyCode;             // Company Id, external Id

    // RelatedDocument List
    public List<RelatedDoc> relatedDocs;  

    public class RelatedDoc {
        public String docId;               
        public String docType;            
        public String description;         
    }
}