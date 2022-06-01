/**
* @author Addepar
* @date 2022
* @group API
* @description contains methods to construct the appropriate headers for an endpoint
* 
*/
public with sharing class HttpHeaders {

    public static final String NOT_REQUIRED = 'NOT_REQUIRED';
    
    public static HttpRequest buildAddeparHeaders(HttpRequest request,String epsQualifiedAPIName){
        EndpointSetting__mdt eps = new EndpointSettings().getEndpointSetting(epsQualifiedAPIName);
        ConnectionSetting__mdt connection = new EndpointSettings().getConnectionSetting(eps.ConnectionSetting__r.QualifiedAPIName);
        if(null == eps.QualifiedAPIName || eps.QualifiedAPIName != epsQualifiedAPIName){
            //TO DO:  Implement exception handling
        }else{
            
            request.setHeader('Addepar-Firm',String.valueOf(connection.FirmId__c));
            request.setHeader('Authorization','Basic ' + buildAuthVal(connection));
            if(eps.ContentType__c != NOT_REQUIRED){
                request.setHeader('Content-Type',eps.ContentType__c);
            }
        }
        return request;
    }

    public static HttpRequest buildFigiHeaders(HttpRequest request){
        return request;
    }

    private static String buildAuthVal(ConnectionSetting__mdt connection){
        String authVal = String.valueOf(connection.APIKey__c + ':' + connection.APISecret__c);
        authVal = EncodingUtil.base64Encode(blob.valueOf(authVal));
        return authVal;
    }
}