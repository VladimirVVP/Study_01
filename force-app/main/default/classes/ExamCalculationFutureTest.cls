@isTest
private class ExamCalculationFutureTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.makeData();
    }

    @isTest
    private static void testRecalculateExams() {
        // Actual test
        Test.startTest();
        ExamCalculationFuture.recalculateExams();
        Test.stopTest();

        // Asserts
        Student__c student = [SELECT Id, Number_of_related_exams__c FROM Student__c LIMIT 1]; 
        System.assertEquals(1, student.Number_of_related_exams__c, 'Expected 1 Exam in calc');
    }

}