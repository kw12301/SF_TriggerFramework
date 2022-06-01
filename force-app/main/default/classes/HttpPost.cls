/**
* @author Addepar
* @date 2022
* @group API
* @description methods to  handle POST callouts to Addepar APIs
*/
public with sharing class HttpPost extends APIRequestHandler {
    
    public static void data(String epsQualifiedAPIName, String serializedJSONObject,String endpoint,String objectName){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        if(!ApiRequestHandler.tokenIsActive()){
            //do auth
        }else{
            try{
                request = setRequest(endpoint,60000,serializedJSONObject);
                if(!Test.isRunningTest()){
                    response = new Http().send(request);
                } else{
                    //TO DO:  Implement Callout mocks
                }
                handleResponse(response,epsQualifiedAPIName);
            }catch(Exception ex){
                LoggingHandler.debugException(ex,StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    private static HttpRequest setRequest(String endpoint,Integer timeout,String serializedJSONObject){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Authorization:',' Bearer '); //TO DO:  BUILD AUTH HEADER
        request.setHeader('ContentType:',' JSON'); //TO DO:  BUILD CONTENT TYPE HEADER
        request.setMethod('POST');
        request.setTimeout(timeout);
        if(null == serializedJSONObject){
            return request;
        }else{
            request.setBody(serializedJSONObject);
            return request;
        }    
    }

    private static void handleResponse(HttpResponse response,String epsQualifiedAPIName){
        if(response.getStatusCode() == 200){
            APIResponseHandler.routeResponse(response.getBody(),epsQualifiedAPIName);
        }else{
            //TO DO:  IMPLEMENT EXCEPTION HANDLING
        }
    }
}