@isTest
public class DailyExamCalculationBatchTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.makeData();
    }
    
    @isTest
    public static void testTestCase() {
        // Actual test
        Test.startTest();
        String jobId = System.Schedule('calculate number of Exams', '0 0 0 30 12 ? 2022',new DailyExamCalculationBatch());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        System.assertEquals(0, ct.TimesTriggered); 
        System.assertEquals('2022-12-30 00:00:00', String.valueOf(ct.NextFireTime));   

        Test.stopTest();

        // Asserts
    }

}