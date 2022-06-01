/**
* @author Addepar
* @date 2022
* @group API
* @description Contains methods to route responses to appropriate handlers
*/
public with sharing class APIResponseHandler {
    
    public static void routeResponse(String jsonBody,String epsQualifiedAPIName){
        if(epsQualifiedAPIName.toLowerCase() == 'get_all_entity_types'){
            ParseEntityTypes parser = ParseEntityTypes.parse(jsonBody);
            AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ENTITY_TYPES_FILE, JSON.serializePretty(parser), DocumentWriter.FileType.TEXT);
        } else if(epsQualifiedAPIName.toLowerCase() == 'get_all_attributes'){
            ParseAllAttributes parser = ParseAllAttributes.parse(jsonBody);
            AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ALL_ATTRIBUTES_FILE, JSON.serializePretty(parser), DocumentWriter.FileType.TEXT);
        }
    }
}