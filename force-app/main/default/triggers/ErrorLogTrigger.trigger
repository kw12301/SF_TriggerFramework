trigger ErrorLogTrigger on ErrorLog__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	// This is the only line of code that is required.
	TriggerFactory.createTriggerDispatcher(ErrorLog__c.sObjectType);
}