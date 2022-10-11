/**
* @author Kevin Winn
* @date 2022
* @group Logging
* @description contains methods to manage ContentDocument,ContentVersion, and Content Document Links for Salesforce Files
*/
public with sharing class DocumentWriter {

    /**
     * @description An enumuration of supported file types 
     *      CSV,EXCEL,PDF,PNG,TEXT,WORD,ZIP
     */
    public Enum FileType {CSV,EXCEL,PDF,PNG,TEXT,WORD,ZIP} //excluding LINK and UNKNOWN for now

    /**
     * @description method to insert or update the ContentVersion for a ContentDocument
     * @param String the Title for the ContentDocument.  
     *                  This is the value used to find existing content documents of the same name.
     * @param Blob the blob value for the body of the document
     * @param DocumentWriter.FileType the enum for the file type
     * @return Type: Id 
     * @example ContentDocumentHelper.upsertContentVersion('My Doc Title',Blob.valueOf(JSON.serializePretty(new Account())),DocumentWriter.FileType.PDF);
     */
	public static Id upsertContentVersion(String documentTitle,Blob contentBody,DocumentWriter.FileType fileType) {
        System.debug(LoggingLevel.INFO,'CPU begin upsertContentVersion() ' + Limits.getCpuTime()); 
        AccessControls controls = AccessControls.getSObjectAccessControls(SObjectUtility.getSobjectForName('ContentVersion'));
        Id versionId;
        if(!DocumentHelper.fileSizeCheck(Long.valueOf(String.valueOf(contentBody.size())))){
            LoggingHandler.debugException(new FileSizeException('File too large for DocumentWriter'), StaticResources.SALESFORCE_EXCEPTION,'ContentVersion');
            LoggingHandler.popAll();
        } else if(controls.invalidRequest || !controls.sObjectAccess.isCreateable || !controls.sObjectAccess.isUpdateable){
            LoggingHandler.debugException(new DocumentWriterException('Access Control Exception'), StaticResources.NO_ACCESS_EXCEPTION,'ContentVersion');
            LoggingHandler.popAll();
        } else{
            ContentVersion version = getContentVersion(documentTitle);
            if(null == version.Id){
                versionId = handleNewVersion(version,contentBody,fileType);
            } else{
                versionId = handleExistingVersion(version,contentBody,fileType);
            }
        }
        System.debug(LoggingLevel.INFO,'CPU end upsertContentVersion() ' + Limits.getCpuTime()); 
        return versionId;
    }

    /**
     * @description private helper method to try to get an existing ContentVersion or instantiate a new instance based on the DocumentTitle
     * @param String the Title for the ContentDocument.  This is the value used to find existing content documents of the same name.
     * @return Type: ContentVersion 
     * @example DocumentWriter.getContentVersion('My cool title');
     */
    public static ContentVersion getContentVersion(String documentTitle){
        documentTitle = null == documentTitle ? String.valueOf(System.now()) : documentTitle.length() >= 250 ? documentTitle.left(250) : documentTitle;
        ContentVersion version = new ContentVersion();
        version.Title = documentTitle;
        try {     
            version = [Select Id,VersionData,ContentDocumentId,PathOnClient,Title
                        From ContentVersion 
                        Where ContentDocument.Title =: documentTitle
                        And IsLatest = true LImit 1];
        } catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'ContentVersion');
            LoggingHandler.popAll();
        }
        return version;
    }

    /**
     * @description private helper method to insert a new ContentVersion
     * @param ContentVersion The ContentVersion to insert
     * @param Blob the VersionData for the ContentVersion
     * @param DocumentWriter.FileType the enum for the file type
     * @return Type: Id 
     * @example DocumentWriter.handleNewVersion(ContentVersion,Blob,DocumentWriter.FileType);
     */
    private static Id handleNewVersion(ContentVersion version,Blob contentBody,DocumentWriter.FileType fileTYpe){
        version.ContentLocation = 's';
        version.PathOnClient = String.valueOf(version.Title + DocumentHelper.getExtension(fileType));
        version.Description = 'First version created by ' + UserInfo.getUserName();
        version.VersionData = contentBody;
        insert version; //PMD false flag.  Permissions are checked in public method that calls this method.
        return version.Id;
    }

    /**
     * @description private helper method to upsert a new ContentVersion
     * @param ContentVersion The ContentVersion to upsert
     * @param Blob the VersionData for the ContentVersion
     * @param DocumentWriter.FileType the enum for the file type
     * @return Type: Id 
     * @example DocumentWriter.handleExistingVersion(ContentVersion,Blob,DocumentWriter.FileType);
     */
    private static Id handleExistingVersion(ContentVersion version,Blob contentBody,DocumentWriter.FileType fileTYpe){
        ContentVersion newVersion = new ContentVersion();
        newVersion.ContentDocumentId = version.ContentDocumentId;
        newVersion.Title = version.Title;
        newVersion.PathOnClient = version.PathOnClient;
        newVersion.ReasonForChange = 'Updated by ' + UserInfo.getUserName();
        newVersion.VersionData = contentBody;
        newVersion.IsMajorVersion = true;
        insert newVersion; //PMD false flag.  Permissions are checked in public method that calls this method.
        return newVersion.Id;
    }

    /**
     * @description Custom Exception class for DocumentWriter
     */
    public virtual class DocumentWriterException extends Exception{

    }

    /**
     * @description Custom Exception class for File Size Exceptions.  
     *      Extends DocumentWriterException. 
     *      See DocumentHelper.fileSizeCheck()
     */
    public class FileSizeException extends DocumentWriterException{

    }
}