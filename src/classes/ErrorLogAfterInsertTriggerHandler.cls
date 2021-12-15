/**
* @author Kevin Winn
* @date 12/31/2019
* @group Error Log
* @description after insert trigger handler for object 
*/
public with sharing class ErrorLogAfterInsertTriggerHandler extends TriggerHandlerBase
{

	public override void mainEntry(TriggerParameters tp) 
	{
		process((List<ErrorLog__c>)tp.newList);
	}

	private void process(List<ErrorLog__c> newlist)
	{
		System.debug(LoggingLevel.INFO,'ErrorLogAfterInsertTriggerHandler fired');
	}
}