/**
 * @description       : 
 * @author            : Miller Mora
 * @group             : 
 * @last modified on  : 21-10-2024
 * @last modified by  : Miller Mora
**/
@IsTest
public class ContractRescissionAPITest {

    @TestSetup
    static void setupTestData() { 
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

        // Crear orden y relacionarla con el contrato
        Order testOrder = Build.anOrder()
            .withAccount(parentAcc)
           // .withContract(testContract)
            .withStore(store)
            .withEffectiveDate(System.today())
            .withStatus('Draft')
            .withCurrencyIsoCode('PEN')
            .build();
        insert testOrder;

       
        // Crear objetos relacionados a la orden
        Product2 conditionClass = new Product2(Name='AP Fijo', MPExternalCode__c = 'AP30');
        insert conditionClass;

        MPCalculationRule__c calculationRule = new MPCalculationRule__c(Name='Arriendo Diciembre', MPExternalCode__c = 'MPAD');
        insert calculationRule;

        MPAdjustment__c adjustmentType = new MPAdjustment__c(Name='Adjustment Type A', MPPeriod__c = '2', MPValue__c = 10, MPExternalCode__c = 'MPAD2');
        insert adjustmentType;

        // Crear Order Condition y relacionarla con la orden
        MPOrderCondition__c orderCondition = Build.anOrderCondition()
            .withOrder(testOrder)
            .withConditionClass(conditionClass)
            .withCalculationRule(calculationRule)
            .withAdjustmentType(adjustmentType)
            .withStartDate(System.today())
            .withEndDate(System.today().addMonths(12))
            .withVolumenValue(100)
            .withValue(200)
            .withFinalVolumen(150)
            .withIntialVolumen(50)
            .build();
        insert orderCondition;
        
             // Crear contrato
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
            .build();
        insert testContract;
        
         // Actualizar el contrato con la orden vigente
        testOrder.ContractId = testContract.Id;
        update testOrder;
        
        // Crear orden de terminacion y relacionarla con el contrato
        Order testOrderTermination = Build.anMPOrderTermination()
            .withAccount(parentAcc)
            .withContract(testContract)
            .withStore(store)
            .withEffectiveDate(System.today())
            .withStatus('Draft')
            .withStage('Activación de Término')
            .withCurrencyIsoCode('PEN')
            .build();
        insert testOrderTermination;
        
        testOrderTermination.MPExitDate__c = System.today().addDays(15);
        update testOrderTermination;
            
        MPIntegrationSetting__mdt integrationSetting = [SELECT DeveloperName, MPNamedCredential__c, MPApi_Path__c, MPTimeout__c, MPMaximumRetries__c, MPSecondsBetweenRetries__c FROM MPIntegrationSetting__mdt WHERE DeveloperName = 'MPContractRescission' LIMIT 1];
 
         // Crear integración status
        MPIntegrationStatus__c integrationStatus = Build.anMPIntegrationStatus()
            .withParentId(testOrderTermination.id)
            .withStatus('InProgress')
            .withMPIntegrationName(integrationSetting.DeveloperName)
            .build();
        insert new List<MPIntegrationStatus__c>{integrationStatus};    

    }
    
    @isTest
	static void testExecuteSuccess() {
        
        Integer httpCode = 200;
        
        Order objOrder = [SELECT Id FROM Order Where RecordType.DeveloperName = 'MPTermination'];
        MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];
        system.debug('integrationStatus::::::' + integrationStatus);
        
        String responseBody = '{ "closeDate": "2024-01-25","doCalculation": true,"doContractBlocking": true,"requester": {"fullName": "Bruno Rodrigues","email": "bruno.rodrigues@mallplaza.com"}}';
        
        Map<String, String> headerMap = new Map<String, String>();
        Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
        ContractRescissionAPICallManager callManager = new ContractRescissionAPICallManager(objOrder, false, integrationStatus);
            
        Test.startTest();
        	Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
        Test.stopTest();
        
        MPIntegrationStatus__c newIntegrationStatus = [SELECT Id, MPParentId__c, MPStatus__c, MPHttpCode__c FROM MPIntegrationStatus__c Where MPParentId__c =: objOrder.id LIMIT 1];
        System.debug(newIntegrationStatus);
        
        System.assertEquals(httpCode, newIntegrationStatus.MPHttpCode__c, 'La integración 4.5 no fue exitosa.');
       
    }
    
     @isTest
    static void testExecuteError() {
        
        Integer httpCode = 400;
        
        Order objOrder = [SELECT Id FROM Order Where RecordType.DeveloperName = 'MPTermination'];
        MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];
        system.debug('integrationStatus::::::' + integrationStatus);     
        
        String responseBody = '{"name": "parameters invalid",  "message": "Query value invalid."}';   
        Map<String, String> headerMap = new Map<String, String>(); 

        Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
        ContractRescissionAPICallManager callManager = new ContractRescissionAPICallManager(objOrder, true, integrationStatus);
            
        Test.startTest();
        	Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
        Test.stopTest();
                    
        Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
    }
    
     @isTest
    static void testInvokeFromFlow() {
        
        List<Order> lstOrders = [SELECT Id FROM Order Where RecordType.DeveloperName = 'MPTermination'];
        
        Test.startTest();
       	 ContractRescissionAPI_Inv.invokeFromFlowContractRescissionAPI(lstOrders);
        Test.stopTest();

        // Verificar que se creó el registro de MPIntegrationStatus__c
        MPIntegrationStatus__c integrationStatus = [SELECT Id FROM MPIntegrationStatus__c WHERE CreatedDate = TODAY LIMIT 1];
        System.assertNotEquals(null, integrationStatus, 'El registro de MPIntegrationStatus__c debe ser creado.');

        // Verificar que se encoló un trabajo Queueable
        List<AsyncApexJob> jobs = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE JobType = 'Queueable' AND CreatedDate = TODAY];
        System.assert(!jobs.isEmpty(), 'Debería haberse encolado un trabajo Queueable.');
        System.assertEquals('Completed', jobs[0].Status, 'El trabajo Queueable debería haberse completado correctamente.');
    }

}