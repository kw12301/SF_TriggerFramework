/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description tests for LoggingHandler.cls
*/
@isTest
public with sharing class LoggingHandlerTest 
{
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
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'pushEntry' method
    * @see LoggingHandler.pushEntry
    */
    public static testmethod void testPushEntry()
    {
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ONE_COUNT,'not 1');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ONE_COUNT,'not one');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'popEntry' method with an empty stack
    * @see LoggingHandler.popEntry
    */
    public static testmethod void testPopEntryEmptyStack()
    {
        Test.startTest();
        LoggingHandler.popEntry();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'popEntry' method with a populated stack
    * @see LoggingHandler.popEntry
    */
    public static testmethod void testPopEntryPopulatedStack()
    {
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        LoggingHandler.pushEntry(TEST_METHOD_NAME, INTEGRATION);
        LoggingHandler.popEntry();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ONE_COUNT,'not one');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ONE_COUNT,'not one');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'popAll' method with an empty stack
    * @see LoggingHandler.popAll
    */
    public static testmethod void testPopAllEmptyStack()
    {
        Test.startTest();
        LoggingHandler.popAll();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'popAll' method with a populated stack
    * @see LoggingHandler.popAll
    */
    public static testmethod void testPopAllPopulatedStack()
    {
        Test.startTest();
        LoggingHandler.pushEntry(TEST_METHOD_NAME, SALESFORCE);
        LoggingHandler.popAll();
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'debug' method
    * @see LoggingHandler.debug
    */
    public static testmethod void testDebug()
    {
        Test.startTest();
        LoggingHandler.debug(TEST_DEBUGGING_MESSAGE, SALESFORCE, null,null);
        Test.stopTest();
        System.assertEquals(LoggingHandler.logLevel, ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertEquals(LoggingHandler.stackTrace.size(), ZERO_COUNT,'not zero');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'debugException' method
    * @see LoggingHandler.debugException
    */
    public static testmethod void testDebugException()
    {
        Test.startTest();
        try
        {
            String testString;
            Integer testNumber = Integer.valueOf(testString);
        }
        catch(Exception ex)
        {
            LoggingHandler.debugException(ex, SALESFORCE, null);
        }
        Test.stopTest();
        System.assertEquals(LoggingHandler.debuggingLog.size(), ZERO_COUNT,'not zero');
        System.assertNotEquals(LoggingHandler.exceptionTrace.length(), ZERO_COUNT,'not zero');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'retrieveExceptionLog' method
    * @see LoggingHandler.retrieveExceptionLog
    */
    public static testmethod void testRetrieveExceptionLog()
    {
        Test.startTest();
        String testResult = LoggingHandler.retrieveExceptionLog();
        Test.stopTest();
        System.assertEquals(testResult, EMPTY_CHARACTER,'not empty character');
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'retrieveExceptionLog' method
    * @see TriggerException
    */
    public static testmethod void testTriggerException()
    {
        try{
            TriggerFactory.createTriggerDispatcher(Event.sObjectType);
        } catch(Exception ex){
            System.assertEquals(true,ex.getMessage().contains('No Trigger dispatcher registered for Object Type:'),'exception message mismatch');
        }
    }

     /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Test the 'retrieveExceptionLog' method
    * @see TriggerException
    */
    public static testmethod void testTriggerCustomException()
    {
       String message = 'Test';
       Test.startTest();
       TriggerException.CustomExceptionTest exTest = new TriggerException.CustomExceptionTest(message);
       Test.stopTest();
       System.assert(null != exTest,'custom exception is null');
    }

	@isTest
	static void testProcessDatabaseSaveResultsTest()
	{
		List<Quote> badQuotes = new List<Quote>();
		badQuotes.add(new Quote(Term__c = 12));
		Test.startTest();
		LoggingHandler.processDatabaseSaveResults(Database.insert(badQuotes,false),'Quote');
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c Where Object__c = 'Quote'];
		System.assertNotEquals(true,logs.isEmpty(),'No log created for error on quote');

	}

	@isTest
	static void testProcessDatabaseUpsertResultsTest()
	{
		List<Quote> badQuotes = new List<Quote>();
		badQuotes.add(new Quote(Term__c = 12));
		Test.startTest();
		LoggingHandler.processDatabaseUpsertResults(Database.upsert(badQuotes,false),'Quote');
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c Where Object__c = 'Quote'];
		System.assertNotEquals(true,logs.isEmpty(),'No log created for error on quote');
	}
}