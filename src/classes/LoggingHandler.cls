/**
* @author Kevin Winn
* @date 12/31/2019
* @group Trigger Framework
* @description contains methods to process exceptions
*/
public with sharing class LoggingHandler 
{
    private static final String METHOD_ENTRY_PREFIX = 'Entering: ';
    private static final String EXCEPTION_LOG_PREFIX = 'Exception Log\n';
    private static final String EXCEPTION_INFO_PREFIX = 'Exception occurred on line ';
    private static final String EXCEPTION_STACK_TRACE_PREFIX = ' stack: ';
    private static final String HYPHEN_SEPARATOR = ' - ';
    private static final String PIPE_SEPARATOR = ' | ';
    private static final String EXCEPTION_TRACE_PREFIX = ' |\n ';
    private static final String LINE_FEED_CHARACTER = '\n';
    private static final String OBJECT_LOGGING_SETTING_NAME = 'Enable Object Logging';
    private static final Integer MAX_LENGTH_LOG = 32768;

    public static final String INTEGRATION_EXCEPTION = 'Integration exception';
    public static final String SALESFORCE_EXCEPTION = 'Salesforce exception';

    // Holds all information gathered from an execution context
    @TestVisible 
    private static List<LogEntry> debuggingLog = new List<LogEntry>();
    
    // The current log level
    @TestVisible 
    private static Integer logLevel = 0;

    // Holds all the method entries and exception messages
    @TestVisible 
    private static List<String> stackTrace = new List<String>();

    // Used to diplay/debug the stackTrace
    @TestVisible 
    private static String exceptionTrace;

    // private wrapper used to capture the log entry
    private class LogEntry 
    {
        Integer level;
        String description;
        
        public LogEntry(String entryDescription) 
        {
            level = logLevel;
            description = entryDescription;
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Add an entry in the stack trace
    * @param methodName the name of the method that threw the exception
    * @see RevenueScheduleLoggingHandler.debug
    */
    public static void pushEntry(String methodName, String errorType) 
    {
        logLevel++;
        stackTrace.add(methodName);
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Removes an entry from the stack trace
    * @see RevenueScheduleLoggingHandler.currentLog
    * @see RevenueScheduleLoggingHandler.removeStackTraceEntry
    */
    public static void popEntry() 
    {
        if(logLevel > 0) 
        {
            logLevel--;
        } 
        else 
        {
            System.debug(LoggingLevel.INFO, EXCEPTION_LOG_PREFIX + retrieveExceptionLog());
        }
        removeStackTraceEntry();
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Displays the curent exception log
    * @see RevenueScheduleLoggingHandler.popEntry
    */
    public static void popAll() 
    {
        logLevel = 0;
        popEntry();
        stackTrace.clear();
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Removes tha last entry in the stack trace
    */
    private static void removeStackTraceEntry() 
    {
        if(stackTrace.size() > 0) 
        {
            stackTrace.remove(stackTrace.size() - 1);
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Add an entry in the debuggingLog
    * @param debugString the text of the log entry
    */
    public static void debug(String debugString, String errorType, String objectName, Exception ex) 
    {
        debuggingLog.add(new LogEntry(debugString));
        String tempExceptionLog = retrieveExceptionLog();
        
        if(tempExceptionLog.length() <= MAX_LENGTH_LOG) 
        {
            saveError(errorType, objectName,ex);
            Integer tempLogLevel = logLevel;
            popAll();
            logLevel = tempLogLevel;
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Debug exception data
    * @param ex the caught exception
    * @see RevenueScheduleLoggingHandler.debug
    */
    public static void debugException(Exception ex, String errorType, String objectName) 
    {
        String exceptionInfo = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage() + EXCEPTION_STACK_TRACE_PREFIX + ex.getStackTraceString();
        debug(exceptionInfo, errorType, objectName, ex);
        
        //logic to create a custom error object entry
        exceptionTrace = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage();
        for(String stackTraceEntry :stackTrace) 
        {
            exceptionTrace += PIPE_SEPARATOR + stackTraceEntry;
        }
        exceptionTrace += EXCEPTION_TRACE_PREFIX;
        saveError(errorType, objectName,ex);
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Debug exception data
    * @param ex the caught exception
    * @see RevenueScheduleLoggingHandler.debug
    */
    public static void debugException(Exception ex, String errorType) 
    {
        String exceptionInfo = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage() + EXCEPTION_STACK_TRACE_PREFIX + ex.getStackTraceString();
        debug(exceptionInfo, errorType, null,ex);
        
        //logic to create a custom error object entry
        exceptionTrace = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage();
        for(String stackTraceEntry :stackTrace) 
        {
            exceptionTrace += PIPE_SEPARATOR + stackTraceEntry;
        }
        exceptionTrace += EXCEPTION_TRACE_PREFIX;
        saveError(errorType, null, ex);
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Save error log entry
    */
    private static void saveError(String errorType, String objectName, Exception ex) 
    {
        
        ErrorLog__c newErrorEntry = new ErrorLog__c();
        newErrorEntry.ErrorStackTrace__c = retrieveExceptionLog();
        newErrorEntry.ErrorType__c = errorType;
        newErrorEntry.Object__c = objectName;
        
        if(null != ex ) 
        {
            newErrorEntry.ErrorSubtype__c = ex.getTypeName();
            newErrorEntry.Message__c = ex.getMessage();
            newErrorEntry.Cause__c = String.valueOf(ex.getCause());
            newErrorEntry.LineNumber__c = ex.getLineNumber();
            newErrorEntry.StackTraceString__c = ex.getStackTraceString();
            if(ex.getTypeName() == 'System.DMLException')
            {
                newErrorEntry.DMLFieldNames__c = String.valueOf(ex.getDMLFieldNames(0));
                newErrorEntry.DMLFields__c = String.valueOf(ex.getDmlFields(0));
                newErrorEntry.DMLId__c = ex.getDmlId(0);
                newErrorEntry.DMLIndex__c = ex.getDmlIndex(0);
                newErrorEntry.DMLMessage__c = ex.getDmlMessage(0);
                newErrorEntry.DMLStatusCode__c = ex.getDmlStatusCode(0);
                newErrorEntry.DMLType__c = String.valueOf(ex.getDmlType(0));
                newErrorEntry.DMLRecords__c = ex.getNumDml();
            }
        }
        if(null != newErrorEntry.ErrorStackTrace__c || newErrorEntry.ErrorStackTrace__c.length() > 0)
        {
            Database.insert(newErrorEntry,false);
        }
        
        System.debug(LoggingLevel.INFO, EXCEPTION_LOG_PREFIX + retrieveExceptionLog());
        debuggingLog.clear();
        
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Retrieves the entire debug log
    * @return result The text of the debug log
    */
    public static String retrieveExceptionLog() 
    {
        String spaces = '                                                                        ';
        String result = '';
        for(LogEntry currentEntry :debuggingLog) 
        {
            Integer endIndex = 3 * currentEntry.level;
            if(endIndex >= spaces.length()) 
            {
                endIndex = spaces.length()-1;
            }
            result += spaces.substring(0,endIndex) + currentEntry.description + LINE_FEED_CHARACTER;
        }
        return result;
    }

	/**
	* @description creates error logs for Database.Error objects returned from Save Results array
	* @param results The list of Database.SaveResult records
	* @param objectName The string value of the object the DML action relates to
	*/ 
	public static void processDatabaseSaveResults(List<Database.SaveResult> results,String objectName)
	{
		List<ErrorLog__c> newLogs = new List<ErrorLog__c>();
		for(Database.SaveResult sr : results)
		{
			if(!sr.isSuccess())
			{
				for(Database.Error error : sr.getErrors())
				{
					ErrorLog__c log = new ErrorLog__c();
					log.Object__c = objectName;
					log.DMLId__c = null != sr.getId() ? sr.getId() : null;
					log.ErrorType__c = 'Salesforce exception';
					log.ErrorSubtype__c = 'System.DmlException';
					newLogs.add(processDatabaseError(error,log));
				}
			}
		}
		if(!newLogs.isEmpty())
		{
			GlobalDMLHandler.insertObjectList(newLogs);
		}
	}

	/**
	* @description creates error logs for Database.Error objects returned from Upsert Results array
	* @param results The list of Database.Upsert records
	* @param objectName The string value of the object the DML action relates to
	*/ 
	public static void processDatabaseUpsertResults(List<Database.UpsertResult> results,String objectName)
	{
		List<ErrorLog__c> newLogs = new List<ErrorLog__c>();
		for(Database.UpsertResult sr : results)
		{
			if(!sr.isSuccess())
			{
				for(Database.Error error : sr.getErrors())
				{
					ErrorLog__c log = new ErrorLog__c();
					log.Object__c = objectName;
					log.DMLId__c = null != sr.getId() ? sr.getId() : null;
					log.ErrorType__c = 'Salesforce exception';
					log.ErrorSubtype__c = 'System.DmlException';
					newLogs.add(processDatabaseError(error,log));
				}
			}
		}
		if(!newLogs.isEmpty())
		{
			GlobalDMLHandler.insertObjectList(newLogs);
		}
	}

	/**
	* @description helper method to prepare an ErrorLog record from a Database.Error object
	* @param error The Database.Error object
	* @param log The ErrorLog__c to prepare
	* @return ErrorLog__c
	*/ 
	private static ErrorLog__c processDatabaseError(Database.Error error,ErrorLog__c log)
	{
		log.ErrorStacktrace__c = error.getMessage();
		log.StackTraceString__c = error.getMessage();
		log.Message__c = error.getMessage();
		log.DMLStatusCode__c = String.valueOf(error.getStatusCode());
		log.DMLMessage__c = error.getMessage();
		log.Cause__c = String.valueOf(error.getFields());
		log.DMLFieldNames__c = String.valueOf(error.getFields());
		log.DMLFIelds__c = String.valueOf(error.getFields());
		return log;
	}
}