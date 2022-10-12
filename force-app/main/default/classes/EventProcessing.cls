/**
* @author Addepar
* @date 2022
* @group Event Bus
* @description Methods to publish platform events
*/
public with sharing class EventProcessing {
    
    public static void publishHttpResponseEvent(HttpResponse response,String epsQualifiedAPIName){
        AccessControls controls = AccessControls.getSObjectAccessControls(SObjectUtility.getSObjectForName('HttpResponse__e'));
        if(controls.invalidRequest || !controls.sObjectAccess.isCreateable){
            throwNoAccessException('HttpResponse__e');
        }else{
            HttpResponse__e results = new HttpResponse__e();
            results.Status__c = response.getStatus();
            results.StatusCode__c = String.valueOf(response.getStatusCode());
            results.IsSuccess__c = response.getStatusCode() == 200 ? true : false;
            results.EndpointSetting__c = epsQualifiedAPIName.indexOf('_') != -1 ? epsQualifiedAPIName.replaceAll('_',' ') : epsQualifiedAPIName;
            handleSaveResult(EventBus.publish(results),'HttpResponse__e');
        }
    }

    public static void publishErrorEvent(List<ErrorLog__c> newList){
        AccessControls controls = AccessControls.getSObjectAccessControls(SObjectUtility.getSObjectForName('ErrorEvent__e'));
        if(newList.isEmpty() || controls.invalidRequest || !controls.sObjectAccess.isCreateable){
            throwNoAccessException('ErrorEvent__e');
        }else if(newList.size() == 1){
           handleSaveResult(EventBus.publish(constructErrorEvent(newList[0],1,null)),'ErrorEvent__e'); 
        }else{
            String msg = 'Many errors occurred.  Category and Type reported are for the first error.  Please review Error Logs';
            handleSaveResult(EventBus.publish(constructErrorEvent(newList[0],newList.size(),msg)),'ErrorEvent__e');
        }
    }

    private static ErrorEvent__e constructErrorEvent(ErrorLog__c error,Integer totalErrors,String errorMessage){
        ErrorEvent__e evt = new ErrorEvent__e();
        evt.Id__c = error.Id;
        evt.Message__c = null == errorMessage ? error.Message__c : errorMessage;
        evt.TotalErrors__c = totalErrors;
        evt.Category__c = error.ErrorType__c;
        evt.Type__c = error.ErrorSubtype__c;
        return evt;
    }

    private static void throwNoAccessException(String eventName){
        LoggingHandler.debugException(new EventProcessingException('Invalid request or No access to event type'), StaticResources.EVENT_BUS_EXCEPTION, eventName);
        LoggingHandler.popAll();
    }


    private static void handleSaveResult(Database.SaveResult saveResult,String eventName){
        if(!saveResult.isSuccess()){
            String msgBody = '';
            for(Database.Error err : saveResult.getErrors()){
                msgBody = msgBody + err.getMessage() + '\n';
            }
            LoggingHandler.debugException(new EventProcessingException(msgBody), StaticResources.EVENT_BUS_EXCEPTION, eventName);
            LoggingHandler.popAll();
        }
    }

    public class EventProcessingException extends Exception{}
}