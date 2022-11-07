public class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('callout:Typicode/posts', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"body":"quia et suscipit","id":1,"title":"sunt aut facere repe","userId":1}, {"body":"quia et suscipit","id":2,"title":"sunt aut facere repe","userId":2}]');
        res.setStatusCode(200);
        return res;
    }
}