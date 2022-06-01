/**
* @author Addepar
* @date 2022
* @group API
* @description HTTP Server for making requests to Addepar APIs 
*/
public virtual class APIRequestHandler {

    public static Boolean isSuccessful;
    public static String status;
    public static String statusCode;
    public static List<String> headerKeys;

    @future(callout=true)
    public static void makeFutureCall(String epsQualifiedAPIName,String serializedJSONObject,String endpoint,String verb,String objectName){
        
        if(verb == 'GET'){
            HttpGet.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'POST'){
            HttpPost.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'PUT'){
            HttpPut.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'PATCH'){
            HttpPatch.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'DELETE'){
            HttpDelete.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else{
            LoggingHandler.debugException(
                new APIProcessing.APIProcessingException('Unexpected Verb for callout: ' + verb),
                StaticResources.SALESFORCE_EXCEPTION,
                objectName
            );
            LoggingHandler.popAll();
        }
    }

    public static void makeNormalCall(String epsQualifiedAPIName,String serializedJSONObject,String endpoint,String verb,String objectName){
        if(verb == 'GET'){
            HttpGet.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'POST'){
            HttpPost.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'PUT'){
            HttpPut.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'PATCH'){
            HttpPatch.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else if(verb == 'DELETE'){
            HttpDelete.data(epsQualifiedAPIName,serializedJSONObject,endpoint,objectName);
        } else{
            LoggingHandler.debugException(
                new APIProcessing.APIProcessingException('Unexpected Verb for callout: ' + verb),
                StaticResources.SALESFORCE_EXCEPTION,
                objectName
            );
            LoggingHandler.popAll();
        }
    }
    
    public static Boolean tokenIsActive(){
        return true;
    }
}