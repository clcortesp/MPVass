/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 01-11-2024
 * @last modified by  : Juan Felipe Muriel
**/
@isTest
private class InvoicePaidAPITest {

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

        /** Crear MPAdjustment__c */
        // MPAdjustment__c adjustmentType = Build.anStrategicAdjustment()
        //     .withPeriod('2')
        //     .withValue(10)
        //     .withExternalCode('MPAD2')
        //     .build();
        // insert new List<MPCalculationRule__c>{calculationRule};
        /** Fin Crear MPAdjustment__c */

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

        /** Crear Contrato */
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
        /**FIN Crear Contrato */

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

        /** Crear FTC */
        MPContractTerminationRecords__c testFTC = Build.anMPContractTerminationRecords()
        .withOrder(testOrderTermination)
        .withStatus('Requested')
        .build();
        insert testFTC;
        /** FIN FTC */

        // Asociar FTC principal a la orden
        testOrderTermination.MPFTCPrincipal__c = testFTC.Id;
        update testOrderTermination;

        /** Crear Factura */
        MPInvoice__c invoiceTest = Build.anMPInvoice()
        .withOrder(testOrderTermination)
        .withInvoiceNumber('invoice_001')
        .build();
        insert invoiceTest;
        /** FIN crear FTC */
    }


    @isTest
    static void testSuccess(){
        String contractId = '35083';
        String invoiceNumber = 'invoice_001';
        String companyCode = '';
        Integer httpCode = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);
        String logStatus = Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c');
        String url = '/invoices/paid';

        // Crear el objeto RestRequest para simular la solicitud entrante
        RestRequest req = new RestRequest();
        req.requestUri = url;
        req.httpMethod = 'POST';
        String requestBody = '{"invoiceNumber":"' + invoiceNumber + '","contractId":"' + contractId + '","companyCode":"","validFrom":"2024-10-30T19:40:45.947Z","paymentDate":"2024-10-30","percentagePayment":12,"relatedDocs":[{"docId":"docId_01","docType":"docType_01","description":"descripcion_test"}]}';
        req.requestBody = Blob.valueOf(requestBody);
        // Crear el objeto RestResponse para capturar la respuesta
        RestResponse res = new RestResponse();
        // Asignar el request y response simulados al contexto REST
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        // Llamar al método de la API
        InvoicePaidAPI.updateInvoice();
        Test.stopTest();

        MPInvoice__c invoice = [
            SELECT Id, MPInvoicePaidAPIStatus__r.MPStatus__c, MPInvoicePaidAPIStatus__c
            FROM   MPInvoice__c 
            WHERE  Orden__r.Contract.MPExternalCode__c =: contractId
            LIMIT  1
        ];

        // Verificar la respuesta
        Assert.isNotNull(invoice.MPInvoicePaidAPIStatus__c, 'La factura no tiene asociado ningun registro de log');
        Assert.areEqual(logStatus,invoice.MPInvoicePaidAPIStatus__r.MPStatus__c,'El log de integración debe ser exitoso');
        Assert.areEqual(httpCode, RestContext.response.statusCode, 'El código de respuesta debería ser ' + httpCode);
    }

    @isTest
    static void testContractNotFound(){
        String contractId = '111111111'; // codigo que no existe en base de datos para generar error
        String invoiceNumber = 'invoice_001';
        String companyCode = '';
        Integer httpCode = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);
        String logStatus = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        String url = '/invoices/paid';

        // Crear el objeto RestRequest para simular la solicitud entrante
        RestRequest req = new RestRequest();
        req.requestUri = url;
        req.httpMethod = 'POST';
        String requestBody = '{"invoiceNumber":"' + invoiceNumber + '","contractId":"' + contractId + '","companyCode":"","validFrom":"2024-10-30T19:40:45.947Z","paymentDate":"2024-10-30","percentagePayment":12,"relatedDocs":[{"docId":"docId_01","docType":"docType_01","description":"descripcion_test"}]}';
        req.requestBody = Blob.valueOf(requestBody);
        // Crear el objeto RestResponse para capturar la respuesta
        RestResponse res = new RestResponse();
        // Asignar el request y response simulados al contexto REST
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        // Llamar al método de la API
        InvoicePaidAPI.updateInvoice();
        Test.stopTest();

        // Verificar la respuesta
        MPIntegrationStatus__c log = [
            SELECT Id,MPStatus__c,MPResponse__c
            FROM   MPIntegrationStatus__c
            ORDER  BY CreatedDate desc
            LIMIT  1
        ];

        // Verificar la respuesta
        Assert.areEqual(logStatus,log.MPStatus__c,'El log de integración debe ser Fallido');
        Assert.areEqual(httpCode, RestContext.response.statusCode, 'El código de respuesta debería ser ' + httpCode);
    }

    @isTest
    static void testContractNotProvided(){
        String contractId = ''; // codigo que no existe en base de datos para generar error
        String invoiceNumber = 'invoice_001';
        String companyCode = '';
        Integer httpCode = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);
        String logStatus = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        String url = '/invoices/paid';

        // Crear el objeto RestRequest para simular la solicitud entrante
        RestRequest req = new RestRequest();
        req.requestUri = url;
        req.httpMethod = 'POST';
        String requestBody = '{"invoiceNumber":"' + invoiceNumber + '","contractId":"' + contractId + '","companyCode":"","validFrom":"2024-10-30T19:40:45.947Z","paymentDate":"2024-10-30","percentagePayment":12,"relatedDocs":[{"docId":"docId_01","docType":"docType_01","description":"descripcion_test"}]}';
        req.requestBody = Blob.valueOf(requestBody);
        // Crear el objeto RestResponse para capturar la respuesta
        RestResponse res = new RestResponse();
        // Asignar el request y response simulados al contexto REST
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        // Llamar al método de la API
        InvoicePaidAPI.updateInvoice();
        Test.stopTest();

        // Verificar la respuesta
        MPIntegrationStatus__c log = [
            SELECT Id,MPStatus__c,MPResponse__c
            FROM   MPIntegrationStatus__c
            ORDER  BY CreatedDate desc
            LIMIT  1
        ];

        // Verificar la respuesta
        Assert.areEqual(logStatus,log.MPStatus__c,'El log de integración debe ser Fallido');
        Assert.areEqual(httpCode, RestContext.response.statusCode, 'El código de respuesta debería ser ' + httpCode);
    }

    @isTest
    static void testInvoiceNotProvided(){
        String contractId = '35083';
        String invoiceNumber = ''; // enviando atributo vacio, para provocar error
        String companyCode = '';
        Integer httpCode = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);
        String logStatus = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        String url = '/invoices/paid';

        // Crear el objeto RestRequest para simular la solicitud entrante
        RestRequest req = new RestRequest();
        req.requestUri = url;
        req.httpMethod = 'POST';
        String requestBody = '{"invoiceNumber":"' + invoiceNumber + '","contractId":"' + contractId + '","companyCode":"","validFrom":"2024-10-30T19:40:45.947Z","paymentDate":"2024-10-30","percentagePayment":12,"relatedDocs":[{"docId":"docId_01","docType":"docType_01","description":"descripcion_test"}]}';
        req.requestBody = Blob.valueOf(requestBody);
        // Crear el objeto RestResponse para capturar la respuesta
        RestResponse res = new RestResponse();
        // Asignar el request y response simulados al contexto REST
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        // Llamar al método de la API
        InvoicePaidAPI.updateInvoice();
        Test.stopTest();

        // Verificar la respuesta
        MPIntegrationStatus__c log = [
            SELECT Id,MPStatus__c,MPResponse__c
            FROM   MPIntegrationStatus__c
            ORDER  BY CreatedDate desc
            LIMIT  1
        ];

        // Verificar la respuesta
        Assert.areEqual(logStatus,log.MPStatus__c,'El log de integración debe ser Fallido');
        Assert.areEqual(httpCode, RestContext.response.statusCode, 'El código de respuesta debería ser ' + httpCode);
    }

    @isTest
    static void testMappingError(){
        /** Vamos a pasar un 'requestBody' invalido */
        String contractId = '35083';
        String invoiceNumber = ''; // enviando atributo vacio, para provocar error
        String companyCode = '';
        Integer httpCode = Integer.valueOf(Label.MPInvoicePaidHTTPSuccessCode);
        String logStatus = Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c');
        String url = '/invoices/paid';

        // Crear el objeto RestRequest para simular la solicitud entrante
        RestRequest req = new RestRequest();
        req.requestUri = url;
        req.httpMethod = 'POST';
        String requestBody = '{invalid  Json}';
        req.requestBody = Blob.valueOf(requestBody);
        // Crear el objeto RestResponse para capturar la respuesta
        RestResponse res = new RestResponse();
        // Asignar el request y response simulados al contexto REST
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        // Llamar al método de la API
        InvoicePaidAPI.updateInvoice();
        Test.stopTest();

        // Verificar la respuesta
        MPIntegrationStatus__c log = [
            SELECT Id,MPStatus__c,MPResponse__c
            FROM   MPIntegrationStatus__c
            ORDER  BY CreatedDate desc
            LIMIT  1
        ];

        // Verificar la respuesta
        Assert.areEqual(logStatus,log.MPStatus__c,'El log de integración debe ser Fallido');
        Assert.areEqual(httpCode, RestContext.response.statusCode, 'El código de respuesta debería ser ' + httpCode);
    }
}