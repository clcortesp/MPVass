/**
 * @description Class representing the data structure received in the body of the (4.7) inbound integration.
 * @group MP Project
 * @author Juan Felipe Muriel
 * @since 10-30-2024 - Creation
 * @TestClass ContractTermAmountsAPITest
 */
public with sharing class ContractTermWrapper {

    ContractTermWrapper(){
        this.itemValue = null;
        this.ftc = null;
    }

    /** Attributes in the integration request body */
    public String operationType;
    public String description;
    public String category;
    public String itemCode;
    public List<ItemValue> itemValues;
    public String documentNumber;
    public String documentType;
    public String documentReference;
    public Date documentDate;
    public Date documentDueDate;
    public String subcategory;
    /**
     * @description Class representing the list of items in different currencies
     */
    public class ItemValue {
        public String currencyIsoCode;
        public Decimal oValue;
    }

    /** Additional attributes for additional logic */
    public Decimal itemValue; // It's used to store the itemValue according to the contract currency
    public String ftc; //It's used to store the ftc id
}