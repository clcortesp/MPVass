/**
 * @description Clase que se encarga de construir todos los objetos de la org para uso en clases de test
 * @group Proyecto MP
 * @author Juan Felipe Muriel
**/
@IsTest
global class Build {

    /*------------------------------------------------------------------------
                    UserBuilderStart
    ------------------------------------------------------------------------*/
    public class UserBuilder {
        private User obj = new User();

        public UserBuilder withUsername(String value) {
                obj.Username = value;
                return this;
        }

        public UserBuilder withLastName(String value) {
                obj.LastName = value;
                return this;
        }

        public UserBuilder withEmail(String value) {
                obj.Email = value;
                return this;
        }
        
        public UserBuilder withAlias(String value) {
            obj.Alias = value;
            return this;
        }

        public UserBuilder withProfileId(Profile value) {
            obj.ProfileId = value.Id;
            return this;
        }

        public UserBuilder withIsActive(Boolean value) {
            obj.IsActive = value;
            return this;
        }

        public UserBuilder withUserRoleId(UserRole value) {
            obj.UserRoleId = value.Id;
            return this;
        }

        public User build() {
            obj.EmailEncodingKey = 'UTF-8';
            obj.LanguageLocaleKey = 'en_US';
            obj.LocaleSidKey = 'en_US';
            obj.TimeZoneSidKey = 'America/Los_Angeles';
            return obj;
        }
        
    }

    /** It require following fields to can be inserted: ProfileId. */
    public static UserBuilder anUser() { return new UserBuilder(); }
    /*------------------------------------------------------------------------
                    UserBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    AccountBuilderStart
    ------------------------------------------------------------------------*/
    public class AccountBuilder {
        private Account obj = new Account();

        public AccountBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public AccountBuilder withAccountCurrency(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public AccountBuilder withParentAccount(Account value) {
            obj.ParentId = value.id;
            return this;
        }

        public AccountBuilder withMPExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public AccountBuilder withMPSector(MPBusinessType__c value) {
            obj.MPSector__c = value.id;
            return this;
        }


        public Account build() {
            return obj;
        }
    }

    public static AccountBuilder anAccount() { return new AccountBuilder(); }

    public static AccountBuilder anMPAccount() { 
        AccountBuilder val = new AccountBuilder();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MPAccount').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    public static AccountBuilder anBrandAccount() { 
        AccountBuilder val = new AccountBuilder();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MPBrand').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    public static AccountBuilder anMallAccount() { 
        AccountBuilder val = new AccountBuilder();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MPMall').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    public static AccountBuilder anSocietyAccount() { 
        AccountBuilder val = new AccountBuilder();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MPSociety').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    /*------------------------------------------------------------------------
                    AccountBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    MPBusinessTypeBuilderStart
    ------------------------------------------------------------------------*/
    public class MPBusinessTypeBuilder {
        private MPBusinessType__c obj = new MPBusinessType__c();

        public MPBusinessTypeBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public MPBusinessTypeBuilder withMPExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public MPBusinessTypeBuilder withMPCategory(String value) {
            obj.MPCategory__c = value;
            return this;
        }

        public MPBusinessTypeBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public MPBusinessType__c build() {
            return obj;
        }
    }

    public static MPBusinessTypeBuilder anMPBusinessType() { return new MPBusinessTypeBuilder(); }

    public static MPBusinessTypeBuilder anMPSector() { 
        MPBusinessTypeBuilder val = new MPBusinessTypeBuilder();
        Id recordTypeId = Schema.SObjectType.MPBusinessType__c.getRecordTypeInfosByDeveloperName().get('MPSector').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    public static MPBusinessTypeBuilder anMPBusinessUnit() { 
        MPBusinessTypeBuilder val = new MPBusinessTypeBuilder();
        Id recordTypeId = Schema.SObjectType.MPBusinessType__c.getRecordTypeInfosByDeveloperName().get('MPBusinessUnit').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    /*------------------------------------------------------------------------
                    MPBusinessTypeBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    MPSectorByBusinessUnitBuilderStart
    ------------------------------------------------------------------------*/
    public class SectorByBusinessUnitBuilder {
        private MPSectorByBusinessUnit__c obj = new MPSectorByBusinessUnit__c();

        public SectorByBusinessUnitBuilder withAnnexC(String value) {
            obj.MPAnnexC__c = value;
            return this;
        }

        public SectorByBusinessUnitBuilder withConstructionType(String value) {
            obj.MPConstructionType__c = value;
            return this;
        }
        
        public SectorByBusinessUnitBuilder withUsabilityStatus(String value) {
            obj.MPUsabilityStatus__c = value;
            return this;
        }                
        
        public SectorByBusinessUnitBuilder withAMD(Double value) {
            obj.MPAMD__c = value;
            return this;
        }
        
        public SectorByBusinessUnitBuilder withAP(Double value) {
            obj.MPAP__c = value;
            return this;
        }
        
        public SectorByBusinessUnitBuilder withSector(Id value) {
            obj.MPSector__c = value;
            return this;
        }
        
        public SectorByBusinessUnitBuilder withBusinessUnit(Id value) {
            obj.MPBusinessUnit__c = value;
            return this;
        }

        public MPSectorByBusinessUnit__c build() {
            return obj;
        }
    }

    public static SectorByBusinessUnitBuilder anSectorByBusinessUnit() { return new SectorByBusinessUnitBuilder(); }
    /*------------------------------------------------------------------------
                    MPSectorByBusinessUnitBuilderEnd
    ------------------------------------------------------------------------*/
    
     /*------------------------------------------------------------------------
                    MPStoreBuilderStart
    ------------------------------------------------------------------------*/
    public class MPStoreBuilder {
        private MPStore__c obj = new MPStore__c();

        public MPStoreBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public MPStoreBuilder withMPExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public MPStoreBuilder withMPMall(Account value) {
            obj.MPMall__c = value.id;
            return this;
        }

        public MPStoreBuilder withMPSociety(Account value) {
            obj.MPSociety__c = value.id;
            return this;
        }

        public MPStoreBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public MPStoreBuilder withMPFootage(Decimal value) {
            obj.MPFootage__c = value;
            return this;
        }

        public MPStoreBuilder withMPContractType(Pricebook2 value) {
            obj.MPContractType__c = value.id;
            return this;
        }

        public MPStoreBuilder withMPCeBe(String value) {
            obj.MPCeBe__c = value;
            return this;
        }

        public MPStoreBuilder withMPBusinessUnit(MPBusinessType__c value) {
            obj.MPBusinessUnit__c = value.id;
            return this;
        }

        public MPStoreBuilder withMPUsabilityStatus(String value) {
            obj.MPUsabilityStatus__c = value;
            return this;
        }

        public MPStore__c build() {
            return obj;
        }
    }

    public static MPStoreBuilder anMPStore() { return new MPStoreBuilder(); }

    public static MPStoreBuilder anLocal() { 
        MPStoreBuilder val = new MPStoreBuilder();
        Id recordTypeId = Schema.SObjectType.MPStore__c.getRecordTypeInfosByDeveloperName().get('MPStore').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    public static MPStoreBuilder anMPRentalObject() { 
        MPStoreBuilder val = new MPStoreBuilder();
        Id recordTypeId = Schema.SObjectType.MPStore__c.getRecordTypeInfosByDeveloperName().get('MPRentalObject').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    
    /*------------------------------------------------------------------------
                    MPStoreBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    IntegrationStatusBuilderStart
    ------------------------------------------------------------------------*/
    public class IntegrationStatusBuilder {
        private MPIntegrationStatus__c obj = new MPIntegrationStatus__c();

        public IntegrationStatusBuilder withHttpCode(Double value) {
            obj.MPHttpCode__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withSalesforceException(String value) {
            obj.MPSalesforceException__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withStatus(String value) {
            obj.MPStatus__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withRequestDateTime(Date value) {
            obj.MPRequestDateTime__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withResponseDateTime(Date value) {
            obj.MPResponseDateTime__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withParentId(String value) {
            obj.MPParentId__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withIntegrationName(String value) {
            obj.MPIntegrationName__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withParams(String value) {
            obj.MPParams__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withRequest(String value) {
            obj.MPRequest__c = value;
            return this;
        }
        
        public IntegrationStatusBuilder withResponse(String value) {
            obj.MPResponse__c = value;
            return this;
        }        
                
        public MPIntegrationStatus__c build() {
            return obj;
        }
    }

    public static IntegrationStatusBuilder anIntegrationStatus() { return new IntegrationStatusBuilder(); }
    /*------------------------------------------------------------------------
                    IntegrationStatusBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    Pricebook2BuilderStart
    ------------------------------------------------------------------------*/
    public class Pricebook2Builder {
        private Pricebook2 obj = new Pricebook2();

        public Pricebook2Builder withName(String value) {
            obj.Name = value;
            return this;
        }

        public Pricebook2Builder withMPExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public Pricebook2Builder withMPPaymentCondition(String value) {
            obj.MPPaymentCondition__c = value;
            return this;
        }

        public Pricebook2Builder withMPIsProRataMethod(Boolean value) {
            obj.MPIsProRataMethod__c = value;
            return this;
        }

        public Pricebook2Builder withIsActive(Boolean value) {
            obj.IsActive = value;
            return this;
        }

        public Pricebook2Builder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public Pricebook2 build() {
            return obj;
        }
    }

    public static Pricebook2Builder anPricebook2() { return new Pricebook2Builder(); }
    /*------------------------------------------------------------------------
                    Pricebook2BuilderEnd
    ------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------
                    MPRentalObjectByStoreBuilderStart
    ------------------------------------------------------------------------*/
    public class MPRentalObjectByStoreBuilder {
        private MPRentalObjectByStore__c obj = new MPRentalObjectByStore__c();

        public MPRentalObjectByStoreBuilder withMPStore(MPStore__c value) {
            obj.MPStore__c = value.id;
            return this;
        }

        public MPRentalObjectByStoreBuilder withMPRentalObject(MPStore__c value) {
            obj.MPRentalObject__c = value.id;
            return this;
        }

        public MPRentalObjectByStore__c build() {
            return obj;
        }
    }

    public static MPRentalObjectByStoreBuilder anMPRentalObjectByStore() { return new MPRentalObjectByStoreBuilder(); }
    /*------------------------------------------------------------------------
                    MPRentalObjectByStoreBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    OpportunityBuilderStart
    ------------------------------------------------------------------------*/
    public class OpportunityBuilder {
        private Opportunity obj = new Opportunity();

        public OpportunityBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public OpportunityBuilder withAccount(Account value) {
            obj.AccountId = value.id;
            return this;
        }

        public OpportunityBuilder withBudgetConfirmed(Boolean value) {
            obj.Budget_Confirmed__c = value;
            return this;
        }

        public OpportunityBuilder withCloseDate(Date value) {
            obj.CloseDate = value;
            return this;
        }

        public OpportunityBuilder withDiscoveryCompleted(Boolean value) {
            obj.Discovery_Completed__c = value;
            return this;
        }

        public OpportunityBuilder withMPBrand(Account value) {
            obj.MPBrand__c = value.id;
            return this;
        }

        public OpportunityBuilder withMPMall(Account value) {
            obj.MPMall__c = value.id;
            return this;
        }

        public OpportunityBuilder withStageName(String value) {
            obj.StageName = value;
            return this;
        }

        public OpportunityBuilder withSyncedQuote(Quote value) {
            obj.SyncedQuoteId = value.id;
            return this;
        }

        public OpportunityBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }
        
        public OpportunityBuilder withContractStartDate(Date value) {
            obj.MPContractStartDate__c = value;
            return this;
        }
        
        public OpportunityBuilder withProbableOpeningDate(Date value) {
            obj.MPProbableOpeningDate__c = value;
            return this;
        }

        public OpportunityBuilder withContract(Contract value) {
            obj.ContractId = value.id;
            return this;
        }

        public Opportunity build() {
            return obj;
        }
    }

    public static OpportunityBuilder anOpportunity() { return new OpportunityBuilder(); }


    public static OpportunityBuilder anOppRenov() { 
        OpportunityBuilder val = new OpportunityBuilder();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MPRenovation').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    /*------------------------------------------------------------------------
                    OpportunityBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    QuoteBuilderStart
    ------------------------------------------------------------------------*/
    public class QuoteBuilder {
        private Quote obj = new Quote();

        public QuoteBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public QuoteBuilder withMPStore(MPStore__c value) {
            obj.MPStore__c = value.id;
            return this;
        }

        public QuoteBuilder withOpportunity(Opportunity value) {
            obj.OpportunityId = value.id;
            return this;
        }

        public QuoteBuilder withStatus(String value) {
            obj.Status = value;
            return this;
        }

        
        public QuoteBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public Quote build() {
            return obj;
        }
    }

    public static QuoteBuilder anQuote() { return new QuoteBuilder(); }
    /*------------------------------------------------------------------------
                    QuoteBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    AdjustmentBuilderStart
    ------------------------------------------------------------------------*/
    
    public class AdjustmentBuilder {
        private MPAdjustment__c obj = new MPAdjustment__c();
        
        public AdjustmentBuilder withAdjustmentType(String value) {
            obj.MPAdjustmentType__c = value;
            return this;
        }
        
        public AdjustmentBuilder withExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }
        
        public AdjustmentBuilder withUsabilityStatus(String value) {
            obj.MPUsabilityStatus__c = value;
            return this;
        }
        
        public AdjustmentBuilder withPeriod(String value) {
            obj.MPPeriod__c = value;
            return this;
        }        
        
        public AdjustmentBuilder withValue(Double value) {
            obj.MPValue__c = value;
            return this;
        }

        public MPAdjustment__c build() {
            return obj;
        }
    }
    
    public static AdjustmentBuilder anStrategicAdjustment() { 
        AdjustmentBuilder val = new AdjustmentBuilder();
        Id recordTypeId = Schema.SObjectType.MPAdjustment__c.getRecordTypeInfosByDeveloperName().get('MPStrategicAdjustment').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return new AdjustmentBuilder(); 
    }    
    
    /*------------------------------------------------------------------------
                    AdjustmentBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    CalculationRuleBuilderStart
    ------------------------------------------------------------------------*/
    public class CalculationRuleBuilder {
        private MPCalculationRule__c obj = new MPCalculationRule__c();
        
        public CalculationRuleBuilder withUsabilityStatus(String value) {
            obj.MPUsabilityStatus__c = value;
            return this;
        }            
        
        public CalculationRuleBuilder withExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }    
        
        public CalculationRuleBuilder withName(String value) {
            obj.Name = value;
            return this;
        }    
        
        public MPCalculationRule__c build() {
            return obj;
        }
    }
    
    public static CalculationRuleBuilder anCalculationRule() { return new CalculationRuleBuilder(); }
    
    /*------------------------------------------------------------------------
                    CalculationRuleBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    ContractConditionBuilderStart
    ------------------------------------------------------------------------*/
    public class ContractConditionBuilder {
        private MPContractCondition__c obj = new MPContractCondition__c();
        
        public ContractConditionBuilder withApplyTimeScale(Boolean value) {
            obj.MPApplyTimeScale__c = value;
            return this;
        }
        
        public ContractConditionBuilder withApplyVolumeScale(Boolean value) {
            obj.MPApplyVolumeScale__c = value;
            return this;
        }
                
        public ContractConditionBuilder withUsabilityStatus(String value) {
            obj.MPUsabilityStatus__c = value;
            return this;
        }
        
        public ContractConditionBuilder withAdjustmentType(String value) {
            obj.MPAdjustmentType__c = value;
            return this;
        }
        
        public ContractConditionBuilder withSuggestedValue(Double value) {
            obj.MPSuggestedValue__c = value;
            return this;
        }
        
        public ContractConditionBuilder withConditionClass(Id value) {
            obj.MPConditionClass__c = value;
            return this;
        }
        
        public ContractConditionBuilder withContractType(Id value) {
            obj.MPContractType__c = value;
            return this;
        }
        
        public ContractConditionBuilder withSuggestedCalculationRule(Id value) {
            obj.MPSuggestedCalculationRule__c = value;
            return this;
        }
        
        public ContractConditionBuilder withSuggestedAdjustment(Id value) {
            obj.MPSuggestedAdjustment__c = value;
            return this;
        }
        
        public ContractConditionBuilder withGetValueFromPricing(Boolean value) {
            obj.MPGetValueFromPricing__c = value;
            return this;
        }
        
        public ContractConditionBuilder withIsDefault(Boolean value) {
            obj.MPIsDefault__c = value;
            return this;
        }

        public ContractConditionBuilder withIsModifiable(Boolean value){
            obj.MPIsModifiable__c = value;
            return this;
        }
        
        public MPContractCondition__c build() {
            return obj;
        }
    }
    
    public static ContractConditionBuilder anContractCondition() { return new ContractConditionBuilder(); }
    
    /*------------------------------------------------------------------------
                    ContractConditionBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    QuoteConditionBuilderStart
    ------------------------------------------------------------------------*/
    public class QuoteConditionBuilder {
        private MPQuoteCondition__c obj = new MPQuoteCondition__c();

        public QuoteConditionBuilder withMPQuote(Quote value) {
            obj.MPQuote__c = value.id;
            return this;
        }

        public QuoteConditionBuilder withMPContractCondition(MPContractCondition__c value) {
            obj.MPContractCondition__c = value.id;
            return this;
        }

        public QuoteConditionBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public MPQuoteCondition__c build() {
            return obj;
        }
    }

    public static QuoteConditionBuilder anQuoteCondition() { return new QuoteConditionBuilder(); }
    /*------------------------------------------------------------------------
                    QuoteConditionBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    ScaleBuilderEnd
    ------------------------------------------------------------------------*/
    
    public class ScaleBuilder {
        private MPScale__c obj = new MPScale__c();

        public ScaleBuilder withFinalVolume(Double value) {
            obj.MPFinalVolume__c = value;
            return this;
        }
        
        public ScaleBuilder withInitialVolume(Double value) {
            obj.MPInitialVolume__c = value;
            return this;
        }
        
        public ScaleBuilder withValue(Double value) {
            obj.MPValue__c = value;
            return this;
        }
        
        public ScaleBuilder withEscala(Id value) {
            obj.Escala__c = value;
            return this;
        }        
        
        public ScaleBuilder withQuoteCondition(ID value) {
            obj.MPQuoteCondition__c = value;
            return this;
        }
        
        public ScaleBuilder withEndDate(Date value) {
            obj.MPEndDate__c = value;
            return this;
        }
        
        public ScaleBuilder withStartDate(Date value) {
            obj.MPStartDate__c = value;
            return this;
        }

        public MPScale__c build() {
            return obj;
        }
    }
    
    public static ScaleBuilder anTimeScale() { 
        ScaleBuilder val = new ScaleBuilder();
        Id recordTypeId = Schema.SObjectType.MPScale__c.getRecordTypeInfosByDeveloperName().get('Time').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    
    public static ScaleBuilder anVolumeScale() { 
        ScaleBuilder val = new ScaleBuilder();
        Id recordTypeId = Schema.SObjectType.MPScale__c.getRecordTypeInfosByDeveloperName().get('Volume').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }
    
     /*------------------------------------------------------------------------
                    ScaleBuilderStart
    ------------------------------------------------------------------------*/


     /*------------------------------------------------------------------------
                    ContractBuilderStart
    ------------------------------------------------------------------------*/
    public class ContractBuilder {
        private Contract obj = new Contract();

        public ContractBuilder withName(String value) {
            obj.Name = value;
            return this;
        }

        public ContractBuilder withAccount(Account value) {
            obj.AccountId = value.Id;
            return this;
        }

        public ContractBuilder withMall(Account value) {
            obj.MPMall__c = value.Id;
            return this;
        }

        public ContractBuilder withMarca(Account value) {
            obj.MPBrand__c = value.Id;
            return this;
        }

        public ContractBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }

        public ContractBuilder withStartDate(Date value) {
            obj.StartDate = value;
            return this;
        }

        public ContractBuilder withEndDate(Integer value) {
            obj.ContractTerm = value;
            return this;
        }

        public ContractBuilder withOrder(Order value) {
            obj.MPCurrentOrder__c = value.Id;
            return this;
        }

        public ContractBuilder withOpp(Opportunity value) {
            obj.MPOpportunity__c = value.Id;
            return this;
        }

        public ContractBuilder withStatus(String value) {
            obj.Status = value;
            return this;
        }

        public ContractBuilder withExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public ContractBuilder withRentalStartDate(Date value) {
            obj.MPRentalStartDate__c = value;
            return this;
        }

        public ContractBuilder withProbableOpeningDate(Date value) {
            obj.MPProbableOpeningDate__c = value;
            return this;
        }

        public Contract build() {
            return obj;
        }
    }

    public static ContractBuilder aContract() { return new ContractBuilder(); }

    /*------------------------------------------------------------------------
                    ContractBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    OrderBuilderStart
    ------------------------------------------------------------------------*/
    public class OrderBuilder {
        private Order obj = new Order();

        public OrderBuilder withAccount(Account value) {
            obj.AccountId = value.Id;
            return this;
        }

        public OrderBuilder withContract(Contract value) {
            obj.ContractId = value.Id;
            return this;
        }

        public OrderBuilder withStore(MPStore__c value) {
            obj.MP_Local__c = value.Id;
            return this;
        }

        public OrderBuilder withEffectiveDate(Date value) {
            obj.EffectiveDate = value;
            return this;
        }

        public OrderBuilder withStatus(String value) {
            obj.Status = value;
            return this;
        }

        public OrderBuilder withStage(String value) {
            obj.MPStage__c = value;
            return this;
        }

        public OrderBuilder withCurrencyIsoCode(String value) {
            obj.CurrencyIsoCode = value;
            return this;
        }
        
        public OrderBuilder withSpecialConditionAmount(Double value) {
            obj.MPSpecialConditionAmount__c = value;
            return this;
        }        

        public Order build() {
            return obj;
        }
    }

    public static OrderBuilder anOrder() { return new OrderBuilder(); }

    public static OrderBuilder anMPOrderTermination() { 
        OrderBuilder val = new OrderBuilder();
        Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MPTermination').getRecordTypeId();
        val.obj.RecordTypeId = recordTypeId;
        return val;
    }

    /*------------------------------------------------------------------------
                    OrderBuilderEnd
    ------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
                    Product2BuilderStart
    ------------------------------------------------------------------------*/
    public class ProductBuilder {
        private product2 obj = new product2();

        public ProductBuilder withName (String value) {
            obj.name = value;
            return this;
        }

        public ProductBuilder withProductCode(String value) {
            obj.ProductCode = value;
            return this;
        }

        public ProductBuilder withMPExternalCode(String value) {
            obj.MPExternalCode__c = value;
            return this;
        }

        public ProductBuilder withIsActive(Boolean value) {
            obj.IsActive = value;
            return this;
        }        

        public product2 build() {
            return obj;
        }
    }

    public static ProductBuilder anProduct2() { return new ProductBuilder(); }

    /*------------------------------------------------------------------------
                    Product2BuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    OrderConditionBuilderStart
    ------------------------------------------------------------------------*/
    public class OrderConditionBuilder {
        private MPOrderCondition__c obj = new MPOrderCondition__c();

        public OrderConditionBuilder withOrder(Order value) {
            obj.MPOrder__c = value.Id;
            return this;
        }

        public OrderConditionBuilder withConditionClass(Product2 value) {
            obj.MPConditionClass__c = value.Id;
            return this;
        }

        public OrderConditionBuilder withCalculationRule(MPCalculationRule__c value) {
            obj.MPCalculationRule__c = value.Id;
            return this;
        }

        public OrderConditionBuilder withAdjustmentType(MPAdjustment__c value) {
            obj.MPAdjustment__c = value.Id;
            return this;
        }

        public OrderConditionBuilder withStartDate(Date value) {
            obj.MPStartDate__c = value;
            return this;
        }

        public OrderConditionBuilder withEndDate(Date value) {
            obj.MPEndDate__c = value;
            return this;
        }

        public OrderConditionBuilder withVolumenValue(Double value) {
            obj.MPVolumenValue__c = value;
            return this;
        }

        public OrderConditionBuilder withValue(Double value) {
            obj.MPValue__c = value;
            return this;
        }

        public OrderConditionBuilder withFinalVolumen(Double value) {
            obj.MPFinalVolume__c = value;
            return this;
        }

        public OrderConditionBuilder withIntialVolumen(Double value) {
            obj.MPInitialVolume__c = value;
            return this;
        }

        public MPOrderCondition__c build() {
            return obj;
        }
    }

    public static OrderConditionBuilder anOrderCondition() { return new OrderConditionBuilder(); }

    /*------------------------------------------------------------------------
                    OrderConditionBuilderEnd
    ------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------
                    MPIntegrationStatusBuilderStart
    ------------------------------------------------------------------------*/
    public class MPIntegrationStatusBuilder {
        private MPIntegrationStatus__c obj = new MPIntegrationStatus__c();

        public MPIntegrationStatusBuilder withParentId (String value) {
            obj.MPParentId__c = value;
            return this;
        }

        public MPIntegrationStatusBuilder withStatus(String value) {
            obj.MPStatus__c = value;
            return this;
        }

        public MPIntegrationStatusBuilder withMPIntegrationName(String value) {
            obj.MPIntegrationName__c = value;
            return this;
        }   

        public MPIntegrationStatus__c build() {
            return obj;
        }
    }

    public static MPIntegrationStatusBuilder anMPIntegrationStatus() { return new MPIntegrationStatusBuilder(); }

    /*------------------------------------------------------------------------
                    MPIntegrationStatusBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    MPContractTerminationRecordsBuilderStart
    ------------------------------------------------------------------------*/
    public class MPContractTerminationRecordsBuilder {
        private MPContractTerminationRecords__c obj = new MPContractTerminationRecords__c();

        public MPContractTerminationRecordsBuilder withOrder (Order value) {
            obj.MPOrder__c = value.id;
            return this;
        }

        public MPContractTerminationRecordsBuilder withStatus(String value) {
            obj.MPStatus__c = value;
            return this;
        }  

        public MPContractTerminationRecords__c build() {
            return obj;
        }
    }

    public static MPContractTerminationRecordsBuilder anMPContractTerminationRecords() { return new MPContractTerminationRecordsBuilder(); }

    /*------------------------------------------------------------------------
                     MPContractTerminationRecordsBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    MPTerminationRecordBuilderStart
    ------------------------------------------------------------------------*/
    public class MPTerminationRecordBuilder {
        private MPTerminationRecord__c obj = new MPTerminationRecord__c();

        public MPTerminationRecordBuilder withFTC (MPContractTerminationRecords__c value) {
            obj.FTC__c = value.id;
            return this;
        }

        public MPTerminationRecordBuilder withCategory (String value) {
            obj.MPCategory__c = value;
            return this;
        }
        
        public MPTerminationRecordBuilder withSubCategory (String value) {
            obj.MPSubcategory__c = value;
            return this;
        }

        public MPTerminationRecordBuilder withItemCode (String value) {
            obj.MPItemCode__c = value;
            return this;
        }

        public MPTerminationRecordBuilder withStatus(String value) {
            obj.MPStatus__c = value;
            return this;
        }
        
        public MPTerminationRecordBuilder withItemValue(Double value) {
            obj.MPItemValue__c = value;
            return this;
        }

        public MPTerminationRecord__c build() {
            return obj;
        }
    }

    public static MPTerminationRecordBuilder anMPTerminationRecord() { return new MPTerminationRecordBuilder(); }

    /*------------------------------------------------------------------------
                     MPTerminationRecordBuilderEnd
    ------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
                    MPInvoiceBuilderStart
    ------------------------------------------------------------------------*/
    public class MPInvoiceBuilder {
        private MPInvoice__c obj = new MPInvoice__c();

        public MPInvoiceBuilder withOrder (Order value) {
            obj.Orden__c = value.id;
            return this;
        }

        public MPInvoiceBuilder withInvoiceNumber(String value) {
            obj.MPInvoiceNumber__c = value;
            return this;
        }

        public MPInvoice__c build() {
            return obj;
        }
    }

    public static MPInvoiceBuilder anMPInvoice() { return new MPInvoiceBuilder(); }

    /*------------------------------------------------------------------------
                     MPInvoiceBuilderEnd
    ------------------------------------------------------------------------*/

}