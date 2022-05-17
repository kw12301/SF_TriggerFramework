/**
* @author Kevin Winn
* @date May 17, 2022
* @group Handlers
* @description after insert trigger handler for object 
*/
public with sharing class ErrorLogAfterInsertTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {
		process((List<ErrorLog__c>)tp.newList);
	}

	private void process(List<ErrorLog__c> newlist)	{
		System.debug(LoggingLevel.INFO,'ErrorLogAfterInsertTriggerHandler fired');
	}
}