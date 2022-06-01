/**
* @author Addepar
* @date 2022
* @group API
* @description methods to handle GET callouts to Addepar APIs 
*/
public with sharing class HttpGet extends APIRequestHandler {
    
    public static void data(String epsQualifiedAPIName, String serializedJSONObject,String endpoint,String objectName){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        if(!ApiRequestHandler.tokenIsActive()){
            //TO DO: do auth
        }else{
            try{
                request = setRequest(epsQualifiedAPIName,endpoint,60000,serializedJSONObject);
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

    private static HttpRequest setRequest(String epsQualifiedAPIName, String endpoint,Integer timeout,String serializedJSONObject){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request = HttpHeaders.buildAddeparHeaders(request, epsQualifiedAPIName);
        request.setMethod('GET');
        request.setTimeout(timeout);
        if(null == serializedJSONObject){
            return request;
        }else{
            request.setBody(serializedJSONObject);
            return request;
        }    
    }

    private static void handleResponse(HttpResponse response,String epsQualifiedAPIName){
        EventProcessing.publishHttpResponseEvent(response,epsQualifiedAPIName);
        if(response.getStatusCode() == 200){
            APIResponseHandler.routeResponse(response.getBody(),epsQualifiedAPIName);
        }else{
            LoggingHandler.debugException(new HttpGetException(String.valueOf(response.getStatus())), StaticResources.INTEGRATION_EXCEPTION, epsQualifiedAPIName);
            LoggingHandler.popAll();
        }
    }

    public class HttpGetException extends Exception{}
}