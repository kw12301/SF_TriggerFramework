trigger HttpResponseTrigger on HttpResponse__e (after insert) {
    TriggerFactory.createTriggerDispatcher(HttpResponse__e.SObjectType);
}