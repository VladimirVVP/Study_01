@isTest
private class InboundRestServiceTest {
    @isTest
    static void testHttpGet() {
        TestDataFactory.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/1000';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.getPosts();
        Test.stopTest(); 

        System.assertEquals(200, res.statusCode, 'Record was not fetch');
    }

    @isTest
    static void testHttpWrongGet() {
        TestDataFactory.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/null';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.getPosts();
        Test.stopTest(); 

        System.assertEquals(200, res.statusCode, 'Record was not fetch');
    }

    @isTest
    static void testHttpPost() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.createPost(10, 10, 'Test Title', 'Test Body');
        Test.stopTest(); 

        System.assertEquals(200, res.statusCode, 'Record was not created');
    }

    @isTest
    static void testWrongHttpPost() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.createPost(null, 10, 'Test Title', 'Test Body');
        Test.stopTest(); 

        System.assertEquals(400, res.statusCode, 'Record was not created');
    }

    @isTest
    static void testHttpPatch() {
        TestDataFactory.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/1000';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.updatePost(1000, 10, 'Test Title', 'Test Body');
        Test.stopTest(); 

        System.assertEquals(200, res.statusCode, 'Record was not fetch');
    }

    @isTest
    static void testHttpWrongPatch() {
        TestDataFactory.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/null';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.updatePost(null, 10, 'Test Title', 'Test Body');
        Test.stopTest(); 

        System.assertEquals(500, res.statusCode, 'Record was not fetch');
    }

    @isTest
    static void testHttpDelete() {
        TestDataFactory.makeData();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/1000';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.deletePostByIdInParam();
        Test.stopTest(); 

        System.assertEquals(204, res.statusCode, 'Record was not fetch');
    }

    @isTest
    static void testHttpWrongDelete() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/posts/null';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        InboundRestService.deletePostByIdInParam();
        Test.stopTest(); 

        System.assertEquals(500, res.statusCode, 'Record was not delete');
    }
}