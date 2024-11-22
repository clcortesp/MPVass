@isTest(seeAllData = false)
public with sharing class SendRecordEventHttpMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody('{' + 
                        '"messageIds": [' +
                                        '"12344430405892655"' +
                                        ']' +
                        '}');
        response.setStatusCode(200);
        return response;
    }
}