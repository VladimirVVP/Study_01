public class AssyncFetchPosts implements Queueable, Database.AllowsCallouts {
    // to run queue;
    // ID jobID = System.enqueueJob(new AssyncFetchPosts()); 
    public void execute(QueueableContext context) {
        try{
            String endpoint = 'callout:Typicode/posts';
            String responseBody = RestService.fetchExternalRecords(endpoint);
            createRecords(responseBody);
        } catch (Exception e){
            System.debug('The status code returned was not expected: ' + e.getMessage());
        }
    }
    
    private static void createRecords(String responseBody){
        List<Post__c> postToUpsertList = new List<Post__c>();
    	List<Post> responsePosts = (List<Post>)JSON.deserialize(responseBody, List<Post>.class);
        Map<Integer, Post__c> idToPostMap = new Map<Integer, Post__c>();
        Set<Integer> postIds = new Set<Integer>();
        for (Post resPost: responsePosts){
            postIds.add(resPost.id);
        }
        
        List<Post__c> postList = [SELECT Id__c, UserId__c, Title__c, Body__c FROM Post__c WHERE Id__c IN :postIds]; 
        for(Post__c post: postList){
            idToPostMap.put((Integer)post.Id__c, post);
        }
        
        for (Post resPost: responsePosts){
            Post__c post;
            if (idToPostMap.containsKey(resPost.id)) {
               post = idToPostMap.get(resPost.id);
            } else {
                post = new Post__c();
                post.Id__c = resPost.id;
            }
            post.UserId__c = resPost.userId;
            post.Title__c = resPost.title;
            post.Body__c = resPost.body;

            postToUpsertList.add(post);
        }
        
        if (!postToUpsertList.isEmpty()){
            upsert postToUpsertList;
        }
    }
    
    public class Post{
        public Integer userId{get;set;}
        public Integer id{get;set;}
        public String title{get;set;}
        public String body{get;set;}
    }
}