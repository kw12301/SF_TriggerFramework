/**
* @author Kevin Winn
* @date 12/31/2019
* @group Helpers
* @description contains methods to manage ContentDocument,ContentVersion, and Links
*/
public with sharing class ContentDocumentHelper {
    /**
     * @description method to insert or update a new ContentVersion
     * @param String the Title for the ContentDocument.  
     *                  This is the value used to find existing content documents of the same name.
     *                  Returns the ContentVersion Id
     * @param String the body of the content document that will be converted to a Blob value
     * @return Type: Id 
     */
	public static Id upsertContentVersion(String documentTitle,String contentBody) {
        ContentVersion version = new ContentVersion();
        documentTitle = null == documentTitle ? 'MetadataService':documentTitle;
        Blob body = Blob.valueOf(contentBody);

        try {
            version = [Select Id,VersionData,ContentDocumentId,PathOnClient
                        From ContentVersion 
                        Where ContentDocument.Title =: documentTitle
                        And IsLatest = true LImit 1];
        } catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'ContentVersion');
            LoggingHandler.popAll();
        }
        if(null == version.Id) {
            version.ContentLocation = 's';
            version.PathOnClient = documentTitle + '.txt';
            version.Title = documentTitle;
            version.Description = documentTitle + ' logged on ' + System.now();
            version.VersionData = body;
            insert version;
            return version.Id;
        } else {
            ContentVersion newVersion = new ContentVersion();
            newVersion.ContentDocumentId = version.ContentDocumentId;
            newVersion.Title = documentTitle;
            newVersion.PathOnClient = version.PathOnClient;
            newVersion.ReasonForChange = documentTitle + ' logged on ' + System.now();
            newVersion.VersionData = body;
            newVersion.IsMajorVersion = true;
            insert newVersion;
            return newVersion.Id;
        }
    }

    /**
     * @description method to associate a ContentVersion with a LinkedEntity
     * @param Id the Id of the ContentVersion
     * @param LinkedEntityId The Id for the SObject record to create a ContentDocumentLink for the ContentVersion
     */
    public static void manageContentDocumentLink(Id versionId,Id linkedEntityId) {
        Id contentDocId = [Select ContentDocumentId 
                            From ContentVersion 
                            Where Id =: versionId].ContentDocumentId;
        ContentDocumentLink cdl = new ContentDocumentLink();
        try{
          cdl = [Select Id,LinkedEntityId,ContentDocumentId 
                  From ContentDocumentLink 
                  WHere LinkedEntityId =: linkedEntityId 
                  And ContentDocumentId =: contentDocId
                  Limit 1];
        } catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'ContentDocumentLink');
            LoggingHandler.popAll();
        }
        if(null == cdl.ContentDocumentId) {
          cdl.LinkedEntityId = linkedEntityId;
          cdl.ContentDocumentId = contentDocId;
          cdl.shareType = 'V';
          insert cdl;
        }
    }
}