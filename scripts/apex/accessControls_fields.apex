AccessControls fieldControls = AccessControls.removeInaccessibleFields(System.AccessType.READABLE,[Select Id From FinServ__FinancialAccount__c]);
System.debug('Field Controls ' + '\n' + JSON.serializePretty(fieldControls));

try{
    AccessControls fieldControls = AccessControls.removeInaccessibleFields(System.AccessType.READABLE,Database.query(SObjectUtility.selectAllFields('Task')));
    System.debug('Field Controls ' + '\n' + JSON.serializePretty(fieldControls));
} catch(Exception ex){
    LoggingHandler.debugException(ex, 'Query exception', 'Task');
    LoggingHandler.popAll();
}







