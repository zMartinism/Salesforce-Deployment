trigger SalesOrderTrigger on Sales_Order__c (before insert, before update) {
    
    // Trigger handler method
    SalesOrderTriggerHandler.handleTrigger(Trigger.new, Trigger.oldMap);
}