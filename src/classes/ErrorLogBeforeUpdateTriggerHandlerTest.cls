/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description before update trigger handler test for object 
*/
@isTest 
private class ErrorLogBeforeUpdateTriggerHandlerTest 
{
	@testSetup
	static void setupTestData()
	{
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
	}

	static testMethod void updateTestSuccess() 
	{
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		for(ErrorLog__c l : logs.values())
		{
			if(l.Duplicate__c == true)
			{
				l.Duplicate__c = false;
			}
		}
		Test.startTest();
		GlobalDMLHandler.updateObjectList(logs.values());
		Test.stopTest();

		List<ErrorLog__c> dupes = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertNotEquals(true,dupes.isEmpty(),'dupes are empty');
	}

	static testMethod void testFieldUpdateDupeCheck()
	{
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		for(ErrorLog__c l : logs.values())
		{
			l.ErrorStackTrace__c = '';
		}
		Test.startTest();
		GlobalDMLHandler.updateObjectList(logs.values());
		Test.stopTest();

		List<ErrorLog__c> uLogs = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertEquals(logs.size(),uLogs.size(),'log size mismatch');
	}
}