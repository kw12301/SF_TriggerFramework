/**
* @author Kevin Winn
* @date May 17, 2022
* @group Framework
* @description contains methods to process exceptions
*/
public with sharing class LoggingHandler {
    private static final String METHOD_ENTRY_PREFIX = 'Entering: ';
    private static final String EXCEPTION_LOG_PREFIX = 'Exception Log\n';
    private static final String EXCEPTION_INFO_PREFIX = 'Exception occurred on line ';
    private static final String EXCEPTION_STACK_TRACE_PREFIX = ' stack: ';
    private static final String HYPHEN_SEPARATOR = ' - ';
    private static final String PIPE_SEPARATOR = ' | ';
    private static final String EXCEPTION_TRACE_SUFFIX = ' |\n ';
    private static final String LINE_FEED_CHARACTER = '\n';
    private static final String OBJECT_LOGGING_SETTING_NAME = 'Enable Object Logging';
    private static final Integer MAX_LENGTH_LOG = 32768;
    public static final String INTEGRATION_EXCEPTION =  'INTEGRATION_EXCEPTION';
    public static final String SALESFORCE_EXCEPTION = 'SALESFORCE_EXCEPTION';
    public static List<ErrorLog__c> errorLogs = new List<ErrorLog__c>();

    /**
     *@description Holds all information gathered from an execution context
    */ 
    @TestVisible 
    private static List<LogEntry> debuggingLog = new List<LogEntry>();
    
    /**
     *@description The current log level
    */ 
    @TestVisible 
    private static Integer logLevel = 0;

    /**
     *@description Holds all the method entries and exception messages
    */ 
    @TestVisible 
    private static List<String> stackTrace = new List<String>();

    /**
     *@description Used to diplay/debug the stackTrace
    */ 
    @TestVisible 
    private static String exceptionTrace;

    /**
     *@description private wrapper used to capture the log entry
    */ 
    private class LogEntry {
        Integer level;
        String description;
        
        public LogEntry(String entryDescription) {
            level = logLevel;
            description = entryDescription;
        }
    }

    /**
    * @description Add an entry in the stack trace
    * @param String the name of the method that threw the exception
    * @param String a string identifier for the type of exception error
    */
    public static void pushEntry(String methodName, String errorType) {
        logLevel++;
        stackTrace.add(methodName);
    }

    /**
    * @description Removes an entry from the stack trace
    */
    public static void popEntry() {
        if(logLevel > 0) {
            logLevel--;
        } else {
            ErrorLog__c l = new ErrorLog__c();
            l.ErrorStackTrace__c = retrieveExceptionLog();
            l.ErrorType__c = StaticResources.INTEGRATION_EXCEPTION;
            l.ErrorSubtype__c = 'Callout';
            errorLogs.add(l);
        }
        removeStackTraceEntry();
    }

    /**
    * @description clear the stack
    */
    public static void popAll() {
        logLevel = 0;
        popEntry();
        stackTrace.clear();
    }

    /**
    * @description Removes tha last entry in the stack trace
    */
    private static void removeStackTraceEntry() {
        if(stackTrace.size() > 0) {
            stackTrace.remove(stackTrace.size() - 1);
        }
    }

    /**
    * @description Add an entry in the debuggingLog
    * @param String the text of the log entry
    * @param String string value of error type from exception
    * @param String the sobject API name where the exception occurred
    * @param Exception the Exception object
    */
    public static void debug(String debugString, String errorType, String objectName, Exception ex) {
        debuggingLog.add(new LogEntry(debugString));
        String tempExceptionLog = retrieveExceptionLog();
        Integer tempLogLevel = logLevel;
        
        if(tempExceptionLog.length() <= MAX_LENGTH_LOG) {
            if(null != debugString) {
                saveError(debugString,errorType, objectName,ex);
            }
        }
        popAll();
        logLevel = tempLogLevel;
    }

    /**
    * @description Debug exception data
    * @param Exception the caught exception
    * @param String string value of error type from exception
    * @param String the sobject API name where the exception occurred
    */
    public static void debugException(Exception ex, String errorType, String objectName) {
        String exceptionInfo = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage() + EXCEPTION_STACK_TRACE_PREFIX + ex.getStackTraceString();
        debug(exceptionInfo, errorType, objectName, ex);
        
        //logic to create a custom error object entry
        exceptionTrace = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage();
        for(String stackTraceEntry :stackTrace) {
            exceptionTrace += PIPE_SEPARATOR + stackTraceEntry;
        }
        exceptionTrace += EXCEPTION_TRACE_SUFFIX;
        saveError(errorType, objectName,ex);
        if(!errorLogs.isEmpty()) {
            List<ErrorLog__c> deduped = new List<ErrorLog__c>();
            Set<String> types = new Set<String>();
            for(ErrorLog__c l : errorLogs) {
                if(!types.contains(l.ErrorType__c) && null != l.StackTraceString__c ) {
                    deduped.add(l);
                    types.add(l.ErrorType__c);
                }
            }
            GlobalDMLHandler.insertObjectList(deduped);
        }
    }
    
    /**
    * @description Debug exception data
    * @param Exception the caught exception
    * @param String string value of error type from exception
    */
    public static void debugException(Exception ex, String errorType) {
        String exceptionInfo = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage() + EXCEPTION_STACK_TRACE_PREFIX + ex.getStackTraceString();
        debug(exceptionInfo, errorType, null,ex);
        
        //logic to create a custom error object entry
        exceptionTrace = EXCEPTION_INFO_PREFIX + ex.getLineNumber() + HYPHEN_SEPARATOR + ex.getMessage();
        for(String stackTraceEntry :stackTrace) {
            exceptionTrace += PIPE_SEPARATOR + stackTraceEntry;
        }
        exceptionTrace += EXCEPTION_TRACE_SUFFIX;
        saveError(errorType, null, ex);
        if(!errorLogs.isEmpty()) {
            List<ErrorLog__c> deduped = new List<ErrorLog__c>();
            Set<String> types = new Set<String>();
            for(ErrorLog__c l : errorLogs) {
                if(null == l.Id && !types.contains(l.ErrorType__c) && null != l.StackTraceString__c ) {
                    deduped.add(l);
                    types.add(l.ErrorType__c);
                }
            }
            GlobalDMLHandler.insertObjectList(deduped);
        }
    }
    
    /**
    * @description Save error log entry
    * @param String string value of error type from exception
    * @param String the sobject API name where the exception occurred
    * @param Exception the Exception object
    */
    private static void saveError(String errorType, String objectName, Exception ex) {
        
        ErrorLog__c newErrorEntry = new ErrorLog__c();
        newErrorEntry.ErrorStackTrace__c = retrieveExceptionLog();
        newErrorEntry.ErrorType__c = errorType;
        newErrorEntry.Object__c = objectName;
        
        if(null != ex ) {
            newErrorEntry.ErrorSubtype__c = ex.getTypeName();
            newErrorEntry.Message__c = ex.getMessage();
            newErrorEntry.Cause__c = String.valueOf(ex.getCause());
            newErrorEntry.LineNumber__c = ex.getLineNumber();
            newErrorEntry.StackTraceString__c = ex.getStackTraceString();
            if(ex.getTypeName() == 'System.DMLException') {
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
        if(null == newErrorEntry.Id && null != newErrorEntry.ErrorStackTrace__c) {
            GlobalDMLHandler.insertObject(newErrorEntry);
        }
        debuggingLog.clear();
    }

    /**
    * @description Save error log entry
    * @param String the string value of debugging
    * @param String string value of error type from exception
    * @param String the sobject API name where the exception occurred
    * @param Exception the Exception object
    */
    private static void saveError(String debugString,String errorType, String objectName, Exception ex) {
        
        ErrorLog__c newErrorEntry = new ErrorLog__c();
        newErrorEntry.ErrorStackTrace__c = retrieveExceptionLog();
        newErrorEntry.StackTraceString__c = debugString;
        newErrorEntry.ErrorType__c = errorType;
        newErrorEntry.Object__c = objectName;
        
        if(null != ex ) {
            newErrorEntry.ErrorSubtype__c = ex.getTypeName();
            newErrorEntry.Message__c = ex.getMessage();
            newErrorEntry.Cause__c = String.valueOf(ex.getCause());
            newErrorEntry.LineNumber__c = ex.getLineNumber();
            newErrorEntry.StackTraceString__c = ex.getStackTraceString();
            if(ex.getTypeName() == 'System.DMLException') {
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
        if(null == newErrorEntry.Id && null != newErrorEntry.ErrorStackTrace__c) {
            GlobalDMLHandler.insertObject(newErrorEntry);
        }
        debuggingLog.clear();
    }

    /**
    * @description Retrieves the entire debug log
    * @return Type: String 
    */
    public static String retrieveExceptionLog() {
        String spaces = '                                                                        ';
        String result = '';
        for(LogEntry currentEntry :debuggingLog) {
            Integer endIndex = 3 * currentEntry.level;
            if(endIndex >= spaces.length()) {
                endIndex = spaces.length() - 1;
            }
            result += spaces.substring(0,endIndex) + currentEntry.description + LINE_FEED_CHARACTER;
        }
        return result;
    }

    /**
    * @description Processes Database.SaveResults[]
    * @param List<Database.SaveResult> a list of Database.SaveResult records
    * @param String the Sobject API Name that DML was performed on
    */
    public static void processSaveResults(List<Database.SaveResult> saveResults,String objectName) {
        errorLogs = null == errorLogs ? new List<ErrorLog__c>() : errorLogs;
        String username = UserInfo.getUserName();
        Id userId = UserInfo.getUserId();
        for(Database.SaveResult sr : saveResults) {
            if(!sr.isSuccess()) {
                for(Database.Error error : sr.getErrors()) {
                    String statusCode = String.valueOf(error.getStatusCode());
                    String message = error.getMessage();
                    String[] fields = error.getFields();
                    String recId = null != sr.getId() ? sr.getId() : null;
                    errorLogs.add(prepareErrorLog(statusCode,message,fields,username,userId,recId,objectName));
                }
            }
        }
        upsert errorLogs;
    }

    /**
    * @author Kevin Winn
    * @description Processes Database.UpsertResults[]
    * @param List<Database.UpsertResult> a list of Database.UpsertResult records
    * @param String the Sobject API Name that DML was performed on
    */
    public static void processUpsertResults(List<Database.UpsertResult> upsertResults, String objectName) {
        errorLogs = null == errorLogs ? new List<ErrorLog__c>() : errorLogs;
        String username = UserInfo.getUserName();
        Id userId = UserInfo.getUserId();
        for(Database.UpsertResult sr : upsertResults) {
            if(!sr.isSuccess()) {
                for(Database.Error error : sr.getErrors()) {
                    String statusCode = String.valueOf(error.getStatusCode());
                    String message = error.getMessage();
                    String[] fields = error.getFields();
                    String recId = null != sr.getId() ? sr.getId() : null;
                    errorLogs.add(prepareErrorLog(statusCode,message,fields,username,userId,recId,objectName));
                }
            }
        }
        upsert errorLogs;
    }

    /**
    * @description Processes Database.DeleteResults[]
    * @param List<Database.DeleteResult> a list of Database.DeleteResult records
    * @param String the Sobject API Name that DML was performed on
    */
    public static void processDeleteResults(List<Database.DeleteResult> deleteResults, String objectName) {
        errorLogs = null == errorLogs ? new List<ErrorLog__c>() : errorLogs;
        String username = UserInfo.getUserName();
        Id userId = UserInfo.getUserId();
        for(Database.DeleteResult sr : deleteResults) {
            if(!sr.isSuccess()) {
                for(Database.Error error : sr.getErrors()) {
                    String statusCode = String.valueOf(error.getStatusCode());
                    String message = error.getMessage();
                    String[] fields = error.getFields();
                    String recId = null != sr.getId() ? sr.getId() : null;
                    errorLogs.add(prepareErrorLog(statusCode,message,fields,username,userId,recId,objectName));
                }
            }
        }
        upsert errorLogs;
    }

    /**
    * @description Processes Database.DeleteResults[]
    * @param List<Database.UnDeleteResult> a list of Database.UnDeleteResult records
    * @param String the Sobject API Name that DML was performed on
    */
    public static void processUnDeleteResults(List<Database.UnDeleteResult> undeleteResults, String objectName) {
        errorLogs = null == errorLogs ? new List<ErrorLog__c>() : errorLogs;
        String username = UserInfo.getUserName();
        Id userId = UserInfo.getUserId();
        for(Database.UnDeleteResult sr : undeleteResults) {
            if(!sr.isSuccess()) {
                for(Database.Error error : sr.getErrors()) {
                    String statusCode = String.valueOf(error.getStatusCode());
                    String message = error.getMessage();
                    String[] fields = error.getFields();
                    String recId = null != sr.getId() ? sr.getId() : null;
                    errorLogs.add(prepareErrorLog(statusCode,message,fields,username,userId,recId,objectName));
                }
            }
        }
        upsert errorLogs;
    }

    private static ErrorLog__c prepareErrorLog(String statusCode, String message, String[] fields,String userName,Id userId,String recId,String objectName) {
        ErrorLog__c log = new ErrorLog__c();
        log.Cause__c = statusCode;
        log.DMLFields__c = String.valueOf(fields);
        log.DMLMessage__c = message;
        log.DMLId__c = recId;
        log.OwnerId = userId;
        log.Object__c = objectName;
        return log;
    }
}