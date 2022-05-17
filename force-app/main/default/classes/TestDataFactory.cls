/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description Test Data Factory class
*/
@isTest
public with sharing class TestDataFactory {

	public static final String USER_STANDARD_EMAIL = 'rstan@testtenant2.com';
	public static final String USER_ADMIN_EMAIL = 'radmi@testtenant2.com';
	public static final String USER_STANDARD_ALIAS = 'rstan';
	public static final String USER_ADMIN_ALIAS = 'radmi';
	public static final String USER_GUEST_ALIAS = 'rgues';
	public static final String USER_GUEST_EMAIL = 'rgues@testtenant2.com';

	public static final String CRON_JOB_EXPRESSION = '0 0 0 * * ?';

	/** 
	* @description create default standard user for tests
	* @return Type: User
	*/
	public static User createStandardUser(){
        User u = constructUser('Standard User', USER_STANDARD_ALIAS, USER_STANDARD_EMAIL);
        GlobalDMLHandler.insertObject(u);
        return u;
	}

	/** 
	* @description create default admin user for tests
	* @return Type: User
	*/
	public static User createAdminUser(){
        User u = constructUser('System Administrator', USER_ADMIN_ALIAS, USER_ADMIN_EMAIL);
        GlobalDMLHandler.insertObject(u);
        return u;
	}

	/** 
	* @description prepare in memory a guest user for guest user enabled communities.
	* @param String the api name for the community profile
	* @return Type: User
	*/
	public static User prepareGuestUser(String communityProfileName) {
       return constructUser(communityProfileName,USER_GUEST_ALIAS,USER_GUEST_EMAIL);
	}

	/** 
	* @description prepare a test user record in memory
	* @param String the profile name to assign to the user
	* @param String the alias to assign to the user
	* @param String the email address to use for both username and email for the user
	* @return Type: User
	*/
	public static User constructUser(String profileName, String rAlias, String email) {
		Profile p = [SELECT Id FROM Profile WHERE Name=: profileName]; 
        return new User(
        	Alias = rAlias, 
        	Email= email, 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName= email);
	}

	/** 
	* @description Should generate ErrorLog__c records based on the number submitted
	* @param Integer The number of error logs expected to be returned.
	* @return Type: Integer
	*/
	public static Integer generateExpectedErrorLogs(Integer expectedErrorLogs) {
		List<Account> errors = new List<Account>();
		for(Integer i = 0; i < expectedErrorLogs ; i++){
			errors.add(new Account());
		}
		try{
			GlobalDMLHandler.insertObjectList(errors);
		} catch(Exception e){
			LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
			LoggingHandler.popAll();
		}
		return Integer.valueOf([Select count() From ErrorLog__c]);
	}

	/** 
	* @description construct an ErrorLog__c record in memory
	* @param String The Object__c Api Name
	* @param String The ErrorType__c
	* @param String The ErrorSubType__c
	* @param String The ErrorStackTrace__c
	* @return Type: ErrorLog__c
	*/
	public static ErrorLog__c prepareErrorLog(String sobj, String eType, String eSubtype, String stackTrace) {
		ErrorLog__c el = new ErrorLog__c();
		el.Object__c = sobj;
		el.ErrorType__c = eType;
		el.ErrorSubtype__c = eSubtype;
		el.ErrorStackTrace__c = stackTrace;
		return el;
	}

	/** 
	* @description create ErrorLog__c records
	* @param Integer The number of records to create
	* @param String The Object__c
	* @param String The ErrorType__c
	* @param String The ErrorSubType__c
	* @param String The ErrorStackTrace__c
	* @return Type: Map<Id,ErrorLog__c> 
	*/
	public static Map<Id,ErrorLog__c> createErrorLogs(Integer qty, String sObj, String eType, String eSubtype, String stackTrace) {
		Map<Id,ErrorLog__c> eMap = new Map<Id,ErrorLog__c>();
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(Integer i = 0; i < qty; i++){
			logs.add(prepareErrorLog(sObj,eType,eSubtype,stackTrace));
		}
		GlobalDMLHandler.insertObjectList(logs);
		eMap.putAll(logs);
		return eMap;
	}

	/** 
	* @description generates specific dml error message for field integrity
	* @param Integer The number of records to create
	*/
	public static void generateErrorLogs(Integer qty) {
		List<Account> accts = new List<Account>();
		for(Integer i = 0; i < qty; i ++){
			accts.add(new Account(BillingState = StaticResources.TEST_ERRORLOG_STATECODE));
		}
		try{
			GlobalDMLHandler.insertObjectList(accts);
		}catch(Exception ex){
			LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'Account');
			LoggingHandler.popAll();
		}
	}
}