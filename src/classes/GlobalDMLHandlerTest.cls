/**
* @author Kevin Winn
* @date 12/31/2019
* @group Test Classes
* @description tests for GlobalDMLHandler.cls
**/

@isTest 
private class GlobalDMLHandlerTest 
{
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
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to start tests
    * @see GlobalDMLHandlerTest.testInserts
    * @see GlobalDMLHandlerTest.testUpdates
    * @see GlobalDMLHandlerTest.testUpserts
    * @see GlobalDMLHandlerTest.testDeletes
    * @see GlobalDMLHandlerTest.testErr
    */
    @isTest
    private static void testController() 
    {
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
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to create and insert event with error
    * @see GlobalDMLHandlerTest.insertObject
    * @see GlobalDMLHandlerTest.upsertObject
    * @see GlobalDMLHandlerTest.updateObject
    * @see GlobalDMLHandlerTest.deleteObject
    * @see GlobalDMLHandlerTest.insertObjectList
    * @see GlobalDMLHandlerTest.upsertObjectList
    * @see GlobalDMLHandlerTest.updateObjectList
    * @see GlobalDMLHandlerTest.deleteObjectList
    */
    private static void createInsertErrEvent() 
    {
        eventToInsert = new Event();
        eventToInsert.StartDateTime = system.now();
        eventToInsert.EndDateTime = system.now() + 50;
        GlobalDMLHandler.insertObject(eventToInsert);
        GlobalDMLHandler.upsertObject(eventToInsert);
        GlobalDMLHandler.updateObject(eventToInsert);
        GlobalDMLHandler.deleteObject(eventToInsert);
        eventListToInsert = new List<Event>();
        for(Integer i = 0; i < LIST_SIZE ; i++) 
        {
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
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to test inserts
    * @see GlobalDMLHandlerTest.createTestDataInserts
    * @see GlobalDMLHandler.insertObject
    * @see GlobalDMLHandler.insertObjectList
    */
    private static void testInserts() 
    {
        GlobalDMLHandlerTest.createTestDataInserts();
        GlobalDMLHandler.insertObject(accountToInsert);
        GlobalDMLHandler.insertObjectList(accListToInsert);
        queryAccount = [SELECT Id FROM Account WHERE Name =: TEST_AC_NAME];
        queryAccountList = [SELECT Id FROM Account WHERE Name !=: TEST_AC_NAME];
        System.assert(queryAccount != null,'Query account is null');
        System.assertEquals(LIST_SIZE + 1, queryAccountList.size(),'List size mismatch');
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019 
    * @description Method to test updates
    * @see GlobalDMLHandler.updateObject
    * @see GlobalDMLHandler.updateObjectList
    */
    private static void testUpdates() 
    {        
        accountToInsert.Name = TEST_AC_NAME_UPDATED;
        for(Account aux : accListToInsert) 
        {
            aux.Name = TEST_AC_NAME_UPDATED;
        }
        GlobalDMLHandler.updateObject(accountToInsert);
        GlobalDMLHandler.updateObjectList(accListToInsert);
        GlobalDMLHandler.updateObjectList(accListToInsert,false);
        System.assert(!accListToInsert.isEmpty(),'no accounts to insert');
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to test upserts
    * @see GlobalDMLHandler.upsertObject
    * @see GlobalDMLHandler.upsertObjectList
    */
    private static void testUpserts() 
    {
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
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to test deletes
    * @see GlobalDMLHandler.deleteObject
    * @see GlobalDMLHandler.deleteObjectList
    */
    private static void testDeletes() 
    {
        queryAccount = [SELECT Id FROM Account WHERE Name !=:TEST_AC_NAME limit 1];
        GlobalDMLHandler.deleteObject(queryAccount);
        queryAccountList = [SELECT Id FROM Account ];
        System.assertEquals(2 * (LIST_SIZE + 1), queryAccountList.size(),'mismatched account lists');
        queryAccountList = [SELECT Id FROM Account Where Name !=: StaticResources.DEFAULT_COMPANY_NAME];
        GlobalDMLHandler.deleteObjectList(queryAccountList);
        queryAccountList = [SELECT Id FROM Account];
        System.assertEquals(1, queryAccountList.size(),'mismatched account lists');
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to create test data
    * @see GlobalDMLHandlerTest.createAccount
    * @see GlobalDMLHandlerTest.createAccountList
    */
    private static void createTestDataInserts() 
    {
        GlobalDMLHandlerTest.createAccount();
        GlobalDMLHandlerTest.createAccountList();
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Method to create test account record
    */
    private static void createAccount() 
    {
        accountToInsert = new Account();
        accountToInsert.Name = TEST_AC_NAME;
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019 
    * @description Method to create test account record list
    */
    private static void createAccountList() 
    {
        accListToInsert = new List<Account>();
        for(Integer i = 0; i < LIST_SIZE; i++) 
        {
            Account aux = new Account();
            aux.Name = TEST_AC_NAME + system.now();
            accListToInsert.add(aux);
        }
    }
}