/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description Test Data Factory class
*/
@isTest
public with sharing class TestDataFactory 
{

	public static final String USER_STANDARD_EMAIL = 'rstan@testtenant2.com';
	public static final String USER_ADMIN_EMAIL = 'radmi@testtenant2.com';
	public static final String USER_STANDARD_ALIAS = 'rstan';
	public static final String USER_ADMIN_ALIAS = 'radmi';

	public static final String CRON_JOB_EXPRESSION = '0 0 0 * * ?';

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description create default standard user for tests
	*/
	public static User createStandardUser()
	{
        User u = constructUser('Standard User', USER_STANDARD_ALIAS, USER_STANDARD_EMAIL);
        GlobalDMLHandler.insertObject(u);
        return u;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description create default admin user for tests
	*/
	public static User createAdminUser()
	{
        User u = constructUser('System Administrator', USER_ADMIN_ALIAS, USER_ADMIN_EMAIL);
        GlobalDMLHandler.insertObject(u);
        return u;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description create default admin user for tests
	*/
	public static User getGuestUser(String communityProfileName)
	{
       return constructUser(communityProfileName,'guest','sales@testtenant2.com');
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description prepare a test user record
	* @param profileName the profile name to assign to the user
	* @param rAlias the alias to assign to the user
	* @param email to use for both username and email for the user
	*/
	public static User constructUser(String profileName, String rAlias, String email)
	{
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
	* @author Kevin Winn
	* @date 01/01/2020
	* @description Should generate ErrorLog__c records based on the number submitted
	* @param expectedErrorLogs The number of error logs expected to be returned.
	*/
	public static Integer generateExpectedErrorLogs(Integer expectedErrorLogs)
	{
		List<Account> errors = new List<Account>();
		for(Integer i = 0; i < expectedErrorLogs ; i++)
		{
			errors.add(new Account());
		}
		try{
			GlobalDMLHandler.insertObjectList(errors);
		}
		catch(Exception e)
		{
			LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
		}
		return Integer.valueOf([Select count() From ErrorLog__c]);
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description construct an ErrorLog__c record
	* @param sobj The Object__c
	* @param eType The ErrorType__c
	* @param eSubtype The ErrorSubType__c
	* @param stackTrace The ErrorStackTrace__c
	*/
	public static ErrorLog__c prepareErrorLog(String sobj, String eType, String eSubtype, String stackTrace)
	{
		ErrorLog__c el = new ErrorLog__c();
		el.Object__c = sobj;
		el.ErrorType__c = eType;
		el.ErrorSubtype__c = eSubtype;
		el.ErrorStackTrace__c = stackTrace;
		return el;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description create a ErrorLog__c records
	* @param qty The number of records to create
	* @param sobj The Object__c
	* @param eType The ErrorType__c
	* @param eSubtype The ErrorSubType__c
	* @param stackTrace The ErrorStackTrace__c
	*/
	public static Map<Id,ErrorLog__c> createErrorLogs(Integer qty, String sObj, String eType, String eSubtype, String stackTrace)
	{
		Map<Id,ErrorLog__c> eMap = new Map<Id,ErrorLog__c>();
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(Integer i = 0; i < qty; i++)
		{
			logs.add(prepareErrorLog(sObj,eType,eSubtype,stackTrace));
		}
		GlobalDMLHandler.insertObjectList(logs);
		eMap.putAll(logs);
		return eMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description generates specific dml error message for field integrity
	* @param qty The number of records to create
	*/
	public static void generateErrorLogs(Integer qty)
	{
		List<Account> accts = new List<Account>();
		for(Integer i = 0; i < qty; i ++)
		{
			accts.add(new Account(BillingStateCode = StaticResources.TEST_ERRORLOG_STATECODE));
		}
		try{
			GlobalDMLHandler.insertObjectList(accts);
		}
		catch(Exception ex)
		{
			LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'Account');
		}
	}
}