/**
* @description Test Class for the contrller of the PDF Generator (TermsPDF_ctrl)
* @group Mallplaza (MP) proyect
* @author Marco Andres Guevara
* @since 25-08-2024 - Creation
*/
@isTest
public class ManageTerminationItems_test {
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
        /**Crear Objeto de contraco */
        Contract objContract = Build.aContract()
            .withName('Test Contract')
            .withAccount(parentAcc)
            .withMall(mallAccount)
            .withMarca(brandAccount)
        	.build();
        insert objContract;
		/**Fin contraco*/
        /**Crear Termination Order */
        Order objOrder = Build.anMPOrderTermination()
            .withAccount(parentAcc)
            .withContract(objContract)
            .withStore(store)
            .withEffectiveDate(Date.Today())
            .withStatus('Draft')
            .withStage('Activación de Término')
            .withSpecialConditionAmount(200)
            .build();
        insert objOrder;
        /**Fin Termination Order*/
        /**Crear FTC */
        MPContractTerminationRecords__c FTC = Build.anMPContractTerminationRecords()
            .withOrder(objOrder)
            .withStatus('Received')
            .build();
        insert FTC;
        objOrder.MPFTCPrincipal__c = FTC.id;
        update objOrder;
        /**Fin FTC*/
        /**Crear FTC Item */
        MPTerminationRecord__c FTCItem = Build.anMPTerminationRecord()
            .withFTC(FTC)
            .withCategory('Emitida')
            .withItemCode('1248565')
            .withStatus('Approved')
            .withItemValue(200)
            .build();
        MPTerminationRecord__c FTCItem1 = Build.anMPTerminationRecord()
            .withFTC(FTC)
            .withCategory('Garantia')
            .withItemCode('1248565')
            .withStatus('Approved')
            .withItemValue(200)
            .build();
        MPTerminationRecord__c FTCItem2 = Build.anMPTerminationRecord()
            .withFTC(FTC)
            .withCategory('PorEmitir')
            .withSubCategory('DEUDAOPE')
            .withItemCode('1248565')
            .withStatus('Approved')
            .withItemValue(200)
            .build();
        MPTerminationRecord__c FTCItem3 = Build.anMPTerminationRecord()
            .withFTC(FTC)
            .withCategory('PorEmitir')
            .withSubCategory('DEUDACOM')
            .withItemCode('1248565')
            .withStatus('Approved')
            .withItemValue(200)
            .build();
        MPTerminationRecord__c FTCItem4 = Build.anMPTerminationRecord()
            .withFTC(FTC)
            .withCategory('PorEmitir')
            .withSubCategory('AJUSCANT')
            .withItemCode('1248565')
            .withStatus('Approved')
            .withItemValue(200)
            .build();
        insert new List<MPTerminationRecord__c>{FTCItem,FTCItem1,FTCItem2,FTCItem3,FTCItem4};        
        /**Fin FTC Item*/
    }

    @isTest
    static void getTerminationRecord() {
        List<order> lstorder = [select id,MPFTCPrincipal__c from order];
        ManageTerminationItems_ctrl.getTerminationRecord(lstorder[0].id);        
    }

    @isTest
    static void saveInformationClass() {
        List<order> lstorder = [select id,MPFTCPrincipal__c from order];
        List<MPTerminationRecord__c> lstTerminationRecord = [
            SELECT id,MPDocumentNumber__c,MPDescription__c,MPCategory__c,
            MPSubcategory__c,MPItemValue__c,MPStatus__c,FTC__r.MPRejectionReason__c 
            FROM MPTerminationRecord__c 
            WHERE FTC__c =: lstorder[0].MPFTCPrincipal__c];
        ManageTerminationItems_ctrl.saveInformationClass(lstTerminationRecord,'test',lstorder[0].id); 
    }

}