/**
* @author Addepar
* @date 2022
* @group API
* @description Build Endpoint URL from Endpoint and Connection Setting metadata
*/
public with sharing class EndpointBuilder {

    public String endpoint { get; set; }
    
    public EndpointBuilder(EndpointSetting__mdt eps) {
        this.endpoint = getEndpoint(eps);
    }

    private String getEndpoint(EndpointSetting__mdt eps){
        ConnectionSetting__mdt connection = new EndpointSettings().getConnectionSetting(eps.ConnectionSEtting__r.QualifiedAPIName);
        String url = eps.EndpointURL__c;
        url = replaceFirmVariable(eps,url,connection);
        url = replaceApiVersionVariable(eps,url,connection);
        System.debug(LoggingLevel.INFO,'URL After Build: ' + url);
        return url;
    }

    private String replaceFirmVariable(EndpointSetting__mdt eps,String url,ConnectionSetting__mdt connection){
        System.debug(LoggingLevel.INFO,'URL index of firm variable: ' + url.indexOf(eps.FirmUrlVariable__c));
        if(url.indexOf(eps.FirmUrlVariable__c) != -1){
            url = url.replace(eps.FirmUrlVariable__c, connection.FirmDomain__c);
        }
        return url;
    }

    private String replaceApiVersionVariable(EndpointSetting__mdt eps,String url,ConnectionSetting__mdt connection){
        System.debug(LoggingLevel.INFO,'URL index of Version variable: ' + url.indexOf(eps.ApiVersionVariable__c));
        if(url.indexOf(eps.ApiVersionVariable__c) != -1){
            url = url.replace(eps.ApiVersionVariable__c, connection.APIVersion__c);
        }
        return url;
    }
}