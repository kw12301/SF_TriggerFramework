/**
* @author Kevin Winn
* @date 12/31/2019
* @group Error Log
* @description after delete trigger handler for object 
*/
public with sharing class ErrorLogAfterDeleteTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp) 
	{
		process((List<ErrorLog__c>)tp.oldList);
	}

	private void process(List<ErrorLog__c> oldList)
	{
		System.debug(LoggingLevel.INFO,'ErrorLogAfterDeleteTriggerHandler fired');
	}
}