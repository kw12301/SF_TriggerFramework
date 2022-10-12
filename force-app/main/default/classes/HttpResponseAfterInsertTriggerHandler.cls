/**
* @author Kevin Winn
* @date May 17, 2022
* @group Trigger Handlers
* @description after insert trigger handler for object 
*/
public with sharing class HttpResponseAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        process((List<HttpResponse__e>)tp.newList);
    }

    private void process(List<HttpResponse__e> newlist)	{
        getSerializedHttpResponses(newList);
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSerializedHttpResponses(List<HttpResponse__e> newList){
        List<String> results = new List<String>();
        for(HttpResponse__e r : newList){
            results.add(JSON.serializePretty(r));
        }
        return results;
    }
}