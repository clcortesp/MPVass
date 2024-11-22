public with sharing class SendRecordEventService {

    @InvocableMethod
    public static void sendRecords(List<FlowInput> flowInput) {

        List<Object> objectList = new List<Object>();
        String recordId;
        if (flowInput[0].objectName.equalsIgnoreCase('Account')) {
            recordId = flowInput[0].accountToSend[0].Id.toString();
            objectList.addAll(flowInput[0].accountToSend);
        } else if (flowInput[0].objectName.equalsIgnoreCase('Contact')) {
            recordId = flowInput[0].contactToSend[0].Id.toString();
            objectList.addAll(flowInput[0].contactToSend);
        } else if (flowInput[0].objectName.equalsIgnoreCase('Store')) {
            recordId = flowInput[0].storeToSend[0].Id.toString();
            objectList.addAll(flowInput[0].storeToSend);
        }
         
        // get object name for api path purposes
        String objectName = flowInput[0].objectName;
        String customMetadataName = 'MPEvents' + objectName;
        final String NAMED_CREDENTIAL = MPIntegrationSetting__mdt.getInstance(customMetadataName).MPNamedCredential__c;
        final String API_PATH = MPIntegrationSetting__mdt.getInstance(customMetadataName).MPApi_Path__c;
        final String API_PATH_2 = MPIntegrationSetting__mdt.getInstance(customMetadataName).MPApi_Path_2__c;
        final Integer TIME_OUT = (Integer) MPIntegrationSetting__mdt.getInstance(customMetadataName).MPTimeout__c;
        final Integer MAX_RETRIES = (Integer) MPIntegrationSetting__mdt.getInstance(customMetadataName).MPMaximumRetries__c;
        final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance(customMetadataName).Masterlabel;
        final String HTTP_METHOD_POST = 'POST';
        // request maps
        List<Map<String, Object>> messages = new List<Map<String, Object>>();
        Map<String, Object> messageData = new Map<String, Object>();                           
        Map<String, Object> message = new Map<String, Object>();
        Map<String, Object> jsonAttributes = new Map<String, Object>();       
        // request building 
        message.put('data', objectList.get(0));            
        jsonAttributes.put('EVENT_ID', UUID.randomUUID());
        jsonAttributes.put('EVENT_TYPE', flowInput[0].operationType);
        jsonAttributes.put('ENTITY_ID', flowInput[0].objectName);
        jsonAttributes.put('ENTITY_TYPE', flowInput[0].objectName);
        jsonAttributes.put('DATE_TIME', Datetime.now());
        jsonAttributes.put('VERSION', '1.0');
        jsonAttributes.put('COUNTRY', 'PE');
        jsonAttributes.put('COMMERCE', 'mallplaza');
        jsonAttributes.put('CHANNEL', 'salesforce');
        jsonAttributes.put('DOMAIN_ID', 'REMA');
        jsonAttributes.put('CAPABILITY', 'POMA');
        jsonAttributes.put('MIME_TYPE',  'application/json');
        message.put('attributes', jsonAttributes);        
        messages.add(message);
        messageData.put('messages', messages);
        String jsonBody = JSON.serialize(messageData);           

        if (objectList.size() == 1) {
            sendRecordsCallout(NAMED_CREDENTIAL, 
                                INTEGRATION_NAME, 
                                API_PATH, 
                                API_PATH_2, 
                                TIME_OUT, 
                                HTTP_METHOD_POST, 
                                MAX_RETRIES, 
                                jsonBody, 
                                recordId);
        }
    }

    @future(callout=true)
    public static void sendRecordsCallout(String NamedCredential,
                                            String integrationName, 
                                            String apipath, 
                                            String apipath2, 
                                            Integer timeOut,
                                            String httpMethod, 
                                            Integer maxRetries,
                                            String jsonBody, 
                                            String recordId
                                            ) {
        
        MPIntegrationStatus__c integrationLog = new MPIntegrationStatus__c();
        integrationLog.MPRequestDateTime__c = System.now();
        try {
            // request
            System.debug('REQUEST ---> ' + jsonBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:' + NamedCredential + apipath + apipath2);
            request.setBody(jsonBody);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod(httpMethod);
            request.setTimeout(timeOut);
            // response
            Http http = new Http();
            HTTPResponse response = http.send(request);
            System.debug('RESPONSE ---> ' + response.getBody());
            // set integration log
            integrationLog.MPIntegrationName__c = integrationName;
            integrationLog.MPRequest__c = jsonBody;
            integrationLog.MPResponse__c = response.getBody();
            integrationLog.MPHttpCode__c = response.getStatusCode();
            integrationLog.MPStatus__c = response.getStatusCode() == 200 ? 'Success' : 'Error'; 
            integrationLog.MPSalesforceException__c = response.getStatusCode() == 200 ? '' : response.getStatus();
            integrationLog.MPResponseDateTime__c = System.now();
            integrationLog.MPParentId__c = recordId;
            insert integrationLog;
        } catch (Exception e) {
            integrationLog.MPStatus__c = 'Error';
            integrationLog.MPSalesforceException__c = e.getMessage();
            integrationLog.MPResponseDateTime__c = System.now();
            System.debug('Error message: ' + e.getMessage());
            integrationLog.MPParentId__c = recordId;
            insert integrationLog;
        }        
    }

    public class FlowInput {
        @InvocableVariable
        public String operationType;

        @InvocableVariable
        public String objectName;

        public Object recordToSend;

        @InvocableVariable
        public List<Account> accountToSend;

        @InvocableVariable
        public List<Contact> contactToSend;

        @InvocableVariable
        public List<MPStore__c> storeToSend;
    }
}