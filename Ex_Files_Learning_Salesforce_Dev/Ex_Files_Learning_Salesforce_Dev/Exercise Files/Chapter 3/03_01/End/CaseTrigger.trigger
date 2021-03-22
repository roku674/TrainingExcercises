trigger CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    CaseTriggerHandler handler = new CaseTriggerHandler(trigger.isExecuting, trigger.size);
    // 
    // Before Insert - new record(s) being created 
    // 
    if(trigger.isInsert && trigger.isBefore) {
        handler.OnBeforeInsert(trigger.new);
    //
    // After Insert - new record(s) being created 
    } else if(trigger.isInsert && trigger.isAfter) {
        handler.OnAfterInsert(trigger.newMap);
    // 
    // Before Update - existing record(s) being saved
    //
    } else if(trigger.isUpdate && trigger.isBefore) {
        handler.OnBeforeUpdate(trigger.oldMap, trigger.newMap);
    //
    // After Update - existing record(s) being saved
    //
    } else if(trigger.isUpdate && trigger.isAfter) {
        handler.OnAfterUpdate(trigger.oldMap, trigger.newMap);
    //
    // Before Delete - existing record(s) being deleted
    //
    } else if(trigger.isDelete && trigger.isBefore) {
        handler.OnBeforeDelete(trigger.oldMap);
    //
    // After Delete - existing record(s) being deleted
    //
    } else if(trigger.isDelete && trigger.isAfter) {
        handler.OnAfterDelete(trigger.oldMap);
    //
    // After UnDelete - existing record(s) being undeleted
    //
    } else if(trigger.isUnDelete) {
        handler.OnUndelete(trigger.new);
    }
}