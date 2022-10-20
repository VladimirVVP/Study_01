public with sharing class ExamTriggerHandler {
    public static void updateParentStudent(Map<Id, Exam__c> examMap){
        Map<Id, Integer> studentIdToExamsNumberMap = new Map<Id, Integer>();
        List<Student__c> studentsToUpdateList = new List<Student__c>();

        //Fetch Exam__c records width needed fields by Id
        List<Exam__c> examList = [
            SELECT Id, Discipline__r.Student__r.Id, Discipline__r.Student__r.Number_of_related_exams__c 
            FROM Exam__c 
            WHERE Id IN : examMap.keySet()];

        // Calculate relatedNumbers and put result to the studentIdToExamsNumberMap for each Student
        for(Exam__c exam : examList){
            Id studentId = exam.Discipline__r.Student__r.Id;
            Integer relatedNumbers = (Integer)exam.Discipline__r.Student__r.Number_of_related_exams__c;
            if (relatedNumbers == null) {
                relatedNumbers = 0;
            }
            if (Trigger.isInsert || Trigger.isUndelete) {
                relatedNumbers ++;
            }
            if (Trigger.isDelete) {
                relatedNumbers --;
            }
            if (relatedNumbers < 0) {
                relatedNumbers = 0;
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
            upsert studentsToUpdateList;
        }
    }
}