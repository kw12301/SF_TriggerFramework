/**
* @author Kevin Winn
* @date May 17, 2022
* @group Trigger Handlers
* @description after insert trigger handler for object 
*/
public with sharing class ErrorLogAfterInsertTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {
		process((List<ErrorLog__c>)tp.newList);
	}

	private void process(List<ErrorLog__c> newlist)	{
		List<ErrorLog__c> results = new List<ErrorLog__c>();
		for(ErrorLog__c e : newList){
			if(!e.Duplicate__c){
				results.add(e);
			}
		}
		if(!results.isEmpty()){
			EventProcessing.publishErrorEvent(results);
		}
	}
}