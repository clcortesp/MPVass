/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 30-10-2024
 * @last modified by  : Juan Felipe Muriel
**/
@IsTest
public class GetContractAPITest {
    
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
   
    /**Crear Oportunidad Renovacion*/
      Opportunity opportunity2 = Build.anOppRenov()
         .withName('opportunityRENOV')
         .withStageName('Exploración')
         .withAccount(parentAcc)
         .withMPBrand(brandAccount)
         .withMPMall(mallAccount)
         .withCloseDate((System.now().date()))
         .withCurrencyIsoCode('PEN')
         .withContract(testContract)
         .build();
      insert new List<Opportunity>{opportunity2};
      /**Fin Oportunidad */
         
      MPIntegrationSetting__mdt integrationSetting = [SELECT DeveloperName, MPNamedCredential__c, MPApi_Path__c, MPTimeout__c, MPMaximumRetries__c, MPSecondsBetweenRetries__c FROM MPIntegrationSetting__mdt WHERE DeveloperName = 'MPGETContract' LIMIT 1];

      
      // Crear integración status
      MPIntegrationStatus__c integrationStatus = Build.anMPIntegrationStatus()
         .withParentId(opportunity2.id)
         .withStatus('InProgress')
         .withMPIntegrationName(integrationSetting.DeveloperName)
         .build();
      insert new List<MPIntegrationStatus__c>{integrationStatus};    

   }
    
   @isTest
	static void testExecuteSuccess() {
        
      Integer httpCode = 200;
      
      Order objOrder = [SELECT Id FROM Order];
      Contract objContract = [SELECT Id,name,ContractNumber,account.name FROM Contract WHERE MPCurrentOrder__c =: objOrder.Id LIMIT 1];
      Opportunity opp = [SELECT Id, ContractId FROM Opportunity WHERE ContractId =: objContract.id];
      String strOppId = String.valueOf(Opportunity.Id);
      MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];
      system.debug('integrationStatus::::::' + integrationStatus);
      String responseBody = '{"id":"0000000035083","companyCode":"1200","name":"ALDO_XI_PTR","isMainContract":"false","currencyIsoCode":"UF","startDate":"2022-03-08","endDate":"2027-03-07","sector":"SR421","note":"","offerId":"SF0002","adjustmentRule":"","salesCurrencyIsoCode":"UF","salesStartDate":"2022-03-08","indexSeriesBaseYear":"","indexSeries":"","percSalesAsRent":"","paymentCondition":"MP12","cebe":"0001201602","isSalesRelated":"false","isProRataMethod":"","type":"M101","condition":[{"calcRule":"MPAD","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","unitPrice":1.0,"validFrom":"2023-01-01","validTo":"9999-12-31","type":"AD10"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AM","unitPrice":5.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AM10"},{"calcRule":"MP05","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AP","unitPrice":1.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AP10"}],"salesBasedRentAgreement":[{"from":0,"to":100000,"percent":6.0},{"from":100001,"to":0,"percent":8.0}],"termAdjust":[],"rentalObject":[{"isInfo":false,"id":"1200/1201/00443495","type":"IM"}],"partner":[{"id":"0023095730","type":"TR0600","validFrom":"2022-03-01","validTo":"9999-12-31"}],"subClause":[],"meas":[]}';   
      //   String responseBody = '[{"id":"0000000035083","companyCode":"1200","name":"ALDO_XI_PTR","isMainContract":"false","currencyIsoCode":"UF","startDate":"2022-03-08","endDate":"2027-03-07","sector":"SR421","note":"","offerId":"SF0002","adjustmentRule":"","salesCurrencyIsoCode":"UF","salesStartDate":"2022-03-08","indexSeriesBaseYear":"","indexSeries":"","percSalesAsRent":"","paymentCondition":"MP12","cebe":"0001201602","isSalesRelated":"false","isProRataMethod":"","type":"M101","condition":[{"calcRule":"MPAD","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","unitPrice":1.0,"validFrom":"2023-01-01","validTo":"9999-12-31","type":"AD10"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AM","unitPrice":5.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AM10"},{"calcRule":"MP05","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AP","unitPrice":1.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AP10"}],"salesBasedRentAgreement":[{"from":0,"to":100000,"percent":6.0},{"from":100001,"to":0,"percent":8.0}],"termAdjust":[],"rentalObject":[{"isInfo":false,"id":"1200/1201/00443495","type":"IM"}],"partner":[{"id":"0023095730","type":"TR0600","validFrom":"2022-03-01","validTo":"9999-12-31"}],"subClause":[],"meas":[]}]';   
      Map<String, String> headerMap = new Map<String, String>();
      Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
      GetContractAPICallManager callManager = new GetContractAPICallManager(opp, false, integrationStatus);
         
      Test.startTest();
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();
      
      Opportunity updatedOpportunity = [SELECT Id, ContractId,MPContractEndDate__c FROM Opportunity WHERE ContractId =: objContract.id];
      System.debug(updatedOpportunity);
      
      Date expectedEndDate = Date.valueOf('2027-03-07 00:00:00');
      
      System.assertEquals(expectedEndDate, updatedOpportunity.MPContractEndDate__c, 'El campo MPContractEndDate__c no se actualizó correctamente.');
      
   }

   @isTest
	static void testExecuteSuccessOrder() {
        
      Decimal AM15Value = 10.00;
      String endDate = '2027-03-07';
      Integer httpCode = 200;

      Order objOrder = [SELECT Id FROM Order LIMIT 1];
      MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];
      String responseBody = '{"id":"0000000035083","companyCode":"1200","name":"ALDO_XI_PTR","isMainContract":"false","currencyIsoCode":"UF","startDate":"2022-03-08","endDate":"2027-03-07","lastInvoiceDate":"2025-06-30","sector":"SR421","note":"","offerId":"SF0002","adjustmentRule":"","salesCurrencyIsoCode":"UF","salesStartDate":"2022-03-08","indexSeriesBaseYear":"","indexSeries":"","percSalesAsRent":"","paymentCondition":"MP12","cebe":"0001201602","isSalesRelated":"false","isProRataMethod":"","type":"M101","condition":[{"calcRule":"MP18","currencyIsoCode":"PEN","distributionRule":"MP01","externalPurpose":"AMIN","unitPrice":' + AM15Value + ',"validFrom":"2025-06-05","validTo":"2025-06-05","type":"AM15"},{"calcRule":"MPAD","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AMD","unitPrice":1.0,"validFrom":"2023-01-01","validTo":"9999-12-31","type":"AD10"},{"calcRule":"MP02","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AM","unitPrice":5.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AM10"},{"calcRule":"MP05","currencyIsoCode":"UF","distributionRule":"MP01","externalPurpose":"AP","unitPrice":1.0,"validFrom":"2022-12-01","validTo":"9999-12-31","type":"AP10"}],"salesBasedRentAgreement":[{"from":0,"to":100000,"percent":6.0},{"from":100001,"to":0,"percent":8.0}],"termAdjust":[],"rentalObject":[{"isInfo":false,"id":"1200/1201/00443495","type":"IM"}],"partner":[{"id":"0023095730","type":"TR0600","validFrom":"2022-03-01","validTo":"9999-12-31"}],"subClause":[],"meas":[]}';   
      Map<String, String> headerMap = new Map<String, String>();
      Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
      GetContractAPICallManager callManager = new GetContractAPICallManager(objOrder, false, integrationStatus);
         
      Test.startTest();
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();
      
      Order updatedOrder = [SELECT Id,MPContractAM__c,MPContractEndDate__c,MPLastInvoiceDate__c FROM Order WHERE Id =: objOrder.id];
      Date expectedEndDate = Date.valueOf(endDate);

      Assert.areEqual(expectedEndDate, updatedOrder.MPContractEndDate__c, 'Order.MPContractEndDate__c field was not updated'); 
      Assert.areEqual(AM15Value, updatedOrder.MPContractAM__c, 'Order.MPContractAM__c field was not updated'); 
      Assert.isNotNull(updatedOrder.MPLastInvoiceDate__c, 'Order.MPLastInvoiceDate__c must not be empty');
   }
    
   @isTest
   static void testExecuteError() {
      
      Integer httpCode = 400;
      
      Order objOrder = [SELECT Id FROM Order];
      Contract objContract = [SELECT Id,name,ContractNumber,account.name FROM Contract WHERE MPCurrentOrder__c =: objOrder.Id LIMIT 1];
      Opportunity opp = [SELECT Id, ContractId FROM Opportunity WHERE ContractId =: objContract.id];
      String strOppId = String.valueOf(Opportunity.Id);
      MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];
      system.debug('integrationStatus::::::' + integrationStatus);        
      
      String responseBody = '{"name": "parameters invalid",  "message": "Query value invalid."}';   
      Map<String, String> headerMap = new Map<String, String>(); 

      Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
      GetContractAPICallManager callManager = new GetContractAPICallManager(opp, true, integrationStatus);
         
      Test.startTest();
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();
                  
      Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
   }

   @isTest
   static void testExecuteErrorOrder() {
      
      Integer httpCode = 400;
      String responseBody = '{"name": "parameters invalid",  "message": "Query value invalid."}';   
      Map<String, String> headerMap = new Map<String, String>(); 
      
      Order objOrder = [SELECT Id FROM Order LIMIT 1];
      MPIntegrationStatus__c integrationStatus = [SELECT Id,MPParentId__c FROM MPIntegrationStatus__c LIMIT 1];

      Test.setMock(HttpCalloutMock.class, new HttpMock(responseBody, httpCode, headerMap));
      GetContractAPICallManager callManager = new GetContractAPICallManager(objOrder, true, integrationStatus);
         
      Test.startTest();
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();
                  
      Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
   }
    
   @isTest
   static void testInvokeFromFlowOpp() {
      
      Order objOrder = [SELECT Id FROM Order];
      Contract objContract = [SELECT Id,name,ContractNumber,account.name FROM Contract WHERE MPCurrentOrder__c =: objOrder.Id LIMIT 1];
      Id idTest = [SELECT Id, ContractId FROM Opportunity WHERE ContractId =: objContract.id LIMIT 1].Id;
      List<Id> lstOppsId = new List<Id>{idTest};
      List<List<Id>> OportunityListOfList = new List<List<id>>{lstOppsId};

      Test.startTest();
      GetContractAPI_Inv.invokeGetContractAPI(OportunityListOfList);
      Test.stopTest();

      // Verificar que se creó el registro de MPIntegrationStatus__c
      MPIntegrationStatus__c integrationStatus = [SELECT Id FROM MPIntegrationStatus__c WHERE CreatedDate = TODAY LIMIT 1];
      System.assertNotEquals(null, integrationStatus, 'El registro de MPIntegrationStatus__c debe ser creado.');

      // Verificar que se encoló un trabajo Queueable
      List<AsyncApexJob> jobs = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE JobType = 'Queueable' AND CreatedDate = TODAY];
      System.assert(!jobs.isEmpty(), 'Debería haberse encolado un trabajo Queueable.');
      System.assertEquals('Completed', jobs[0].Status, 'El trabajo Queueable debería haberse completado correctamente.');
   }

   @isTest
   static void testInvokeFromFlowOrder() {
      
      Id idTest = [SELECT Id FROM Order LIMIT 1].Id;
      List<Id> orderIdList = new List<Id>{idTest};
      List<List<Id>> orderListOfList = new List<List<id>>{orderIdList};

      Test.startTest();
      GetContractAPI_Inv.invokeGetContractAPI(orderListOfList);
      Test.stopTest();

      // Validate if the MPIntegrationStatus__c record has been created
      MPIntegrationStatus__c integrationStatus = [SELECT Id FROM MPIntegrationStatus__c WHERE CreatedDate = TODAY LIMIT 1];
      System.assertNotEquals(null, integrationStatus, 'The MPIntegrationStatus__c record must be created.');
   }
}