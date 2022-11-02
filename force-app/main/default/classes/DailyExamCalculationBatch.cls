public class DailyExamCalculationBatch implements Database.Batchable<sObject>, Schedulable {

    // '0 minute, 8 hour, * day, * month, * dayweek ' - daily start at 8 o`clock
    // System.Schedule('calculate number of Exams', '0 8 * * *  ? ',new DailyExamCalculationBatch());
    
    public void execute(SchedulableContext sc) {
        DailyExamCalculationBatch dailyExamCalculationBatch = new DailyExamCalculationBatch(); 
        Database.executeBatch(dailyExamCalculationBatch, 200);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Student__c FROM Discipline_participation__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Discipline_participation__c> scope) {
        Set<Id> StudentIdSet = new Set<Id>();
        
        for (Discipline_participation__c participation: scope){
            StudentIdSet.add(participation.Student__c);
        }
        
        List<Student__c> studentsToUpdateList = new List<Student__c>();
        List<AggregateResult> groupedResults = [
            SELECT Discipline__r.Student__c student, COUNT(Id) exams 
            FROM Exam__c WHERE Active__c = TRUE AND Discipline__r.Student__c IN :StudentIdSet 
            GROUP BY Discipline__r.Student__c];
        
        for (AggregateResult ar : groupedResults) {
            Id studentId = (Id)ar.get('student');
            Integer count = (Integer)ar.get('exams');
            Student__c student = new Student__c(Id = studentId, Number_of_related_exams__c = count);
            studentsToUpdateList.add(student);
        }

        if(!studentsToUpdateList.isEmpty()){
            update studentsToUpdateList;
        }
    }
  
    public void finish(Database.BatchableContext bc){}  
}