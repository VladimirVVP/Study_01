public class DailyExamCalculationBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    // '0 minute, 8 hour, * day, * month, * dayweek ' - daily start at 8 o`clock
    // System.Schedule('calculate number of Exams', '0 8 * * *  ? ',new DailyExamCalculationBatch());
    
    public void execute(SchedulableContext sc) {
        DailyExamCalculationBatch dailyExamCalculationBatch = new DailyExamCalculationBatch(); 
        Database.executeBatch(dailyExamCalculationBatch, 200);
    }

    Map<Id, Integer> studentIdToExamsNumberMap = new Map<Id, Integer>();
    List<Student__c> studentsToUpdateList = new List<Student__c>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Fetch all Active Exam records
        String query = 'SELECT Id, Active__c, Discipline__r.Student__r.Id, Discipline__r.Student__r.Number_of_related_exams__c FROM Exam__c WHERE Active__c = TRUE';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Exam__c> scope) {
        // Calculate relatedNumbers and put result to the studentIdToExamsNumberMap for each Student
        for(Exam__c exam : scope){
            Id studentId = exam.Discipline__r.Student__r.Id;

            if (studentIdToExamsNumberMap.get(studentId) == null) {
                studentIdToExamsNumberMap.put(studentId, 1);
            } else {
                Integer relatedNumbers = studentIdToExamsNumberMap.get(studentId);
                studentIdToExamsNumberMap.put(studentId, relatedNumbers++);
            }
        }
    }
  
    public void finish(Database.BatchableContext bc){
        for(Id studentId : studentIdToExamsNumberMap.keyset()){
            Student__c student = new Student__c(Id = studentId, Number_of_related_exams__c = studentIdToExamsNumberMap.get(studentId));
            studentsToUpdateList.add(student);
        }

        if(!studentsToUpdateList.isEmpty()){
            update studentsToUpdateList;
        }
    }  
}
