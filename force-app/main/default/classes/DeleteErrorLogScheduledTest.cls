/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description Test successful deletion of error logs older than number of days 
*  specified in DaysPriorToDeleteErrors Custom Label. If no label defined, defaults to 30
*/

@isTest 
public with sharing class DeleteErrorLogScheduledTest{
    /**
    * @description Test scheduler
    */
    @isTest
    static void errorLogScheduler() {  
        Test.startTest();
        String jobId = System.schedule('Delete Error Logs Testing', TestDataFactory.CRON_JOB_EXPRESSION, new DeleteErrorLogScheduled());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger  WHERE id = :jobId ][0];
        
        System.assertEquals(TestDataFactory.CRON_JOB_EXPRESSION , ct.CronExpression,'cron job mismatch');
        Test.stopTest();
    }
    
    /**
    * @description Test error log creation
    */
    @isTest
    static void createErrorLog() {  
        Account a = new Account();
        try {
            insert a;
        } catch (Exception e) {
            LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
            LoggingHandler.popAll();
        }
        
        Integer errors = [SELECT count() FROM ErrorLog__c];
        System.assertNotEquals(errors, 0,'Expected ErrorLog__c records to exist but found none');
    }
    
    /**
    * @description Test batch
    */
    @isTest
    static void batchDeleteErrorLogStandardUser() {  
        User usr = TestDataFactory.createStandardUser();
        System.runAs(usr) {
            Account a = new Account();
            try {
                insert a;
            } catch (Exception e) {
                LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
                LoggingHandler.popAll();
            }
            Test.startTest();
            Database.executeBatch(new DeleteErrorLogBatch()); 
            Test.stopTest();
            Integer errors = [Select count() from ErrorLog__c];
            System.assertEquals(0, errors,'Errors not zero');
        }
    }

    /**
    * @description Test batch
    */
    @isTest
    static void batchDeleteErrorLogAdminUser()  {  
        User usr = TestDataFactory.createAdminUser();
        System.runAs(usr) {
            Account a = new Account();
            try {
                insert a;
            } catch (Exception e) {
                LoggingHandler.debugException(e, StaticResources.SALESFORCE_EXCEPTION, 'Account');
                LoggingHandler.popAll();
            }
            Test.startTest();
            Database.executeBatch(new DeleteErrorLogBatch()); 
            Test.stopTest();
            Integer errors = [Select count() from ErrorLog__c];
            System.assertEquals(0, errors,'errors not zero');
        }
    }
}