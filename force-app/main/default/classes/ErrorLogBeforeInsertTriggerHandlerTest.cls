/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description before insert trigger handler test for object 
*/
@isTest 
private class ErrorLogBeforeInsertTriggerHandlerTest {

	@isTest
	static void insertTestSuccess() {
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(Integer i = 0; i < 50; i++)	{
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

	@isTest
	static void testDuplicateEntryIdentification() {
		Test.startTest();
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
		Test.stopTest();

		List<ErrorLog__c> dupes = [Select Id From ErrorLog__c];
		List<ErrorLog__c> dupeId = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertEquals((dupes.size()/2),dupeId.size(),'dupe identification failed');
	}

	@isTest
	static void testSingleInsert(){
		Test.startTest();
		Map<id,ErrorLog__c> log = TestDataFactory.createErrorLogs(1, 'Account', 'Salesforce Exception', 'Undefined', null);
		Test.stopTest();
		System.assert(!log.isEmpty(),'Logs are empty');
	}
}