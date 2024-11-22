/**
* @description Test Class for DefaultQuote_cls
* @group Mallplaza (MP) proyect
* @author Marco Andres Guevara
* @since 28-08-2024 - Creation
*/
@isTest
private class DefaultQuote_test {
        @testSetup
    static void setup(){
        /**Pricebook creation (Contract Type) */
        Pricebook2 contractType = Build.anPricebook2()
            .withName('Contrato Comercial Perú')
            .withMPPaymentCondition('MP12')
            .withMPIsProRataMethod(true)
            .withMPExternalCode('P101')
            .withIsActive(true)
            .withCurrencyIsoCode('PEN')
            .build();
        insert contractType;
        /**End pricebook (Contract Type) */
        /**MPAdjustment__c creation (Ajustes) */        
        MPAdjustment__c objAdjustment = Build.anStrategicAdjustment()
            .withAdjustmentType('REAJ%')
            .withExternalCode('CO12MES2,5')
            .withUsabilityStatus('Use')
            .withPeriod('12')
            .withValue(2)
            .build();
        insert objAdjustment;
        /**End MPAdjustment__c (Ajustes) */
        /**MPCalculationRule__c creation (Norma de calculo) */        
        MPCalculationRule__c objCalculationRule = Build.anCalculationRule()
            .withUsabilityStatus('Use')
            .withExternalCode('MP02')
            .withName('Tarifa * m2')
            .build();
        insert objCalculationRule;
        /**End MPCalculationRule__c (Norma de calculo) */
        /**Product2 creation (Condition Class) */        
        Product2 objProductAM15 = Build.anProduct2()
            .withName('AM15')
            .withProductCode('AM15')
            .withMPExternalCode('AM15')
            .withIsActive(true)
            .build();
        Product2 objProductAM17 = Build.anProduct2()
            .withName('AM17')
            .withProductCode('AM17')
            .withMPExternalCode('AM17')
            .withIsActive(true)
            .build();
        Product2 objProductAM19 = Build.anProduct2()
            .withName('AM19')
            .withProductCode('AM19')
            .withMPExternalCode('AM19')
            .withIsActive(true)
            .build();
        Product2 objProductAP10 = Build.anProduct2()
            .withName('AP10')
            .withProductCode('AP10')
            .withMPExternalCode('AP10')
            .withIsActive(true)
            .build();
        Product2 objProductAD10 = Build.anProduct2()
            .withName('AD10')
            .withProductCode('AD10')
            .withMPExternalCode('AD10')
            .withIsActive(true)
            .build();
        Product2 objProductCI15 = Build.anProduct2()
            .withName('CI15')
            .withProductCode('CI15')
            .withMPExternalCode('CI15')
            .withIsActive(true)
            .build();
        Product2 objProductG010 = Build.anProduct2()
            .withName('G010')
            .withProductCode('G010')
            .withMPExternalCode('G010')
            .withIsActive(true)
            .build();
        Product2 objProductG030 = Build.anProduct2()
            .withName('G030')
            .withProductCode('G030')
            .withMPExternalCode('G030')
            .withIsActive(true)
            .build();
        Product2 objProductFP20 = Build.anProduct2()
            .withName('FP20')
            .withProductCode('FP20')
            .withMPExternalCode('FP20')
            .withIsActive(true)
            .build();
        insert new List<Product2>{objProductAM15,objProductAM17,objProductAM19,objProductAP10,objProductAD10,objProductCI15,objProductG010,objProductG030,objProductFP20};
            /**End Product2 (Condition Class) */            
            /**Contract Condition creation */
            MPContractCondition__c objContractConditionAM15 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAM15.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .withIsModifiable(true)
            .build();
        MPContractCondition__c objContractConditionAM17 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAM17.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionAM19 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAM19.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionAP10 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAP10.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .withIsModifiable(true)
            .build();
        MPContractCondition__c objContractConditionAD10 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAD10.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .withIsModifiable(true)
            .build();
        MPContractCondition__c objContractConditionCI15 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductCI15.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionG010 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductG010.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionG030 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductG030.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionFP20 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductFP20.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .withIsModifiable(true)
            .build();
        insert new List<MPContractCondition__c>{objContractConditionAM15,objContractConditionAM17,objContractConditionAM19,objContractConditionAP10,objContractConditionAD10,objContractConditionCI15,objContractConditionG010,objContractConditionG030,objContractConditionFP20};
            /**End Contract Condition */  
            
            
            
            /**Business type creation */
            MPBusinessType__c sector = Build.anMPSector()
            .withName('Burger Food')
            .withMPExternalCode('S-000001')
            .withMPCategory('Autoplaza')
            .withCurrencyIsoCode('PEN')
            .build();
        MPBusinessType__c businessUnit = Build.anMPBusinessUnit()
            .withName('Fast Food')
            .withMPExternalCode('B-000001')
            .withCurrencyIsoCode('PEN')
            .build();
        insert new List<MPBusinessType__c>{sector,businessUnit};
            /**End Business type */
            /**Sector By Business Unit creation */
            
            MPSectorByBusinessUnit__c objMPSectorByBusinessUnit1 = Build.anSectorByBusinessUnit()
            .withAnnexC('asd')
            .withConstructionType('asd')
            .withUsabilityStatus('Use')
            .withAMD(10)
            .withAP(15)
            .withSector(sector.id)
            .withBusinessUnit(businessUnit.id)
            .build();
        insert new List<MPSectorByBusinessUnit__c>{objMPSectorByBusinessUnit1};
            
            /**End Sector By Business Unit */
            /**Account Creation */
            Account parentAcc = Build.anMPAccount()
            .withName('Parent Account')
            .withAccountCurrency('PEN')
            .build();
        insert parentAcc;
        
        Account brandAccount = Build.anBrandAccount()
            .withName('Brand Account 01')
            .withAccountCurrency('PEN')
            .withParentAccount(parentAcc)
            .withMPSector(sector)
            .build();
        Account mallAccount = Build.anMallAccount()
            .withName('Mall Account 01')
            .withAccountCurrency('PEN')
            .withMPExternalCode('PNO')
            .build();
        Account societyAccount = Build.anSocietyAccount()
            .withName('Society Account 01')
            .withAccountCurrency('PEN')
            .build();
        insert new List<Account>{brandAccount, mallAccount, societyAccount} ;
            /**Fin crear cuentas */
            
            /**Crear locales y Objetos de alquiler */
            MPStore__c store = Build.anLocal()
            .withName('Local 1001')
            .withMPMall(mallAccount)
            .withMPFootage(100)
            .withMPExternalCode('store-0001')
            .withMPCeBe('cebe-001')
            .withMPBusinessUnit(businessUnit)
            .withCurrencyIsoCode('PEN')
            .withMPUsabilityStatus('Use')
            .withMPSociety(societyAccount)
            .withMPContractType(contractType)
            .build();
        MPStore__c rentalObject1 = Build.anMPRentalObject()
            .withName('OA 1001')
            .withMPMall(mallAccount)
            .withMPFootage(30)
            .withMPExternalCode('OA1001EXID')
            .withMPCeBe('')
            .withMPBusinessUnit(businessUnit)
            .withCurrencyIsoCode('PEN')
            .withMPUsabilityStatus('Use')
            .withMPSociety(societyAccount)
            .withMPContractType(contractType)
            .build();
        MPStore__c rentalObject2 = Build.anMPRentalObject()
            .withName('OA 1002')
            .withMPMall(mallAccount)
            .withMPFootage(30)
            .withMPExternalCode('OA1002EXID')
            .withMPCeBe('')
            .withMPBusinessUnit(businessUnit)
            .withCurrencyIsoCode('PEN')
            .withMPUsabilityStatus('Use')
            .withMPSociety(societyAccount)
            .withMPContractType(contractType)
            .build();
        insert new List<MPStore__c>{store,rentalObject1,rentalObject2};
            /**Fin local y Objetos de alquiler*/
            
            /**Crear Objeto de Alquiler por local */
            MPRentalObjectByStore__c rentalObjectByStore1 = Build.anMPRentalObjectByStore()
            .withMPRentalObject(rentalObject1)
            .withMPStore(store)
            .build();
        MPRentalObjectByStore__c rentalObjectByStore2 = Build.anMPRentalObjectByStore()
            .withMPRentalObject(rentalObject2)
            .withMPStore(store)
            .build();
        insert new List<MPRentalObjectByStore__c>{rentalObjectByStore1,rentalObjectByStore2};
            /**Fin local y Objetos de alquiler*/
            
            /**Crear Oportunidad */
            Opportunity opportunity1 = Build.anOpportunity()
            .withName('opportunity1')
            .withStageName('Exploración')
            .withAccount(parentAcc)
            .withMPBrand(brandAccount)
            .withMPMall(mallAccount)
            .withCloseDate((System.now().date()))
            .withCurrencyIsoCode('PEN')
            .withContractStartDate(Date.today())
            .withProbableOpeningDate(Date.today()+500)
            .build();        
        insert new List<Opportunity>{opportunity1};
            /**Fin Oportunidad */
            /**Crear IntegrationStatus */
            
            MPIntegrationStatus__c objIntegrationStatus = Build.anIntegrationStatus()
            .withHttpCode(200)            
            .withStatus('Success')
            .withRequestDateTime(Date.Today())
            .withResponseDateTime(Date.Today())
            .withParentId(opportunity1.id)
            .withIntegrationName('MPGETContract')
            .withParams('{"contractId":"35083","companyCode":"1200"}')
            .withRequest('{}')
            .withResponse('{"id":"0000000035083","companyCode":"1200","name":"ALDO_XI_PTR","isMainContract":"false","currencyIsoCode":"UF","startDate":"2022-03-08","endDate":"2027-03-07","sector":"SR421","note":"","offerId":"SF0002","adjustmentRule":"","salesCurrencyIsoCode":"UF","salesStartDate":"2022-03-08","indexSeriesBaseYear":"","indexSeries":"","percSalesAsRent":"","paymentCondition":"MP12","cebe":"0001201602","isSalesRelated":"false","isProRataMethod":"","type":"M101","condition":[{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","unitPrice":1.0,"validFrom":"2023-01-01","validTo":"9999-12-31","type":"AD10"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AM","unitPrice":5.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AM10"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AP","unitPrice":1.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AP10"}],"salesBasedRentAgreement":[{"from":0,"to":100000,"percent":6.0},{"from":100001,"to":0,"percent":8.0}],"termAdjust":[],"rentalObject":[{"isInfo":false,"id":"1200/1201/00443495","type":"IM"}],"partner":[{"id":"0023095730","type":"TR0600","validFrom":"2022-03-01","validTo":"9999-12-31"}],"subClause":[],"meas":[]}')
            .build();        
        insert objIntegrationStatus; 
        
        Contract a = new contract();
        a.AccountId = parentAcc.id;
        Insert a;
        Order b = new order();
        b.Contractid = a.id;
        b.AccountId= parentAcc.id;
        b.Status = 'Draft';
        b.EffectiveDate = Date.Today();
        b.MP_Local__c = store.id;
        insert b;
        a.MPCurrentOrder__c = b.id;
        update a;
        
        opportunity1.MPGetContract41API__c = objIntegrationStatus.id;
        opportunity1.contractid = a.id;
        update opportunity1;
            /**Fin IntegrationStatus*/
            
           

        /** PENDIENTES
		* 
		*/
    }
    
    @isTest
    static void testDefaultQuote() {
        Map<id,Opportunity> mapOpportunity = new Map<id,Opportunity>([select id from Opportunity]);
        DefaultQuote_cls.CreateDefaultQuote(new List<id>(mapOpportunity.keyset()));
    }
    @isTest
    static void createDefaultQuoteConditionModOpp() {
        List<Opportunity> lstOpp = [select id from Opportunity];
        List<MPStore__c> lstStr = [select id from MPStore__c];
        Quote quote1 = new Quote();
        quote1.Opportunityid = lstOpp[0].id;
        quote1.MPStore__c = lstStr[0].id;
        quote1.name = 'Test';
        insert quote1;
        list<id> lq = new list<id>();
        lq.add(quote1.id);
        ModificationNewQuote_inv.createQuoteConditionModOpp_InvMth(lq);        
    }
}