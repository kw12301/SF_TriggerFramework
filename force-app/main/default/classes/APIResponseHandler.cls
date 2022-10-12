/**
* @author Addepar
* @date 2022
* @group API
* @description Contains methods to route responses to appropriate handlers
*/
public with sharing class APIResponseHandler {
    
    public static void routeResponse(String jsonBody,String epsQualifiedAPIName){
        System.debug(LoggingLevel.INFO,'CPU begin route response ' + Limits.getCpuTime());
        if(epsQualifiedAPIName.toLowerCase() == 'get_all_entity_types'){
            ParseEntityTypes parser = ParseEntityTypes.parse(jsonBody);
            AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ENTITY_TYPES_FILE, JSON.serializePretty(parser), DocumentWriter.FileType.TEXT);
        } else if(epsQualifiedAPIName.toLowerCase() == 'get_all_attributes'){
            ParseAllAttributes parser = ParseAllAttributes.parse(jsonBody);
            AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ALL_ATTRIBUTES_FILE, JSON.serializePretty(parser), DocumentWriter.FileType.TEXT);
        } else if(epsQualifiedAPIName.toLowerCase() == 'get_all_arguments'){
            ParseAllArguments parser = ParseAllArguments.parse(jsonBody);
            AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ALL_ARGUMENTS_FILE, JSON.serializePretty(parser), DocumentWriter.FileType.TEXT);
        }
        System.debug(LoggingLevel.INFO,'CPU end route response ' + Limits.getCpuTime());
    }
}