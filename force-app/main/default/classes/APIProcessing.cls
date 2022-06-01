/**
* @author Addepar
* @date 2022
* @group API
* @description Contains methods to make callouts to Addepar APIs 
*/
public with sharing class APIProcessing {

    /**
    *@description a map of endpoint settings metadata keyed to their qualified API names
    *@return Type: Map<String,EndpointSetting__mdt>
     */
    public Map<String,EndpointSetting__mdt> dictionary = new EndpointSettings().dictionary;

    /**
    *@description execute callout to GET all Entity Types
     */
    public void getEntityTypesForOrg(){
        if(!requestState().containsKey(true)){
            LogException(requestState().get(false),'Entity_Types');
        }else{
            EndpointSetting__mdt settings = dictionary.get('GET_All_Entity_Types');
            String endpoint = new EndpointBuilder(settings).endpoint;
            if(!SystemInfo.isAsync()){
                APIRequestHandler.makeFutureCall(settings.QualifiedAPIName, null, endpoint, settings.HttpVerb__c, 'Entity_Types');
            } else{
                APIRequestHandler.makeNormalCall(settings.QualifiedAPIName, null, endpoint, settings.HttpVerb__c, 'Entity_Types');
            }
        }
    }

    /**
    *@description execute callout to GET all attributes
     */
    public void getAllAttributesForOrg(){
        if(!requestState().containsKey(true)){
            LogException(requestState().get(false),'Attributes');
        }else{
            EndpointSetting__mdt settings = dictionary.get('GET_All_Attributes');
            String endpoint = new EndpointBuilder(settings).endpoint;
            if(!SystemInfo.isAsync()){
                APIRequestHandler.makeFutureCall(settings.QualifiedAPIName, null, endpoint, settings.HttpVerb__c, 'Attributes');
            } else{
                APIRequestHandler.makeNormalCall(settings.QualifiedAPIName, null, endpoint, settings.HttpVerb__c, 'Attributes');
            }
        }
    }

    private void LogException(APIProcessingException ex,String objectName){
        LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
        LoggingHandler.popAll();
    }

    private Map<Boolean,APIProcessingException> requestState(){
        Map<Boolean,APIProcessingException> results = new Map<Boolean,APIProcessingException>();
        if(SystemInfo.isReadOnly()){
            results.put(false,new APIProcessingException('System in Read Only Mode.  Callouts not allowed'));
        } else if(SystemInfo.useOfCallouts() >= 0.99){
            results.put(false,new APIProcessingException('Too many callouts: ' + String.valueOf(SystemInfo.useOfCallouts())));
        } else if(SystemInfo.useOfCpuTime() > 0.99){
            results.put(false,new APIProcessingException('Exceeded CPU Limits: ' + String.valueOf(SystemInfo.useOfCpuTime())));
        } else{
            results.put(true,new APIProcessingException());
        }
        return results;
    }

    public class APIProcessingException extends Exception {}
}