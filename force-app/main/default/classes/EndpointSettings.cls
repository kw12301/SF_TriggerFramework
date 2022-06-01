/**
* @author Addepar
* @date 2022
* @group API
* @description Contains methods to gather endpoint settings by connection setting
*/
public with sharing class EndpointSettings {

    public Map<String,EndpointSetting__mdt> dictionary { get; set; }
    public Map<String,ConnectionSetting__mdt> connectionMap { get; set; }
    public EndpointSettings(){
        this.dictionary = getDictionary();
        this.connectionMap = getConnectionMap();
    }
    private Map<String,EndpointSetting__mdt> getDictionary(){
        Map<String,EndpointSetting__mdt> results = new Map<String,EndpointSetting__mdt>();
        for(EndpointSetting__mdt eps : MetadataQuery.getEndpointSettings()){
            results.put(eps.QualifiedAPIName,eps);
            
        }
        return results;
    }

    private Map<String,ConnectionSetting__mdt> getConnectionMap(){
        Map<String,ConnectionSetting__mdt> results = new Map<String,ConnectionSetting__mdt> ();
        for(ConnectionSetting__mdt cs : MetadataQuery.getConnectionSettings()){
            results.put(cs.QualifiedAPIName,cs);
        }
        return results;
    }

    public EndpointSetting__mdt getEndpointSetting(String qualifiedAPIName){
        return dictionary.get(qualifiedAPIName);
    }

    public ConnectionSetting__mdt getConnectionSetting(String qualifiedAPIName){
        return connectionMap.get(qualifiedAPIName);
    }

    public ConnectionSetting__mdt getConnectionSetting(EndpointSetting__mdt eps){
        return getConnectionSetting(eps.QualifiedAPIName);
    }
}