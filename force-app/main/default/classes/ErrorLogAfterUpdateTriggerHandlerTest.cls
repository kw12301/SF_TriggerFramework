/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description after update trigger handler test for object 
*/
@isTest 
private class ErrorLogAfterUpdateTriggerHandlerTest 
{
	@testSetup
	static void setupTestData()
	{
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
	}

	static testMethod void updateTestSuccess() 
	{
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		Test.startTest();
		for(ErrorLog__c l : logs.values())
		{
			l.Duplicate__c = true;
		}
		GlobalDMLHandler.updateObjectList(logs.values());
		Test.stopTest();

		Map<Id,ErrorLog__c> updatedLogs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		System.assertEquals(logs.size(), updatedLogs.size(),'Log sizes do not match');
	}
}