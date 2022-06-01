AccessControls allControls = AccessControls.removeAllInaccessible(System.AccessType.READABLE,[Select Id From FinServ__FinancialAccount__c]);
System.debug('All Controls ' + '\n' + JSON.serializePretty(allControls));

AccessControls allControls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,Database.query(SObjectUtility.selectAllFields('FinServ__FinancialAccount__c')));
System.debug('All Controls ' + '\n' + JSON.serializePretty(allControls));

AccessControls allControls = AccessControls.removeAllInaccessible(System.AccessType.UPDATABLE,Database.query(SObjectUtility.selectAllFields('FinServ__FinancialAccount__c')));
System.debug('All Controls ' + '\n' + JSON.serializePretty(allControls));

AccessControls allControls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,Database.query(SObjectUtility.selectAllFields('FinServ__FinancialAccount__c')));
System.debug('All Controls ' + '\n' + JSON.serializePretty(allControls));

AccessControls allControls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,Database.query(SObjectUtility.selectAllFields('Task')));
System.debug('All Controls ' + '\n' + JSON.serializePretty(allControls));
