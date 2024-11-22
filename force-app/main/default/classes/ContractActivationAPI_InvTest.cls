/**
 * @description Clase de test para cumplir cobertura de la clase invocable 'ContractActivationAPI_Inv'
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
@isTest
public with sharing class ContractActivationAPI_InvTest {
    @testSetup
    static void setup(){
        /**Crear pricebook (Condicion de contrato) */
        Pricebook2 contractType = Build.anPricebook2()
        .withName('Contrato Comercial Perú')
        .withMPPaymentCondition('MP12')
        .withMPIsProRataMethod(true)
        .withMPExternalCode('P101')
        .withIsActive(true)
        .withCurrencyIsoCode('PEN')
        .build();
        insert contractType;
        /**Fin pricebook (Condicion de contrato) */

        /**Crear tipos de negocio */
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
        /**Fin tipos de negocio */

        /**Crear cuentas */
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
        .withMPExternalCode('1200')
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

        /**Crear Quote Condition */
        MPQuoteCondition__c quoteCondition1 = Build.anQuoteCondition()
        .withMPQuote(quote1)
        .withCurrencyIsoCode('PEN')
        .build();
        insert new List<MPQuoteCondition__c>{quoteCondition1};
        /**Fin Quote Quote Condition */

        /**Crear orden */
        Order testOrder = Build.anOrder()
            .withAccount(parentAcc)
        // .withContract(testContract)
            .withStore(store)
            .withEffectiveDate(System.today())
            .withStatus('Draft')
            .withCurrencyIsoCode('PEN')
            .build();
        insert new List<Order>{testOrder};
        /**Fin orden */

        /** Crear Product2 */
        Product2 conditionClass = Build.anProduct2()
            .withIsActive(true)
            .withMPExternalCode('AP30')
            .withName('AP Fijo')
            .build();
        insert new List<Product2>{conditionClass};
        /** Fin Crear Product2 */

        /** Crear CalculationRule */
        MPCalculationRule__c calculationRule = Build.anCalculationRule()
            .withExternalCode('MPAD')
            .withName('MPAD')
            .build();
        insert new List<MPCalculationRule__c>{calculationRule};
        /** Fin Crear CalculationRule */

        /** Crear MPOrderCondition__c */
        MPOrderCondition__c orderCondition = Build.anOrderCondition()
            .withOrder(testOrder)
            .withConditionClass(conditionClass)
            .withCalculationRule(calculationRule)
            // .withAdjustmentType(adjustmentType)
            .withStartDate(System.today())
            .withEndDate(System.today().addMonths(12))
            .withVolumenValue(100)
            .withValue(200)
            .withFinalVolumen(150)
            .withIntialVolumen(50)
            .build();
        insert new List<MPOrderCondition__c>{orderCondition};
        /** Fin Crear MPOrderCondition__c */

        /** Crear contrato */
        Contract testContract = Build.aContract()
            .withName('Test Class Contract')
            .withAccount(parentAcc)
            .withMall(mallAccount)
            .withMarca(brandAccount)
            .withCurrencyIsoCode('PEN')
            .withStartDate(System.today())
            .withEndDate(12) // 12 meses de duración
            .withStatus('Draft')
            .withOpp(opportunity1)
            .withOrder(testOrder)
            .withExternalCode('35083')
            .withRentalStartDate(System.now().date())
            .withProbableOpeningDate(System.now().date())
            .build();
        insert new List<Contract>{testContract};
        /** Fin Crear contrato */

        // actualizar la orden vigente con el contrato
        testOrder.ContractId = testContract.Id;
        update testOrder;
    }
    @isTest
    static void testInvocable(){
        String inProgress = Utilities_cls.getInprogressValue('MPIntegrationStatus__c', 'MPStatus__c');
        String contractExtCode = '35083';

        /** Obtener contrato a actualizar */
        Contract contract = [SELECT Id,name,ContractNumber,account.name FROM Contract WHERE MPExternalCode__c =: contractExtCode LIMIT 1];
        List<Contract> contractList = new List<Contract>{contract};
        
        Test.startTest();
        ContractActivationAPI_Inv.callContractActivationAPI(contractList);
        Test.stopTest();

        // Obtener registro actualizado
        Contract updatedContract = [SELECT Id, MPContractActivationStatus__c, MPContractActivationStatus__r.MPStatus__c FROM Contract WHERE MPExternalCode__c =: contractExtCode LIMIT 1];

        Assert.isNotNull(updatedContract.MPContractActivationStatus__c, 'El lookup de Integration status no debe ser null.');
        Assert.areEqual(inProgress, updatedContract.MPContractActivationStatus__r.MPStatus__c, 'El estado debe ser en proceso');
    }
}