/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description tests for LoggingHandler.cls
*/
@isTest
public with sharing class LoggingHandlerTest {
    private static final String TEST_METHOD_NAME = 'testMethodName';
    private static final String TEST_DEBUGGING_MESSAGE = 'A test debug message.';
    private static final String OBJECT_SETTING_NAME = 'Enable Object Logging';
    private static final String INTEGRATION = 'Integration exception';
    private static final String SALESFORCE = 'Salesforce exception';
    private static final String EMPTY_CHARACTER = '';
    private static final Integer ZERO_COUNT = 0;
    private static final Integer ONE_COUNT = 1;
    private static final Integer TWO_COUNT = 2;

    /**
    * @description Test the 'pushEntry' method
    */
    @isTest
    static void testPushEntry(){
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ONE_COUNT,'Logging Level not 1 in testPushEntry');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'Debugging Log not zero in testPushEntry');
        System.assertEquals(LoggingHandler.stackTrace.size(), ONE_COUNT,'StackTrace size not one in testPushEntry');
    }

    /**
    * @description Test the 'popEntry' method with an empty stack
    */
    @isTest
    static void testPopEntryEmptyStack(){
        Test.startTest();
        LoggingHandler.popEntry();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'LogLEvel not zero in testPopEntryEmptyStack');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'Debugging Log not zero in testPopEntryEmptyStack');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'StackTrace size not zero in testPopEntryEmptyStack');
    }

    /**
    * @description Test the 'popEntry' method with a populated stack
    * @see LoggingHandler.popEntry
    */
    @isTest
    static void testPopEntryPopulatedStack(){
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        LoggingHandler.popEntry();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ONE_COUNT,'logLevel not one in testPopEntryPopulatedStack');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'debuggingLog not zero in testPopEntryPopulatedStack');
        System.assertEquals(LoggingHandler.stackTrace.size(), ONE_COUNT,'stackTrace not one in testPopEntryPopulatedStack');
    }

    /**
    * @description Test the 'popAll' method with an empty stack
    */
    @isTest
    static void testPopAllEmptyStack(){
        Test.startTest();
        LoggingHandler.popAll();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @description Test the 'popAll' method with a populated stack
    */
    @isTest
    static void testPopAllPopulatedStack(){
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, SALESFORCE);
        LoggingHandler.popAll();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @description Test the 'debug' method
    */
    @isTest
    static void testDebug(){
        Test.startTest();
        LoggingHandler.debug(TEST_DEBUGGING_MESSAGE, SALESFORCE, null,null);
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @description Test the 'debugException' method
    */
    @isTest
    static void testDebugException(){
        Test.startTest();
        try{
            String testString;
            Integer testNumber = Integer.valueOf(testString);
        }catch(Exception ex){
            LoggingHandler.debugException(ex, SALESFORCE, null);
        }
        Test.stopTest();
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertNotEquals(LoggingHandler.exceptionTrace.length(), ZERO_COUNT,'not zero');
    }

    /**
    * @description Test the 'retrieveExceptionLog' method
    * @see LoggingHandler.retrieveExceptionLog
    */
    @isTest
    static void testRetrieveExceptionLog(){
        Test.startTest();
        String testResult = LoggingHandler.retrieveExceptionLog();
        Test.stopTest();
        System.assertEquals(testResult, EMPTY_CHARACTER,'not empty character');
    }

    /**
    * @description Test the 'retrieveExceptionLog' method
    */
    @isTest
    static void testTriggerException(){
        try{
            TriggerFactory.createTriggerDispatcher(Event.sObjectType);
        } catch(Exception ex){
            System.assertEquals(true,ex.getMessage().contains('No Trigger dispatcher registered for Object Type:'),'exception message mismatch');
        }
    }

	@isTest
	static void testProcessDatabaseSaveResultsTest(){
		List<Account> badAccounts = new List<Account>();
		badAccounts.add(new Account());
		Test.startTest();
		LoggingHandler.processSaveResults(Database.insert(badAccounts,false),'Account');
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c Where Object__c = 'Account'];
		System.assertNotEquals(true,logs.isEmpty(),'No log created for error on Account');

	}

	@isTest
	static void testProcessDatabaseUpsertResultsTest(){
		List<Account> badAccounts = new List<Account>();
		badAccounts.add(new Account());
		Test.startTest();
		LoggingHandler.processUpsertResults(Database.upsert(badAccounts,false),'Account');
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c Where Object__c = 'Account'];
		System.assertNotEquals(true,logs.isEmpty(),'No log created for error on Account');
	}
}