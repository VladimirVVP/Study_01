@isTest
private class ReviewTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.makeData();
    }

    @isTest
    private static void testRatingValidationLess() {
        // Actual test
        Test.startTest();
        insert new Review__c(Teacher__c = t.Id, Rating__c = 0);
        Test.stopTest();

        Review__c review = [SELECT Id, Rating__c FROM Review__c LIMIT 1];
        // Asserts
        System.assertEquals(1, review.Rating__c, 'Expecting rating was fixed from 0 to 1');
    }

    @isTest
    private static void testRatingValidationGreates() {
        // Actual test
        Test.startTest();
        insert new Review__c(Teacher__c = t.Id, Rating__c = 9);
        Test.stopTest();

        Review__c review = [SELECT Id, Rating__c FROM Review__c LIMIT 1];
        // Asserts
        System.assertEquals(5, review.Rating__c, 'Expecting rating was fixed from 9 to 5');
    }
}