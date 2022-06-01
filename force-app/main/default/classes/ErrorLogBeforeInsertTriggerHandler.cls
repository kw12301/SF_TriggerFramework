/**
* @author Kevin Winn
* @date May 17, 2022
* @group Trigger Handlers
* @description before insert trigger handler for object 
*/
public with sharing class ErrorLogBeforeInsertTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
		process((List<ErrorLog__c>)tp.newList);
	}

	private void process(List<ErrorLog__c> newList)	{
		for(ErrorLog__c l : newList){
			if(null == l.ErrorStackTrace__c || l.ErrorStackTrace__c.length() < 1){
				l.Duplicate__c = true;
			}
		}
	}
}