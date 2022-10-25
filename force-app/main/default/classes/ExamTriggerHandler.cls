public with sharing class ExamTriggerHandler {
    public static void updateParentStudent(Map<Id, Exam__c> newMap, Map<Id, Exam__c> oldMap){
        Map<Id, Integer> studentIdToExamsNumberMap = new Map<Id, Integer>();
        List<Student__c> studentsToUpdateList = new List<Student__c>();

        Set<Id> examIdSet = new Set<Id>();
        if (Trigger.isDelete) {
            examIdSet = oldMap.keySet();
        } else {
            examIdSet = newMap.keySet();
        }

        //Fetch Exam__c records width needed fields by Id and Active__c = TRUE
        List<Exam__c> examList = [
            SELECT Id, Active__c, Discipline__r.Student__r.Id, Discipline__r.Student__r.Number_of_related_exams__c 
            FROM Exam__c 
            WHERE Id IN : examIdSet];

        // Calculate relatedNumbers and put result to the studentIdToExamsNumberMap for each Student
        for(Exam__c exam : examList){
            Id studentId = exam.Discipline__r.Student__r.Id;
            Integer relatedNumbers = (Integer)exam.Discipline__r.Student__r.Number_of_related_exams__c;
            
            // Needs only for Update check condition
            if(exam.Active__c == true){
                if (Trigger.isInsert || Trigger.isUndelete || Trigger.IsUpdate && oldMap.get(exam.Id).Active__c == false) {
                    relatedNumbers ++;
                } else if (Trigger.isDelete) {
                    relatedNumbers --;
                } 
            } else if (Trigger.IsUpdate && oldMap.get(exam.Id).Active__c == true) {
                relatedNumbers --;
            }

            if (relatedNumbers < 0) {
                throw new MyException('Something went wrong, relatedNumbers = ' + relatedNumbers);
            }
            studentIdToExamsNumberMap.put(studentId, relatedNumbers);
        }

        // Check Number of related exams and if value was changed add it to List for update
        for(Exam__c exam : examList){
            Id studentId = exam.Discipline__r.Student__r.Id;
            Integer newValue = studentIdToExamsNumberMap.get(studentId);
            Integer oldValue = (Integer)exam.Discipline__r.Student__r.Number_of_related_exams__c;
            if(oldValue != newValue){
                Student__c student = new Student__c(Id = studentId, Number_of_related_exams__c = newValue);
                studentsToUpdateList.add(student);
            }
        }

        if(!studentsToUpdateList.isEmpty()){
            update studentsToUpdateList;
        }
    }
    public class MyException extends Exception {}
}