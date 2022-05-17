/**
* @author Kevin Winn
* @date 12/31/2019
* @group Error Log
* @description after update trigger handler for object 
*/
public with sharing class ErrorLogAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp) 
	{
		process((List<ErrorLog__c>)tp.newList, (Map<Id,ErrorLog__c>)tp.oldMap);
	}

	private void process(List<ErrorLog__c> newList, Map<Id,ErrorLog__c> oldMap)
	{
		System.debug(LoggingLevel.INFO,'ErrorLogAfterUpdateTriggerHandler fired');
	}
}