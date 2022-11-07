@isTest
private class ExamTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.makeData();
    }

    @isTest
    private static void testInsertExam() {
        // Actual test
        Test.startTest();
        insert new Exam__c(Name = 'Test Insert Exam', Rating__c= 10, Active__c = true, Discipline__c = dp.Id);
        Test.stopTest();

        // Asserts
        Student__c student = [SELECT Id, Number_of_related_exams__c FROM Student__c LIMIT 1]; 
        System.assertEquals(2, student.Number_of_related_exams__c, 'Expected 1 Exam in calc');
    }

    @isTest
    private static void testUpdateExam(){
        insert new Exam__c(Name = 'Test Exam2', Rating__c= 5, Active__c = true, Discipline__c = dp.Id);

        // Actual test
        Test.startTest();
        Exam__c exam = [SELECT Id, Name, Active__c FROM Exam__c WHERE Name = 'Test Exam'];
        exam.Active__c = false;
        update exam;
        Test.stopTest();

        // Asserts
        Student__c student = [SELECT Id, Number_of_related_exams__c FROM Student__c LIMIT 1]; 
        System.assertEquals(1, student.Number_of_related_exams__c, 'Expected 0 Exam in calc');
    }

    @isTest
    private static void testDeleteExam(){

        // Actual test
        Test.startTest();
        Exam__c exam = [SELECT Id, Name, Active__c FROM Exam__c WHERE Name = 'Test Exam'];
        delete exam;
        Test.stopTest();

        // Asserts
        Student__c student = [SELECT Id, Number_of_related_exams__c FROM Student__c LIMIT 1]; 
        System.assertEquals(0, student.Number_of_related_exams__c, 'Expected 0 Exam in calc');
    }

}