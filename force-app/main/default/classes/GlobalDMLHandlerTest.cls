/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description tests for GlobalDMLHandler.cls
**/

@isTest 
private class GlobalDMLHandlerTest {
    // Constants used in test class 
    private static final String TEST_AC_NAME = 'Test Acc Name';
    private static final String TEST_AC_NAME_UPDATED = 'TestUpdate';
    private static final String TEST_AC_NAME_UPSERT = 'Test Acc Upsert';
    private static final Integer LIST_SIZE = 50;
    
    // Variables used in test class 
    private static Account accountToInsert;
    private static List<Account> accListToInsert;
    private static Account queryAccount;
    private static List<Account> queryAccountList;
    private static Event eventToInsert;
    private static List<Event> eventListToInsert;
    
    /**
    * @description Method to create and insert event with error
    */
    @isTest
    static void createInsertErrEvent() {
        Test.startTest();
        eventToInsert = new Event();
        eventToInsert.StartDateTime = system.now();
        eventToInsert.EndDateTime = system.now() + 50;
        GlobalDMLHandler.insertObject(eventToInsert,true);
        GlobalDMLHandler.upsertObject(eventToInsert,true);
        GlobalDMLHandler.updateObject(eventToInsert,true);
        GlobalDMLHandler.deleteObject(eventToInsert,true);
        GlobalDMLHandler.undeleteObject(eventToInsert,true);
        eventListToInsert = new List<Event>();
        for(Integer i = 0; i < LIST_SIZE ; i++) {
            Event auxEvent = new Event();
            auxEvent.StartDateTime = system.now();
            auxEvent.EndDateTime = system.now() + 50;
            eventListToInsert.add(auxEvent);
        }
        GlobalDMLHandler.insertObjectList(eventListToInsert,true);
        GlobalDMLHandler.upsertObjectList(eventListToInsert,true);
        GlobalDMLHandler.updateObjectList(eventListToInsert,true);
        GlobalDMLHandler.deleteObjectList(eventListToInsert,true);
        GlobalDMLHandler.undeleteObjectList(eventListToInsert,true);
        Test.stopTest();

    }

    /**
    * @description Method to create and insert event with error
    */
    @isTest
    static void createInsertErrEventOverload() {
        Test.startTest();
        eventToInsert = new Event();
        eventToInsert.StartDateTime = system.now();
        eventToInsert.EndDateTime = system.now() + 50;
        GlobalDMLHandler.insertObject(eventToInsert,false);
        GlobalDMLHandler.upsertObject(eventToInsert,false);
        GlobalDMLHandler.updateObject(eventToInsert,false);
        GlobalDMLHandler.deleteObject(eventToInsert,false);
        GlobalDMLHandler.undeleteObject(eventToInsert,false);
        eventListToInsert = new List<Event>();
        for(Integer i = 0; i < LIST_SIZE ; i++) {
            Event auxEvent = new Event();
            auxEvent.StartDateTime = system.now();
            auxEvent.EndDateTime = system.now() + 50;
            eventListToInsert.add(auxEvent);
        }
        GlobalDMLHandler.insertObjectList(eventListToInsert,false);
        GlobalDMLHandler.upsertObjectList(eventListToInsert,false);
        GlobalDMLHandler.updateObjectList(eventListToInsert,false);
        GlobalDMLHandler.deleteObjectList(eventListToInsert,false);
        GlobalDMLHandler.undeleteObjectList(eventListToInsert,false);
        Test.stopTest();
    }
    
    /**
    * @description Method to test inserts
    */
    @isTest
    static void testInsertsSuccess() {
        GlobalDMLHandlerTest.createTestDataInserts();
        Test.startTest();
        GlobalDMLHandler.insertObject(accountToInsert);
        GlobalDMLHandler.insertObjectList(accListToInsert);
        Test.stopTest();
        queryAccount = [SELECT Id FROM Account WHERE Name =: TEST_AC_NAME];
        queryAccountList = [SELECT Id FROM Account WHERE Name !=: TEST_AC_NAME];
        System.assert(queryAccount != null,'Query account is null');
        System.assertEquals(LIST_SIZE, queryAccountList.size(),'List size mismatch');
    }

    /**
    * @description Method to test failed inserts
    */
    @isTest
    static void testInsertsFail() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.insertObject(failedAccount,true);
        GLobalDMLHandler.insertObjectList(failedAccounts,true);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }

    /**
    * @description Method to test inserts
    */
    @isTest
    static void testInsertsSuccessWithOverlad() {
        GlobalDMLHandlerTest.createTestDataInserts();
        Test.startTest();
        GlobalDMLHandler.insertObject(accountToInsert,false);
        GlobalDMLHandler.insertObjectList(accListToInsert,false);
        Test.stopTest();
        queryAccount = [SELECT Id FROM Account WHERE Name =: TEST_AC_NAME];
        queryAccountList = [SELECT Id FROM Account WHERE Name !=: TEST_AC_NAME];
        System.assert(queryAccount != null,'Query account is null');
        System.assertEquals(LIST_SIZE, queryAccountList.size(),'List size mismatch');
    }

    /**
    * @description Method to test failed inserts
    */
    @isTest
    static void testInsertsFailOverload() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.insertObject(failedAccount,false);
        GLobalDMLHandler.insertObjectList(failedAccounts,false);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }
    
    /**
    * @description Method to test updates
    */
    @isTest
    static void testUpdates() {        
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert,true);
        GlobalDMLHandler.insertObjectList(accListToInsert,true);
        for(Account aux : accListToInsert) 
        {
            aux.Name = TEST_AC_NAME_UPDATED;
        }
        Test.startTest();
        GlobalDMLHandler.updateObject(accountToInsert);
        GlobalDMLHandler.updateObjectList(accListToInsert);
        Test.stopTest();
        System.assert(!accListToInsert.isEmpty(),'no accounts to insert');
    }

    /**
    * @description Method to test failed updates
    */
    @isTest
    static void testUpdatesFail() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.updateObject(failedAccount,true);
        GLobalDMLHandler.updateObjectList(failedAccounts,true);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }

    /**
    * @description Method to test updates
    */
    @isTest
    static void testUpdatesOverload() {        
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert,true);
        GlobalDMLHandler.insertObjectList(accListToInsert,true);
        for(Account aux : accListToInsert) 
        {
            aux.Name = TEST_AC_NAME_UPDATED;
        }
        Test.startTest();
        GlobalDMLHandler.updateObject(accountToInsert,false);
        GlobalDMLHandler.updateObjectList(accListToInsert,false);
        Test.stopTest();
        System.assert(!accListToInsert.isEmpty(),'no accounts to insert');
    }

    /**
    * @description Method to test failed updates
    */
    @isTest
    static void testUpdatesFailOverload() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.updateObject(failedAccount,false);
        GLobalDMLHandler.updateObjectList(failedAccounts,false);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }
    
    /**
    * @description Method to test upserts
    */
    @isTest
    static void testUpserts() {
        Account newAcc = new Account(Name = TEST_AC_NAME_UPSERT);
        Test.startTest();
        GlobalDMLHandler.upsertObject(newAcc);
        List<Account> newAccs = new List<Account>();
        for(Integer i = 0; i < LIST_SIZE; i++) 
        {
            Account aux = new Account(Name = TEST_AC_NAME_UPSERT);
            newAccs.add(aux);
        }
        GlobalDMLHandler.upsertObjectList(newAccs);
        Test.stopTest();
        queryAccountList = [SELECT Id FROM Account];
        System.assertEquals(LIST_SIZE + 1, queryAccountList.size(),'mismatched account lists');
    }

    /**
    * @description Method to test failed upserts
    */
    @isTest
    static void testUpsertsFail() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.upsertObject(failedAccount,true);
        GLobalDMLHandler.upsertObjectList(failedAccounts,true);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }

    /**
    * @description Method to test upserts
    */
    @isTest
    static void testUpsertsOverload() {
        Account newAcc = new Account(Name = TEST_AC_NAME_UPSERT);
        Test.startTest();
        GlobalDMLHandler.upsertObject(newAcc,false);
        List<Account> newAccs = new List<Account>();
        for(Integer i = 0; i < LIST_SIZE; i++) 
        {
            Account aux = new Account(Name = TEST_AC_NAME_UPSERT);
            newAccs.add(aux);
        }
        GlobalDMLHandler.upsertObjectList(newAccs,false);
        Test.stopTest();
        queryAccountList = [SELECT Id FROM Account];
        System.assertEquals(LIST_SIZE + 1, queryAccountList.size(),'mismatched account lists');
    }

    /**
    * @description Method to test failed upserts
    */
    @isTest
    static void testUpsertsFailOverload() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.upsertObject(failedAccount,false);
        GLobalDMLHandler.upsertObjectList(failedAccounts,false);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }
    
    /**
    * @description Method to test deletes
    */
    @isTest
    static void testDeletes() {
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert);
        GlobalDMLHandler.insertObjectList(accListToInsert);
        Test.startTest();
        queryAccount = [SELECT Id FROM Account WHERE Name !=:TEST_AC_NAME limit 1];
        GlobalDMLHandler.deleteObject(queryAccount,true);
        Test.stopTest();
        queryAccountList = [SELECT Id FROM Account ];
        System.assertEquals(LIST_SIZE, queryAccountList.size(),'mismatched account lists');
    }

     /**
    * @description Method to test failed upserts
    */
    @isTest
    static void testDeletesFail() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.deleteObject(failedAccount,true);
        GLobalDMLHandler.deleteObjectList(failedAccounts,true);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }

     /**
    * @description Method to test deletes
    */
    @isTest
    static void testDeletesOverload() {
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert);
        GlobalDMLHandler.insertObjectList(accListToInsert);
        Test.startTest();
        queryAccount = [SELECT Id FROM Account WHERE Name !=:TEST_AC_NAME limit 1];
        GlobalDMLHandler.deleteObject(queryAccount,false);
        Test.stopTest();
        queryAccountList = [SELECT Id FROM Account ];
        System.assertEquals(LIST_SIZE, queryAccountList.size(),'mismatched account lists');
    }

     /**
    * @description Method to test failed upserts
    */
    @isTest
    static void testDeletesFailOverload() {
        List<Account> failedAccounts = new List<Account>();
        Account failedAccount = new Account();
        Test.startTest();
        GlobalDMLHandler.deleteObject(failedAccount,false);
        GLobalDMLHandler.deleteObjectList(failedAccounts,false);
        Test.stopTest();
        ErrorLog__c[] logs = [SELECT Id FROM ErrorLog__c];
        System.assert(!logs.isEmpty(),'Catch block failed on insert');
    }
    
    /**
    * @description Method to create test data
    */
    private static void createTestDataInserts() {
        GlobalDMLHandlerTest.createAccount();
        GlobalDMLHandlerTest.createAccountList();
    }

    /**
    * @description Method to create test account record
    */
    private static void createAccount() {
        accountToInsert = new Account();
        accountToInsert.Name = TEST_AC_NAME;
    }

    /**
    * @description Method to create test account record list
    */
    private static void createAccountList() {
        accListToInsert = new List<Account>();
        for(Integer i = 0; i < LIST_SIZE; i++) 
        {
            Account aux = new Account();
            aux.Name = TEST_AC_NAME + system.now();
            accListToInsert.add(aux);
        }
    }
}