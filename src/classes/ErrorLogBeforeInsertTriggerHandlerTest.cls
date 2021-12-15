/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description before insert trigger handler test for object 
*/
@isTest 
private class ErrorLogBeforeInsertTriggerHandlerTest 
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

		List<ErrorLog__c> newLogs = [Select Id From ErrorLog__c Where IsDeleted = false];
		System.assertEquals(50,newLogs.size(),'Unexpected record count.  Expected 50');
	}

	static testMethod void testDuplicateEntryIdentification()
	{
		Test.startTest();
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
		Test.stopTest();

		List<ErrorLog__c> dupes = [Select Id From ErrorLog__c];
		List<ErrorLog__c> dupeId = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertEquals((dupes.size()/2),dupeId.size(),'dupe identification failed');
	}

	static testMethod void testSingleInsert()
	{
		Test.startTest();
		Map<id,ErrorLog__c> log = TestDataFactory.createErrorLogs(1, 'Account', 'Salesforce Exception', 'Undefined', null);
		Test.stopTest();
		System.assert(!log.isEmpty(),'Logs are empty');
	}
}