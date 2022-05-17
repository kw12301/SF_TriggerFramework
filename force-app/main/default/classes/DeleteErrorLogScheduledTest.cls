/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description Test successful deletion of error logs older than number of days 
*  specified in DaysPriorToDeleteErrors Custom Label. If no label defined, defaults to 30
*/

@isTest 
public with sharing class DeleteErrorLogScheduledTest
{
    /**
    * @author Kevin Winn
    * @date 01/01/2020
    * @description Test scheduler
    */
    public static testMethod void errorLogScheduler() 
    {  
        Test.startTest();
        String jobId = System.schedule('Delete Error Logs Testing', TestDataFactory.CRON_JOB_EXPRESSION, new DeleteErrorLogScheduled());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger  WHERE id = :jobId ][0];
        
        System.assertEquals(TestDataFactory.CRON_JOB_EXPRESSION , ct.CronExpression,'cron job mismatch');
        Test.stopTest();
    }
    
    /**
    * @author Kevin Winn
    * @date 01/01/2020
    * @description Test error log creation
    */
    public static testMethod void createErrorLog() 
    {  
        Account a = new Account();
        try {
            insert a;
        } catch (Exception e) {
            LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
        }
        
        Integer errors = [SELECT count() FROM ErrorLog__c];
        System.assertNotEquals(errors, 0,'Expected ErrorLog__c records to exist but found none');
    }
    
    /**
    * @author Kevin Winn
    * @date 01/01/2020
    * @description Test batch
    */
    public static testMethod void batchDeleteErrorLogStandardUser() 
    {  
        User usr = TestDataFactory.createStandardUser();
        System.runAs(usr) 
        {
            LoggingHandler.debug('Test String', 'Test Error', 'Test Object',null);
            Test.startTest();
            Database.executeBatch(new DeleteErrorLogBatch()); 
            Test.stopTest();
            Integer errors = [Select count() from ErrorLog__c];
            System.assertEquals(errors, 0,'Errors not zero');
        }
    }

    /**
    * @author Kevin Winn
    * @date 01/01/2020
    * @description Test batch
    */
    public static testMethod void batchDeleteErrorLogAdminUser() 
    {  
        User usr = TestDataFactory.createAdminUser();
        System.runAs(usr) 
        {
            LoggingHandler.debug('Test String', 'Test Error', 'Test Object',null);
            Test.startTest();
            Database.executeBatch(new DeleteErrorLogBatch()); 
            Test.stopTest();
            Integer errors = [Select count() from ErrorLog__c];
            System.assertEquals(errors, 0,'errors not zero');
        }
    }
}