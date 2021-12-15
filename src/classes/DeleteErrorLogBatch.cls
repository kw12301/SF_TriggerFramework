/**
* @author Kevin Winn
* @date 12/31/2019
* @group Error Log
* @description Delete error logs older than number of days specified in
*  DaysPriorToDeleteErrors Custom Label.  If no label defined, defaults to 30
**/
public class DeleteErrorLogBatch implements Database.Batchable<sObject> 
{    
    public final String query;
    public final DateTime pastMonth;
    public final DateTime testTime;

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Prepare query to get error logs older than the specified number of days
    */   
    public DeleteErrorLogBatch() 
    {
        if (null != System.Label.DaysPriorToDeleteErrors) 
        {
            Integer daysNum = Integer.valueOf(System.Label.DaysPriorToDeleteErrors);
            pastMonth = System.now().addDays(-daysNum);
        } 
        else 
        {
            pastMonth = System.now().addDays(-30);
        }
        query = Test.isRunningTest() ? 'SELECT Id FROM ErrorLog__c WHERE CreatedDate < :testTime' : 'SELECT Id FROM ErrorLog__c WHERE CreatedDate < :pastMonth';
        
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Select all error logs older than the specified number of days
    */   
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(query);
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Delete all error logs older than the specified number of days
    */ 
    public void execute(Database.BatchableContext bc, List<ErrorLog__c> scope) 
    {
        GlobalDMLHandler.deleteObjectList(scope);
    }
    
    public void finish(Database.BatchableContext bc) 
    {
        System.debug(LoggingLevel.INFO,'Delete Error Log Batch completed');
    }
}