@isTest
public class TestDataFactory {
    public static makeData(){
        insert new Post__c(Id__c = 1000, UserId__c = 1000, Body__c = 'Test', Title__c = 'Test' );

        // Test data setup
        Student__c s = new Student__c(Name = 'Test');
        insert s;

        Discipline_participation__c dp = new Discipline_participation__c(Student__c = s.Id, Name = 'Test Discipline');
        insert dp;

        Exam__c e = new Exam__c(Name = 'Test Exam', Rating__c= 10, Active__c = TRUE, Discipline__c = dp.Id);
        insert e;

        insert new Teacher__c(Name = 'Test Teacher', Position__c = 'Laborant');
    }
}
