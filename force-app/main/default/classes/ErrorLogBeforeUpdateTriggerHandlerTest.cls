/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description before update trigger handler test for object 
*/
@isTest 
private class ErrorLogBeforeUpdateTriggerHandlerTest {
	/**
	 * @description setup test data from test data factory
	 */
	@testSetup
	static void setupTestData()	{
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
	}

	/**
	 * @description test duplicate logic
	 */
	@isTest
	static void updateTestSuccess() {
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		for(ErrorLog__c l : logs.values()){
			if(l.Duplicate__c == true){
				l.Duplicate__c = false;
			}
		}
		Test.startTest();
		GlobalDMLHandler.updateObjectList(logs.values());
		Test.stopTest();

		List<ErrorLog__c> dupes = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertNotEquals(true,dupes.isEmpty(),'dupes are empty');
	}
	
	/**
	 * @description test duplicate logic
	 */
	@isTest
	static void testFieldUpdateDupeCheck(){
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		for(ErrorLog__c l : logs.values()){
			l.ErrorStackTrace__c = '';
		}
		Test.startTest();
		GlobalDMLHandler.updateObjectList(logs.values());
		Test.stopTest();

		List<ErrorLog__c> uLogs = [Select Id From ErrorLog__c Where Duplicate__c = true];
		System.assertEquals(logs.size(),uLogs.size(),'log size mismatch');
	}
}