public without sharing class ExamCalculationFuture {

    @future
    public static void recalculateExams() {   
        Set<Id> StudentIdSet = new Set<Id>();
        
        for (Discipline_participation__c participation: [SELECT Student__c FROM Discipline_participation__c]){
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
}