@isTest
public class AssyncFetchPostsTest {

    @isTest
    public static void testQueueable() {
        TestDataFactory.makeData();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        ID jobID = System.enqueueJob(new AssyncFetchPosts()); 
        Test.stopTest();

        List<Post__c> postList = [SELECT Id FROM Post__c]; 
        System.assertEquals(2, postList.size(), 'Expected 2 post record created from callout');
    }
}