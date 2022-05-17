/**
* @author Kevin Winn
* @date 12/31/2019
* @group Helpers
* @description contains methods to manage ContentDocument,ContentVersion, and Links
*/

public with sharing class ContentDocumentHelper 
{
	public static Id upsertContentVersion(String documentTitle,String patchClass)
    {
        ContentVersion version = new ContentVersion();
        documentTitle = null == documentTitle ? 'MetadataService':documentTitle;
        Blob body = Blob.valueOf(patchClass);

        try
        {
            version = [Select Id,VersionData,ContentDocumentId,PathOnClient
                        From ContentVersion 
                        Where ContentDocument.Title =: documentTitle
                        And IsLatest = true LImit 1];
        }
        catch(Exception ex){}
        if(null == version.Id)
        {
            version.ContentLocation = 's';
            version.PathOnClient = documentTitle + '.txt';
            version.Title = documentTitle;
            version.Description = documentTitle + ' logged on ' + System.now();
            version.VersionData = body;
            insert version;
            return version.Id;
        }
        else
        {
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

    private static void manageContentDocumentLink(Id versionId,Id linkedEntityId)
    {
        Id contentDocId = [Select ContentDocumentId 
                            From ContentVersion 
                            Where Id =: versionId].ContentDocumentId;
        ContentDocumentLink cdl = new ContentDocumentLink();
        try
        {
          cdl = [Select Id,LinkedEntityId,ContentDocumentId 
                  From ContentDocumentLink 
                  WHere LinkedEntityId =: linkedEntityId 
                  And ContentDocumentId =: contentDocId
                  Limit 1];
        }
        catch(Exception ex){}
        if(null == cdl.ContentDocumentId)
        {
          cdl.LinkedEntityId = linkedEntityId;
          cdl.ContentDocumentId = contentDocId;
          cdl.shareType = 'V';
          insert cdl;
        }
    }
}