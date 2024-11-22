/**
 * @description Clase de test para cumplir cobertura de las clases utilizadas en el consumo de la API de precios
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
@isTest
private class PricingAPITest {

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
   }

    @isTest
   static void testQuoteConditionUpdate() {

      Integer httpCode = 200;
      Decimal priceResponse = 0.24145688653950015;
      String responseData = '{"pricing": ' + String.valueOf(priceResponse) +',"message": [{"code": "X0002","description": "RentalObject no fue encontrado, calculo no considera pasillo"}]}';
      String quoteToTestName = 'quote1';
      String integrationName = 'MPPricingAPI';
      String inProgress = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
      
      Map<String, String> headerMap = new Map<String, String>();
      
      /** Obtener condición de cotizacion a actualizar */
      MPQuoteCondition__c mpqc = [SELECT Id FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName Limit 1];
      
      /** Crear log de integracion */
      MPIntegrationStatus__c newLog = Build.anMPIntegrationStatus()
           .withStatus(inProgress)
           .withParentId(mpqc.id)
           .withMPIntegrationName(integrationName)
           .build();
      insert newLog;

      Test.setMock(HttpCalloutMock.class, new HttpMock(responseData, httpCode, headerMap));
      PricingAPICallManager callManager = new PricingAPICallManager(mpqc,false,newLog);
                  
      Test.startTest();
      // Encolar y ejecutar el trabajo queueable
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();

      // Obtener registro actualizado
      MPQuoteCondition__c updatedMpqc = [SELECT Id,MPSuggestedValue__c FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName LIMIT 1];
      System.debug(updatedMpqc);

      Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
      Assert.areEqual(priceResponse, updatedMpqc.MPSuggestedValue__c, 'El precio sugerido debe coincidir con el valor de la respuesta.');
   }

   @isTest
   static void testHandleErrorResponseFromService() {

      Integer httpCode = 500;
      String quoteToTestName = 'quote1';
      Map<String, String> headerMap = new Map<String, String>();
      String responseData = '{"message": "500 - Server error"}';
      String integrationName = 'MPPricingAPI';
      String inProgress = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
            
      /** Obtener condición de cotizacion a actualizar */
      MPQuoteCondition__c mpqc = [SELECT Id FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName Limit 1];
      
      
      /** Crear log de integracion */
      MPIntegrationStatus__c newLog = Build.anMPIntegrationStatus()
      .withStatus(inProgress)
      .withParentId(mpqc.id)
      .withMPIntegrationName(integrationName)
      .build();
      insert newLog;
      
      Test.setMock(HttpCalloutMock.class, new HttpMock(responseData, httpCode, headerMap));
      PricingAPICallManager callManager = new PricingAPICallManager(mpqc,false,newLog);

      Test.startTest();
      // Encolar y ejecutar el trabajo queueable
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();

      // Obtener registro actualizado
      MPQuoteCondition__c updatedMpqc = [SELECT Id,MPSuggestedValue__c,MPPricingApiStatus__c  FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName LIMIT 1];
      System.debug(updatedMpqc);

      Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
      Assert.areEqual('Error', updatedMpqc.MPPricingApiStatus__c, 'El estado debe ser Error');
   }

   @isTest
   static void testHandleErrorResponseRetries() {
      Boolean retries = true;
      Integer httpCode = 500;
      String quoteToTestName = 'quote1';
      Map<String, String> headerMap = new Map<String, String>();
      String responseData = '{"message": "500 - Server error"}';
      String integrationName = 'MPPricingAPI';
      String inProgress = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
            
      /** Obtener condición de cotizacion a actualizar */
      MPQuoteCondition__c mpqc = [SELECT Id FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName Limit 1];
      
      /** Crear log de integracion */
      MPIntegrationStatus__c newLog = Build.anMPIntegrationStatus()
      .withStatus(inProgress)
      .withParentId(mpqc.id)
      .withMPIntegrationName(integrationName)
      .build();
      insert newLog;
      
      Test.setMock(HttpCalloutMock.class, new HttpMock(responseData, httpCode, headerMap));
      PricingAPICallManager callManager = new PricingAPICallManager(mpqc,retries,newLog);

      Test.startTest();
      // Encolar y ejecutar el trabajo queueable
      Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
      Test.stopTest();

      // Obtener registro actualizado
      MPQuoteCondition__c updatedMpqc = [SELECT Id,MPSuggestedValue__c,MPPricingApiStatus__c  FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName LIMIT 1];
      System.debug(updatedMpqc);

      Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
      Assert.areEqual('Error', updatedMpqc.MPPricingApiStatus__c, 'El estado debe ser Error');
   }

   // @isTest
   // static void testQuoteConditionValidateResponse() {
   //    /** Validar que no se debe procesar correctamente el llamado a la API si el precio sugerido es 0 */
   //    Integer httpCode = 200;
   //    Decimal priceResponse = 0;
   //    String responseData = '{"pricing": ' + String.valueOf(priceResponse) +',"message": [{"code": "X0002","description": "RentalObject no fue encontrado, calculo no considera pasillo"}]}';
   //    String quoteToTestName = 'quote1';
   //    String integrationName = 'MPPricingAPI';
   //    String inProgress = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
      
   //    Map<String, String> headerMap = new Map<String, String>();
      
   //    /** Obtener condición de cotizacion a actualizar */
   //    MPQuoteCondition__c mpqc = [SELECT Id FROM MPQuoteCondition__c WHERE MPQuote__r.Name =: quoteToTestName Limit 1];
      
   //    /** Crear log de integracion */
   //    MPIntegrationStatus__c newLog = Build.anMPIntegrationStatus()
   //         .withStatus(inProgress)
   //         .withParentId(mpqc.id)
   //         .withMPIntegrationName(integrationName)
   //         .build();
   //    insert newLog;

   //    Test.setMock(HttpCalloutMock.class, new HttpMock(responseData, httpCode, headerMap));
   //    PricingAPICallManager callManager = new PricingAPICallManager(mpqc,false,newLog);
                  
   //    Test.startTest();
   //    // Encolar y ejecutar el trabajo queueable
   //    Id jobId = System.enqueueJob(new CallManagerQueueable(callManager));
   //    Test.stopTest();

   //    // Obtener registro actualizado
   //    MPQuoteCondition__c updatedMpqc = [
   //       SELECT Id,MPSuggestedValue__c,MPIntegrationStatus__c, MPIntegrationStatus__r.MPSalesforceException__c, MPIntegrationStatus__r.MPStatus__c
   //       FROM MPQuoteCondition__c 
   //       WHERE MPQuote__r.Name =: quoteToTestName LIMIT 1];
   //    System.debug(updatedMpqc);
   //    System.debug(updatedMpqc.MPIntegrationStatus__r.MPSalesforceException__c);
   //    System.debug(updatedMpqc.MPIntegrationStatus__r.MPStatus__c);


   //    Assert.isNotNull(jobId, 'El Job ID no debería ser nulo después de encolar el trabajo.');
   //    Assert.isNotNull(updatedMpqc.MPIntegrationStatus__c, 'El lookup de Integration status no debe ser null.');
   //    Assert.isNull(updatedMpqc.MPSuggestedValue__c, 'El precio sugerido debe ser null');
   // }
}