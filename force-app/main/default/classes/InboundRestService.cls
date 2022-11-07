@RestResource (urlMapping = '/posts/*')
global class InboundRestService {

    //GET URL: /services/apexrest/posts/1000
    // RESPONSE BODY: [{"attributes":{"type":"Post__c","url":"/services/data/v56.0/sobjects/Post__c/a067S000002K0JhQAK"},"Id":"a067S000002K0JhQAK"}]
    @HttpGet
    global static void getPosts(){

        RestRequest req = RestContext.request;
        System.debug(req.params);
        System.debug(req.requestBody);
        System.debug(req.requestURI);

        //get record Id from RequestURI 
        String recId = req.requestURI.substring(req.requestURI.lastindexOf('/') + 1);
        System.debug(recId);

        RestResponse res = RestContext.response;
        try{
            String query = 'SELECT Id, Id__c, UserId__c, Title__c, Body__c FROM Post__c';

            // Add condition to query if exist
            if (String.isNotBlank(recId) && recId != 'posts'){
                query += ' WHERE Id__c = ' + recId;
            }
            List<Post__c> postList = Database.query(query);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(postList));
        } catch (Exception e){
            res.statusCode = 412;
            res.responseBody = Blob.valueOf(e.getMessage());
        }
    }

    //POST URL: /services/apexrest/posts/
    // REQUEST BODY: {"id" : 1000, "userId":1000,"title":"Test title", "body":"This is a body"}
    // RESPONSE BODY: {"postRec":{"attributes":{"type":"Post__c","url":"/services/data/v56.0/sobjects/Post__c/a067S000002K0MOQA0"},"Id__c":1000,"UserId__c":1000,"Title__c":"Test title","Body__c":"This is a body","Id":"a067S000002K0MOQA0"},"message":"Successfully Inserted"}
    @HttpPost
    global static void createPost(Integer id, Integer userId, String title, String body){
        RestRequest req = RestContext.request;
        System.debug(req.params);
        System.debug(req.requestBody);

        RestResponse res = RestContext.response;
        try{    
            Response response;
            Post__c post = new Post__c();
            post.Id__c = id;
            post.UserId__c = userId;
            post.Title__c = title;
            post.Body__c = body;
            
            Database.SaveResult sr = Database.insert(post, false);
            if (sr.isSuccess()) {
                res.statusCode = 200;
                response = new Response('Successfully Inserted', post);
            } else {
                String errorMsg = '';
                for (Database.Error err: sr.getErrors()) {
                    errorMsg += err.getStatusCode() + ': ' + err.getMessage() + '; ';
                }
                res.statusCode = 400;
                response = new Response(errorMsg, null);
            }
            res.responseBody = Blob.valueOf(JSON.serialize(response));

        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response(e.getMessage(), null)));
        }
    }

    //PATCH URL: /services/apexrest/posts/
    // REQUEST BODY: {"id" : 1000, "userId":10,"title":"Test title", "body":"This is a body"}
    // RESPONSE BODY: {"postRec":{"attributes":{"type":"Post__c","url":"/services/data/v56.0/sobjects/Post__c/a067S000002K0JhQAK"},"Id":"a067S000002K0JhQAK","UserId__c":10,"Title__c":"Test title","Body__c":"This is a body"},"message":"Successfully Updated"}
    @HttpPatch
    global static void updatePost(Integer id, Integer userId, String title, String body){
        RestRequest req = RestContext.request;
        System.debug(req.params);
        System.debug(req.requestBody);

        RestResponse res = RestContext.response;
        try{    
            Response response;
            Post__c post = [SELECT Id, UserId__c, Title__c, Body__c FROM Post__c WHERE id__c = :id LIMIT 1];
            if (post != null){
                post.UserId__c = userId;
                post.Title__c = title;
                post.Body__c = body;
                
                Database.SaveResult sr = Database.update(post, false);
                if (sr.isSuccess()) {
                    res.statusCode = 200;
                    response = new Response('Successfully Updated', post);
                } else {
                    String errorMsg = '';
                    for (Database.Error err: sr.getErrors()) {
                        errorMsg += err.getStatusCode() + ': ' + err.getMessage() + '; ';
                    }
                    res.statusCode = 400;
                    response = new Response(errorMsg, null);
                }
                res.responseBody = Blob.valueOf(JSON.serialize(response));
            } else {
                throw new MyException('post with current Id not found');
            }

        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response(e.getMessage(), null)));
        }
    }

    //DELETE URL: /services/apexrest/posts/1000
    // RESPONSE BODY: 
    @HttpDelete
    global static void deletePostByIdInParam(){
        
        RestRequest req = RestContext.request;
        System.debug(req.params);
        System.debug(req.requestBody);
        System.debug(req.requestURI);

        //get record Id from RequestURI 
        String recId = req.requestURI.substring(req.requestURI.lastindexOf('/') + 1);
        System.debug(recId);

        RestResponse res = RestContext.response;
        try{
            Response response;
            // Add condition to query if exist
            if (String.isNotBlank(recId) && recId != 'posts'){
                List<Post__c> postList = [SELECT Id FROM Post__c WHERE Id__c = : Integer.valueOf(recId)];
                
                List <Response> lstResponse = new List <Response> ();

                if (!postList.isEmpty()){
                    for (Database.DeleteResult dr: Database.delete(postList, false)) {
                        String errorMsg = '';

                        if (dr.isSuccess()) {
                            res.statusCode = 204;
                            lstResponse.add(new Response('Successfully Deleted Post with Id: ' + dr.getId(), null));
                        } else {
                            for (Database.Error err: dr.getErrors()) {
                                errorMsg = err.getStatusCode() + ': ' + err.getMessage();
                            }
                            res.statusCode = 400;
                            lstResponse.add(new Response(errorMsg, null));
                        }
                    }
                }
            }
            res.responseBody = Blob.valueOf(JSON.serialize(response));
        } catch (Exception e){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response(e.getMessage(), null)));
        }
    }

    public class Response {
        public String message;
        public Post__c postRec;

        public Response(String message, Post__c postRec) {
            this.message = message;
            this.postRec = postRec;
        }
    }
    public class MyException extends Exception {}
}