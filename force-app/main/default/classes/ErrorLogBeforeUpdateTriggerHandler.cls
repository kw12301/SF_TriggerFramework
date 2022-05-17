/**
* @author Kevin Winn
* @date 12/31/2019
* @group Error Log
* @description before update trigger handler for object 
*/
public with sharing class ErrorLogBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp) 
	{
		process((List<ErrorLog__c>)tp.newList, (Map<Id,ErrorLog__c>)tp.oldMap);
	}

	private void process(List<ErrorLog__c> newList, Map<Id,ErrorLog__c> oldMap)
	{
		for(ErrorLog__c l : newList)
		{
			if(oldMap.get(l.Id).Duplicate__c == false && l.Duplicate__c == true && l.ErrorStackTrace__c != null)
			{
				l.Duplicate__c = false;
			}
		}
	}
}