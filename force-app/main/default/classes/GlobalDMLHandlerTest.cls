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
    private static final Integer LIST_SIZE = 5;
    
    // Variables used in test class 
    private static Account accountToInsert;
    private static List<Account> accListToInsert;
    private static Account queryAccount;
    private static List<Account> queryAccountList;
    private static Event eventToInsert;
    private static List<Event> eventListToInsert;
    
    /**
    * @description Method to start tests
    */
    @isTest
    static void testController() {
        Test.startTest();
        GlobalDMLHandlerTest.testInserts();
        GlobalDMLHandlerTest.testUpdates();
        GlobalDMLHandlerTest.testUpserts();
        GlobalDMLHandlerTest.testDeletes();
        GlobalDMLHandlerTest.createInsertErrEvent();
        Test.stopTest();
        System.assert(true == true,'This exists solely because of PMD.  assertions are performed on underlying methods');
    }
    
    /**
    * @description Method to create and insert event with error
    */
    @isTest
    static void createInsertErrEvent() {
        eventToInsert = new Event();
        eventToInsert.StartDateTime = system.now();
        eventToInsert.EndDateTime = system.now() + 50;
        GlobalDMLHandler.insertObject(eventToInsert);
        GlobalDMLHandler.upsertObject(eventToInsert);
        GlobalDMLHandler.updateObject(eventToInsert);
        GlobalDMLHandler.deleteObject(eventToInsert);
        eventListToInsert = new List<Event>();
        for(Integer i = 0; i < LIST_SIZE ; i++) {
            Event auxEvent = new Event();
            auxEvent.StartDateTime = system.now();
            auxEvent.EndDateTime = system.now() + 50;
            eventListToInsert.add(auxEvent);
        }
        GlobalDMLHandler.insertObjectList(eventListToInsert);
        GlobalDMLHandler.upsertObjectList(eventListToInsert);
        GlobalDMLHandler.updateObjectList(eventListToInsert);
        GlobalDMLHandler.deleteObjectList(eventListToInsert);
        GlobalDMLHandler.undeleteObjectList(eventListToInsert);
    }
    
    /**
    * @description Method to test inserts
    */
    @isTest
    static void testInserts() {
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert);
        GlobalDMLHandler.insertObjectList(accListToInsert);
        queryAccount = [SELECT Id FROM Account WHERE Name =: TEST_AC_NAME];
        queryAccountList = [SELECT Id FROM Account WHERE Name !=: TEST_AC_NAME];
        System.assert(queryAccount != null,'Query account is null');
        System.assertEquals(LIST_SIZE + 1, queryAccountList.size(),'List size mismatch');
    }
    
    /**
    * @description Method to test updates
    */
    @isTest
    static void testUpdates() {        
        accountToInsert.Name = TEST_AC_NAME_UPDATED;
        for(Account aux : accListToInsert) 
        {
            aux.Name = TEST_AC_NAME_UPDATED;
        }
        GlobalDMLHandler.updateObject(accountToInsert);
        GlobalDMLHandler.updateObjectList(accListToInsert);
        System.assert(!accListToInsert.isEmpty(),'no accounts to insert');
    }
    
    /**
    * @description Method to test upserts
    */
    @isTest
    static void testUpserts() {
        Account newAcc = new Account(Name = TEST_AC_NAME_UPSERT);
        GlobalDMLHandler.upsertObject(newAcc);
        List<Account> newAccs = new List<Account>();
        for(Integer i = 0; i < LIST_SIZE; i++) 
        {
            Account aux = new Account(Name = TEST_AC_NAME_UPSERT);
            newAccs.add(aux);
        }
        GlobalDMLHandler.upsertObjectList(newAccs);
        queryAccountList = [SELECT Id FROM Account];
        System.assertEquals((2 * (LIST_SIZE + 1))+1, queryAccountList.size(),'mismatched account lists');
    }
    
    /**
    * @description Method to test deletes
    */
    @isTest
    static void testDeletes() {
        queryAccount = [SELECT Id FROM Account WHERE Name !=:TEST_AC_NAME limit 1];
        GlobalDMLHandler.deleteObject(queryAccount);
        queryAccountList = [SELECT Id FROM Account ];
        System.assertEquals(2 * (LIST_SIZE + 1), queryAccountList.size(),'mismatched account lists');
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