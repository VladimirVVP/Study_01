public with sharing class RestService {
    private static final String DEFAULT_URL = '/services/data/v54.0/sobjects/';

    public static String fetchIdFromResponse(String body){
        ResponseWrapper wrapper = (ResponseWrapper) System.JSON.deserialize(body, ResponseWrapper.class);
        return wrapper.id;
    }

    // GET external records via named credetials
    public static String fetchExternalRecords(String endpoint) {
        HttpResponse response = executeCallout('GET', endpoint, null);
        System.debug('fetchRecord response: ' + response);
        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
        throw new AuraHandledException('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
    }

    // POST: /services/data/v54.0/sobjects/Post__c/
    // request body: {"Id__c" : 1000, "UserId__c":1000,"Title__c":"Test title", "Body__c":"This is a body"}
    public static String createRecord(String objectName, String body) {
        String endpoint = DEFAULT_URL + objectName + '/';
        HttpResponse response = executeCallout('POST', endpoint, body);
        System.debug('createRecord response: ' + response);
        if (response.getStatusCode() == 201) {
            return response.getBody();
        }
        throw new AuraHandledException('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
    }

    // GET: /services/data/v54.0/sobjects/Post__c 
    //   or /services/data/v54.0/sobjects/Post__c/recordId
    public static String fetchRecord(String objectName, Id recordId) {
        String endpoint = DEFAULT_URL + objectName + '/'; 
        if (recordId != null){
            endpoint = endpoint + recordId;
        }
        HttpResponse response = executeCallout('GET', endpoint, null);
        System.debug('fetchRecord response: ' + response);
        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
        throw new AuraHandledException('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
    }

    // PATCH: /services/data/v54.0/sobjects/Post__c/a067S000002K0JhQAK
    // request body: {"Id__c" : 1000, "UserId__c":1000,"Title__c":"Test title", "Body__c":"This is a body update"}
    public static String updateRecord(String objectName, Id recordId, String body) {
        String endpoint = DEFAULT_URL + objectName + '/' + recordId;
        HttpResponse response = executeCallout('PATCH', endpoint, body);
        System.debug('updateRecord response: ' + response);
        if (response.getStatusCode() == 204) {
            return response.getBody();
        }
        throw new AuraHandledException('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
    }

    // DELETE: /services/data/v54.0/sobjects/Post__c/a067S000002K0JhQAK
    public static String deleteRecord(String objectName, Id recordId) {
        String endpoint = DEFAULT_URL + objectName + '/' + recordId;
        HttpResponse response = executeCallout('DELETE', endpoint, null);
        System.debug('fetchRecord response: ' + response);
        if (response.getStatusCode() == 204) {
            return response.getBody();
        }
        throw new AuraHandledException('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
    }

    private static HttpResponse executeCallout(String method, String resourceName, String requestBody) {
        HttpRequest request = new HttpRequest();
        request.setMethod(method);    
        request.setEndpoint(getBaseUrl() + resourceName);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-PrettyPrint', '1');
        request.setHeader('Content-Type', 'application/json');
        if (String.isNotBlank(requestBody)) {
            request.setBody(requestBody);
        }
        System.debug(request);
        return new Http().send(request);
    }

    private static String getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    public class ResponseWrapper{
        public String id{get;set;}
        public Boolean success{get;set;}
        public String[] errors{get;set;}
    }
}