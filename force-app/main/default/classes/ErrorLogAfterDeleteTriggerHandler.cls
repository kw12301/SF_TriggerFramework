/**
* @author Kevin Winn
* @date May 17, 2022
* @group Trigger Handlers
* @description after delete trigger handler for object 
*/
public with sharing class ErrorLogAfterDeleteTriggerHandler extends TriggerHandlerBase{
	
	public override void mainEntry(TriggerParameters tp) {
		process((List<ErrorLog__c>)tp.oldList);
	}

	private void process(List<ErrorLog__c> oldList)	{
		System.debug(LoggingLevel.INFO,'ErrorLogAfterDeleteTriggerHandler fired');
	}
}