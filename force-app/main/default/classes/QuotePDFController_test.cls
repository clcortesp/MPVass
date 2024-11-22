/**
* @description Test Class for the contrller of the PDF Generator (QuotePDFController_cls)
* @group Mallplaza (MP) proyect
* @author Marco Andres Guevara
* @since 25-08-2024 - Creation
*/
@isTest
private class QuotePDFController_test {
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
        Product2 objProductAM16 = Build.anProduct2()
            .withName('AM16')
            .withProductCode('AM16')
            .withMPExternalCode('AM16')
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
        Product2 objProductO050 = Build.anProduct2()
            .withName('O050')
            .withProductCode('O050')
            .withMPExternalCode('O050')
            .withIsActive(true)
            .build();
        Product2 objProductGAR0 = Build.anProduct2()
            .withName('GAR0')
            .withProductCode('GAR0')
            .withMPExternalCode('GAR0')
            .withIsActive(true)
            .build();
        insert new List<Product2>{objProductAM15,objProductAM16,objProductAM17,objProductAM19,objProductAP10,objProductAD10,objProductCI15,objProductG010,objProductG030,objProductFP20,objProductO050,objProductGAR0};
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
            .build();
        MPContractCondition__c objContractConditionAM16 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductAM16.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
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
            .build();
        MPContractCondition__c objContractConditionO050 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductO050.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        MPContractCondition__c objContractConditionGAR0 = Build.anContractCondition()
            .withUsabilityStatus('Use')
            .withAdjustmentType('MPStrategicAdjustment')
            .withSuggestedValue(10)
            .withConditionClass(objProductGAR0.id)
            .withContractType(contractType.id)
            .withSuggestedCalculationRule(objCalculationRule.id)
            .withSuggestedAdjustment(objAdjustment.id)
            .withGetValueFromPricing(false)
            .withIsDefault(true)
            .build();
        insert new List<MPContractCondition__c>{objContractConditionAM15,objContractConditionAM16,objContractConditionAM17,objContractConditionAM19,objContractConditionAP10,objContractConditionAD10,objContractConditionCI15,objContractConditionG010,objContractConditionG030,objContractConditionFP20,objContractConditionO050,objContractConditionGAR0};
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
            
        /**Crear Quote */
        Quote quote1 = Build.anQuote()
            .withName('quote1')
            .withOpportunity(opportunity1)
            .withMPStore(store)
            .withStatus('Draft')
            .withCurrencyIsoCode('PEN')
            .build();
        insert new List<Quote>{quote1};
        /**Fin Quote */
        /**Crear Scale */
        List<MPQuoteCondition__c> objQuoteCondition = [select id,MPConditionClassCode__c  from MPQuoteCondition__c WHERE MPConditionClassCode__c = 'AM15' or MPConditionClassCode__c = 'AP10' order by MPConditionClassCode__c desc];
        
        MPScale__c objScale1 = Build.anTimeScale()                        
            .withValue(10)            
            .withQuoteCondition(objQuoteCondition[0].id)
            .withEndDate(Date.today()+30)
            .withStartDate(Date.today())
            .build();
        
        MPScale__c objScale2 = Build.anTimeScale()            
            .withValue(15)            
            .withQuoteCondition(objQuoteCondition[0].id)
            .withEndDate(Date.today()+100)
            .withStartDate(Date.today()+31)
            .build();
        MPScale__c objScale3 = Build.anTimeScale()            
            .withValue(10)            
            .withQuoteCondition(objQuoteCondition[1].id)
            .withEndDate(Date.today()+30)
            .withStartDate(Date.today())
            .build();
        
        MPScale__c objScale4 = Build.anTimeScale()
            .withValue(15)            
            .withQuoteCondition(objQuoteCondition[1].id)
            .withEndDate(Date.today()+100)
            .withStartDate(Date.today()+31)
            .build();
        
        insert new List<MPScale__c>{objScale1,objScale2,objScale3,objScale4};
            
        MPScale__c objScale5 = Build.anVolumeScale()
            .withFinalVolume(1000)
            .withInitialVolume(2000)
            .withValue(15)
            .withEscala(objScale4.id)
            .build();
        insert objScale5;
        /**Fin Scale */
    }

    @isTest
    static void testQuotePDFController() {
        List<Quote> objQuote = [select id from Quote];

        Test.StartTest();         
        ApexPages.currentPage().getParameters().put('id', String.valueOf(objQuote[0].Id));        
        QuotePDFController_cls  QuotePDFControllercls = new QuotePDFController_cls();                       
        Test.StopTest();
    }

    @isTest
    static void testQuotePDFController2() {
        List<Quote> objQuote = [select id from Quote];
        List<MPScale__C> a = [select id from MPScale__C];
        MPQuoteCondition__c mpqcG010 = [SELECT Id, MPNegotiatedValue__c FROM MPQuoteCondition__c WHERE MPConditionClassCode__c = 'G010' LIMIT 1];
        mpqcG010.MPNegotiatedValue__c = 10;
        update mpqcG010;
        delete a ;
        
        Test.StartTest();         
        ApexPages.currentPage().getParameters().put('id', String.valueOf(objQuote[0].Id));        
        QuotePDFController_cls  QuotePDFControllercls = new QuotePDFController_cls();                       
        Test.StopTest();
    } 
}