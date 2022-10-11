/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description before delete trigger handler test for object 
*/
@isTest 
private class ErrorLogBeforeDeleteTriggerHandlerTest {
	@testSetup
	static void setupTestData()	{
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
	}

	@isTest
	static void deleteTestSuccess() {
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		List<ErrorLog__c> dupes = new LIst<ErrorLog__c>();
		for(ErrorLog__c l : logs.values()){
			if(l.Duplicate__c == true){
				dupes.add(l);
			}
		}
		Test.startTest();
		GlobalDMLHandler.deleteObjectList(dupes);
		Test.stopTest();

		List<ErrorLog__c> noDupes = [Select Id From ErrorLog__c Where Duplicate__c = false];
		System.assertNotEquals(true, noDupes.isEmpty(),'dupes are not empty');
	}

	@isTest
	static void deleteAgedLogsSuccess(){
		Integer target = -5;
		Test.startTest();
		ErrorLogHelper.deleteAgedErrorLogs(target);
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c];
		System.assertEquals(true,logs.isEmpty(),'logs are not empty');
	}
}