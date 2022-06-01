/**
* @author Addepar
* @date 2022
* @group Configuration Files
* @description Contains methods to write Addepar configuration files to the Addepar Library
*/
public with sharing class AddeparLibraryHandler {
    
    /**
    *@description Get/Set the Addepar Library Id
     */
    public Id libraryId { public get; private set; }

    /**
    *@description Constructor for class.  Calls getAddeparLibraryId method
     */
    public AddeparLibraryHandler(){
        this.libraryId = getAddeparLibaryId();
    }

    /**
    *@description write the serialized Apex Object from a response to a configuration file.  
    *@param String The document title. Use file names from StaticResources.cls when posting
    *@param String the serialized Apex object representing the response body from a callout
    *@param DocumentWriter.FileType the enum for the file type extension for this file.
    *@example AddeparLibraryHandler.writeFileToLibrary(StaticResources.ADDEPAR_ENTITY_TYPES_FILE, JSON.serializePretty(ParseEntityTypes), DocumentWriter.FileType.TEXT);
     */
    public static void writeFileToLibrary(String title,String jsonBody,DocumentWriter.FileType fileTypeEnum){
        Id docId = DocumentWriter.upsertContentVersion(title, Blob.valueOf(jsonBody),fileTypeEnum);
        if(null != SObjectUtility.validateId(docId)){
            Id addepar = new AddeparLibraryHandler().libraryId;
            DocumentLinker.manageContentDocumentLink(docId, addepar);
        }
    }
    /**
    *@description method to return JSON represention of ContentVersion.ContentBody for the given title
    *@param String the document title. Use file names from StaticResources.cls when querying
    *@return Type: String
     */
    public static String getserializedFileFromLibrary(String title){
        String results;
        ContentVersion version = DocumentWriter.getContentVersion(title);
        if(null == version.Id || null == version.ContentBody){
            LoggingHandler.debugException(new AddeparLibraryHandlerException('No file or data found for name: ' + title),StaticResources.QUERY_EXCEPTION,'ContentVersion');
            LoggingHandler.popAll();
        }else{
            results = JSON.serializePretty(String.valueOf(version.ContentBody));
        }
        return results;
    }

    /**
     * @description method to get the Id for the Addepar Library
     * @return Type: Id
     */
    public Id getAddeparLibaryId(){
        AccessControls controls = AccessControls.getSObjectAccessControls(SObjectUtility.getSObjectForName('ContentWorkspace'));
        Id libraryId = null;
        if(controls.invalidRequest || !controls.sObjectAccess.isCreateable || !controls.sObjectAccess.isUpdateable){
            LoggingHandler.debugException(new AddeparLibraryHandlerException('No Access to ContentWorkspace'), StaticResources.SALESFORCE_EXCEPTION, 'ContentWorkspace');
            LoggingHandler.popAll();
        }else{
            ContentWorkspace workspace = new ContentWorkspace();
            try{
                for(ContentWorkspace ws : [Select Id, RootContentFolderId From ContentWorkspace Where Name =: StaticResources.ADDEPAR_LIBRARY_NAME Limit 1]){
                    if(null != ws.Id){
                        libraryId = ws.Id;
                    } else{
                        libraryId = setAddeparLibraryId();
                    }
                }
            }catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.QUERY_EXCEPTION, 'ContentWorkspace');
                LoggingHandler.popAll();
            }
        }
        return libraryId;
    }

    /**
     * @description method to set the Id for the Addepar Library
     * @return Type: Id
     */
    private Id setAddeparLibraryId(){
        Id wsId = null;
        ContentWorkspace ws = new ContentWorkspace();
        ws.Description = 'Addepar files for integration';
        ws.Name = StaticResources.ADDEPAR_LIBRARY_NAME;
        ws.DeveloperName = StaticResources.ADDEPAR_LIBRARY_NAME;
        try{
            insert ws;
        }catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'ContentWorkspace');
            LoggingHandler.popAll();
        }finally{
            if(null != ws.Id){
                wsId = ws.Id;
            }
        }
        return wsId;
    }

    public class AddeparLibraryHandlerException extends Exception{}
}
