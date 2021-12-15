/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description after insert trigger handler test for object 
*/
@isTest 
private class ErrorLogAfterInsertTriggerHandlerTest 
{

	static testMethod void insertTestSuccess() 
	{
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(Integer i = 0; i < 50; i++)
		{
			ErrorLog__c l = new ErrorLog__c();
			l.Cause__c = 'Test Cause';
			l.DMLFieldNames__c = 'Field1,Field2';
			l.ErrorStackTrace__c = 'ErrorStackTrace';
			l.ErrorType__c = 'Salesforce';
			l.Object__c = 'ErrorLog__c';
			logs.add(l);
		}

		Test.startTest();
		GlobalDMLHandler.insertObjectList(logs);
		Test.stopTest();

		List<ErrorLog__c> newLogs = [Select Id From ErrorLog__c];
		System.assertEquals(50,newLogs.size(),'Unexpected record count.  Expected 50');
	}
}