trigger ExamTrigger on Exam__c (after insert, before delete, after undelete) {
    if (Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            ExamTriggerHandler.updateParentStudent(Trigger.newMap);
        }
    } 
    if (Trigger.isBefore && Trigger.isDelete){
        ExamTriggerHandler.updateParentStudent(Trigger.oldMap);
    }
}