/**
* @author Kevin Winn
* @date 2022
* @group Logging
* @description Create a ContentDocumentLink for a ContentVersion
*  
*/
public with sharing class DocumentLinker {
    
    /**
     * @description method to associate a ContentVersion with a LinkedEntity
     * @param Id the Id of the ContentVersion
     * @param LinkedEntityId The Id for the SObject record to create a ContentDocumentLink for the ContentVersion
     */
    public static void manageContentDocumentLink(Id versionId,Id linkedEntityId) {
        System.debug(LoggingLevel.INFO,'CPU begin manageContentDocumentLink() ' + Limits.getCpuTime()); 
        AccessControls controls = AccessControls.getSObjectAccessControls(SObjectUtility.getSObjectForName('ContentDocumentLink'));
        if(null == SObjectUtility.validateId(versionId) || null == SObjectUtility.validateId(linkedEntityId)){
            LoggingHandler.debugException(new DocumentLinkerException('Invalid Id'), StaticResources.SALESFORCE_EXCEPTION, 'ContentDocumentLink');
            LoggingHandler.popAll();
        } else if(controls.invalidRequest || !controls.sObjectAccess.isCreateable){
            LoggingHandler.debugException(new DocumentLinkerException('No Access to ContentDocumentLink'),StaticResources.NO_ACCESS_EXCEPTION,'ContentDocumentLink');
            LoggingHandler.popAll();
        } else{
            Id contentDocId = getContentDocumentId(versionId);
            ContentDocumentLink cdl = getExistingContentDocumentlink(linkedEntityId, contentDocId);
            if(null != contentDocId && null == cdl.Id){
                cdl.LinkedEntityId = linkedEntityId;
                cdl.ContentDocumentId = contentDocId;
                //cdl.shareType = 'V'; commented out for posting to Library instead of record.
                GlobalDMLHandler.insertObject(cdl);
            }
        }
        System.debug(LoggingLevel.INFO,'CPU end manageContentDocumentLink() ' + Limits.getCpuTime()); 
    }

    /**
     * @description private helper method retrieve the ContentDocumentId from the ContentVersion
     * @param Id the Id of the ContentVersion
     * @return Type: Id
     */
    private static Id getContentDocumentId(Id versionId){
        Id contentDocId;
        try{
            contentDocId = [Select ContentDocumentId From ContentVersion Where Id =: versionId].ContentDocumentId;
        } catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.QUERY_EXCEPTION, 'ContentDocument');
            LoggingHandler.popAll();
        }
        return contentDocId;
    }

     /**
     * @description private helper method to try and retrieve an existing ContentDocumentLink
     *              that matches the same link this class is trying to create.
     * @param Id the Id for the Linked Entity
     * @param Id the Id for the ContentDocument
     * @return Type: ContentDocumentLink
     */
    private static ContentDocumentLink getExistingContentDocumentlink(Id linkedEntityId,Id contentDocId){
        ContentDocumentLink cdl = new ContentDocumentLink();
        try{
            cdl = [Select Id,LinkedEntityId,ContentDocumentId From ContentDocumentLink WHere LinkedEntityId =: linkedEntityId And ContentDocumentId =: contentDocId Limit 1];
        }catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.QUERY_EXCEPTION, 'ContentDocumentLink');
            LoggingHandler.popAll();
        }
        return cdl;
    }

    /**
     * @description Custom Exception class for DocumentLinker
     */
    public class DocumentLinkerException extends Exception{

    }
}