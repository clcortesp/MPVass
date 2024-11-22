@isTest
public class SendRecordEventTest {
    @TestSetup
    static void setup() {

        Id societyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MPSociety').getRecordTypeId();

        Account testAccount = new Account();
        testAccount.RecordTypeId = societyRecordTypeId;
        testAccount.Name = 'Society Account';
        testAccount.CurrencyIsoCode = 'PEN';
        testAccount.MPIdentificationNumber__c = '12345123451234512345';
        insert testAccount;        
    }

    @isTest
    static void sendRecordsCallout() {

        // get account fields to query
        List<String> fieldsList = Utilities_cls.getAllFields('Account');
        String fieldsToQuery = Utilities_cls.getQueryFields(fieldsList);
        // query a random account
        List<Account> testAccountList = Database.query('SELECT ' + fieldsToQuery + ' FROM Account');
        // create flow output variables
        List<SendRecordEventService.FlowInput> flowInputList = new List<SendRecordEventService.FlowInput>();
        SendRecordEventService.FlowInput flowInput = new SendRecordEventService.FlowInput();
        Account testAccount = testAccountList.get(0);
        flowInput.accountToSend = testAccountList;
        flowInput.objectName = 'Account';
        flowInput.operationType = 'CREATE';
        flowInputList.add(flowInput);

        Test.setMock(HttpCalloutMock.class, new SendRecordEventHttpMock());
        Test.startTest();
        SendRecordEventService.sendRecords(flowInputList);
        Test.stopTest();

        MPIntegrationStatus__c integrationLog = [SELECT Id, 
                                                        MPStatus__c, 
                                                        MPParentId__c
                                                    FROM MPIntegrationStatus__c
                                                    WHERE MPStatus__c = 'SUCCESS'
                                                    AND MPIntegrationName__c = 'Integracion Eventos Cuentas'
                                                    AND MPParentId__c = :testAccount.Id LIMIT 1];
        Assert.areEqual(testAccount.Id, integrationLog.MPParentId__c);
                                                    
    }
}