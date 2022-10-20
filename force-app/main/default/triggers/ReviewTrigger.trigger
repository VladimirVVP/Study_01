trigger ReviewTrigger on Review__c (before insert, before update) {
    if (Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            ReviewTriggerHandler.ratingValidation(Trigger.new);
        }
    }
}