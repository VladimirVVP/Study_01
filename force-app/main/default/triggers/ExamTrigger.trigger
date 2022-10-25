trigger ExamTrigger on Exam__c (after insert, after undelete, after update, before delete) {
    if (Trigger.isAfter){
        if(Trigger.isInsert) {
            ExamTriggerHandler.updateParentStudent(Trigger.newMap, null);
        } 
        if(Trigger.isUndelete) {
            ExamTriggerHandler.updateParentStudent(Trigger.newMap, null);
        }        
        if(Trigger.isUpdate) {
            ExamTriggerHandler.updateParentStudent(Trigger.newMap, Trigger.oldMap);
        }
    } 
    if (Trigger.isBefore) { 
        if(Trigger.isDelete){
            ExamTriggerHandler.updateParentStudent(null, Trigger.oldMap);
        }
    }
}