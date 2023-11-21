trigger ContactTrigger on Contact (before insert, before update, after update, before delete) {
    if(RecursionHelper.shouldExecute()) {
        if(trigger.isInsert && trigger.isBefore){
            ContactTriggerHelper.handleBeforeInsert(trigger.new);
            RecursionHelper.reset();
        } else if(trigger.isUpdate && trigger.isBefore){
            ContactTriggerHelper.handleBeforeUpdate(trigger.new, trigger.oldMap);
            RecursionHelper.reset();
        } else if(trigger.isUpdate && trigger.isAfter){
            ContactTriggerHelper.handleAfterUpdate(trigger.new, trigger.oldMap);
            RecursionHelper.reset();
        } else if(trigger.isDelete && trigger.isBefore){
            ContactTriggerHelper.handleBeforeDelete(trigger.old);
            RecursionHelper.reset();
        }
    }
}