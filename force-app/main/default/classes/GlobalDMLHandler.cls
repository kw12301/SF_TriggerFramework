/**
* @author Kevin Winn
* @date May 17, 2022
* @group DML Framework
* @description global class for dml transactions.  Checks AccessControls for all CRUD operations.
*               Removes all inaccessible records and fields prior to performing DML.  Writes errors to LoggingHandler
*/

public with sharing class GlobalDMLHandler {

    /**
    * @description Insert object method.  All or nothing
    * @param Sobject the sObject to insert
    */
    public static void insertObject(Sobject sObj) {    
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
        try{
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,new List<SObject>{sobj});
            if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                insert controls.accessDecision.getRecords()[0];
            } 
        }catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Insert object method.  All or nothing
    * @param Sobject the sObject to insert
    * @param Boolean all or nothing indicator.  Submit as False to use Database.insert or True to use insert
    */
    public static void insertObject(Sobject sObj, Boolean allOrNothing) {
        if(allOrNothing){
            insertObject(sObj);
        }else{
            List<SObject> objects = new LIst<SObject>{sobj};
            String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,objects);
                if(!controls.invalidRequest && controls.SObjectAccess.isCreateable){
                    Database.SaveResult[] results = Database.insert(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processSaveResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Upsert object method.  All or nothing
    * @param Sobject the sObject to upsert
    */
    public static void upsertObject(Sobject sObj) {   
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null; 
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,new List<SObject>{sobj});
            if(!controls.invalidRequest && controls.sObjectAccess.isUpsertable){
                upsert controls.accessDecision.getRecords()[0];
            }
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Upsert object method
    * @param Sobject the sObject to upsert
    * @param Boolean all or nothing indicator.  Submit as False to use Database.upsert or True to use upsert
    */
    public static void upsertObject(Sobject sObj,Boolean allOrNothing) {
        if(allOrNothing){
            upsertObject(sObj);
        }else{
            List<SObject> objects = new LIst<SObject>{sobj};
            String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,objects);
                if(!controls.invalidRequest && controls.SObjectAccess.isUpsertable){
                    Database.UpsertResult[] results = Database.upsert(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processUpsertResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Update object method.  All or nothing
    * @param Sobject the sObject to update
    */
    public static void updateObject(Sobject sObj) {    
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null; 
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPDATABLE,objects);
            if(!controls.invalidRequest && controls.sObjectAccess.isUpdateable){
                update controls.accessDecision.getRecords()[0];
            }
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Update object method
    * @param Sobject the sObject to update
    * @param Boolean all or nothing indicator.  Submit as False to use Database.update or True to use update
    */
    public static void updateObject(Sobject sObj,Boolean allOrNothing) {
        if(allOrNothing){
            updateObject(sObj);
        }else{
            List<SObject> objects = new LIst<SObject>{sobj};
            String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPDATABLE,objects);
                if(!controls.invalidRequest && controls.SObjectAccess.isUpdateable){
                    Database.SaveResult[] results = Database.update(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processSaveResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Delete object method.  All or nothing
    * @param Sobject the sObject to delete
    */
    public static void deleteObject(Sobject sObj) {    
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
        try {
            AccessControls controls = AccessControls.getSObjectAccessControls(sobj);
            if(!controls.invalidRequest && controls.sObjectAccess.isDeleteable){
                delete sObj;
            }
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @description Delete object method
    * @param Sobject the sObject to delete
    * @param Boolean all or nothing indicator.  Submit as False to use Database.delete or True to use delete
    */
    public static void deleteObject(Sobject sObj,Boolean allOrNothing) {
        if(allOrNothing){
            deleteObject(sObj);
        }else {
            List<SObject> objects = new LIst<SObject>{sobj};
            String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
            try{
                AccessControls controls = AccessControls.getSObjectAccessControls(sobj);
                if(!controls.invalidRequest && controls.sObjectAccess.isDeleteable){
                    Database.DeleteResult[] results = Database.delete(objects,allOrNothing);
                    LoggingHandler.processDeleteResults(results,objectName);
                }
            }catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Undelete object method.  All or nothing
    * @param Sobject the sObject to undelete
    */
    public static void undeleteObject(Sobject sObj) {   
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,new List<SObject>{sobj});
            if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                undelete controls.accessDecision.getRecords()[0];
            }
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
            LoggingHandler.popAll();
        }  
    }

    /**
    * @description Undelete object method
    * @param Sobject the sObject to undelete
    * @param Boolean all or nothing indicator.  Submit as False to use Database.undelete or True to use undelete
    */
    public static void undeleteObject(Sobject sObj,Boolean allOrNothing) {
        if(allOrNothing){
            undeleteObject(sObj);
        }else {
            List<SObject> objects = new LIst<SObject>{sobj};
            String objectName = (null != objects && objects.size() > 0) ? SObjectUtility.getSObjectTypeName(sObj) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,objects);
                if(!controls.invalidRequest && controls.SObjectAccess.isCreateable){
                    Database.UndeleteResult[] results = Database.undelete(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processUndeleteResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Insert objects method.  All or nothing
    * @param List<Sobject> the sObjects to insert
    */
    public static void insertObjectList(List<Sobject> sObjList) {    
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,sObjList);
            if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                insert controls.accessDecision.getRecords();
            }
        } catch(Exception ex) {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null; 
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @description Insert list of objects method
    * @param List<Sobject> the sObject list to insert
    * @param Boolean all or nothing indicator.  Submit as False to use Database.insert or True to use insert
    */
    public static void insertObjectList(List<Sobject> sObjList,Boolean allOrNothing) {
        if(allOrNothing){
            insertObjectList(sObjList);
        }else{
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,sObjList);
                if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                    Database.SaveResult[] results = Database.insert(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processSaveResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Upsert objects method.  All or nothing
    * @param List<Sobject> the sObjects to upsert
    */
    public static void upsertObjectList(List<Sobject> sObjList) {    
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,sObjList);
            if(!controls.invalidRequest && controls.sObjectAccess.isUpsertable){
                upsert controls.accessDecision.getRecords();
            }
        } catch(Exception ex) {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null; 
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Upsert list of objects method
    * @param List<Sobject> the sObject list to upsert
    * @param Boolean all or nothing indicator.  Submit as False to use Database.upsert or True to use upsert
    */
    public static void upsertObjectList(List<Sobject> sObjList,Boolean allOrNothing) {
        if(allOrNothing){
            upsertObjectList(sObjList);
        }else{
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPSERTABLE,sObjList);
                if(!controls.invalidRequest && controls.sObjectAccess.isUpsertable){
                    Database.UpsertResult[] results = Database.upsert(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processUpsertResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Update objects method.  All or nothing
    * @param List<Sobject> the sObjects to update
    */
    public static void updateObjectList(List<Sobject> sObjList) {    
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPDATABLE,sObjList);
            if(!controls.invalidRequest && controls.sObjectAccess.isUpdateable){
                update controls.accessDecision.getRecords();
            }
        } catch(Exception ex) {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null; 
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Update list of objects method
    * @param List<Sobject> the sObject list to update
    * @param Boolean all or nothing indicator.  Submit as False to use Database.update or True to use update
    */
    public static void updateObjectList(List<Sobject> sObjList,Boolean allOrNothing) {
        if(allOrNothing){
            updateObjectList(sObjList);
        }else{
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.UPDATABLE,sObjList);
                if(!controls.invalidRequest && controls.sObjectAccess.isUpdateable){
                    Database.SaveResult[] results = Database.update(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processSaveResults(results,objectName);
                }
            } catch(Exception ex){
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION,objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Update objects method.  All or nothing
    * @param List<Sobject> the sObjects to delete
    */
    public static void deleteObjectList(List<Sobject> sObjList) {    
        try {
            AccessControls controls = AccessControls.getSObjectAccessControls(sObjList[0]);
            if(!controls.invalidRequest && controls.sObjectAccess.isDeleteable){
                delete sObjList;
            }
        } catch(Exception ex) {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null; 
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @description Delete list of objects method
    * @param List<Sobject> the sObject list to delete
    * @param Boolean all or nothing indicator.  Submit as False to use Database.delete or True to use delete
    */
    public static void deleteObjectList(List<Sobject> sObjList,Boolean allOrNothing) {
        if(allOrNothing){
            deleteObjectList(sObjList);
        }else {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null;
            try{
                AccessControls controls = AccessControls.getSObjectAccessControls(sobjList[0]);
                if(!controls.invalidRequest && controls.sObjectAccess.isDeleteable){
                    Database.DeleteResult[] results = Database.delete(sObjList,allOrNothing);
                    LoggingHandler.processDeleteResults(results,objectName);
                }
            } catch(Exception ex) {
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
                LoggingHandler.popAll();
            }
        }
    }

    /**
    * @description Undelete objects method.  All or nothing
    * @param List<Sobject> the sObjects to undelete
    */
    public static void undeleteObjectList(List<Sobject> sObjList) {    
        try {
            AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,sObjList);
            if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                undelete controls.accessDecision.getRecords();
            }
        } catch(Exception ex) {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null; 
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Undelete list of objects method
    * @param List<Sobject> the sObject list to undelete
    * @param Boolean all or nothing indicator.  Submit as False to use Database.undelete or True to use undelete
    */
    public static void undeleteObjectList(List<Sobject> sObjList,Boolean allOrNothing) {
        if(allOrNothing){
            undeleteObjectList(sObjList);
        }else {
            String objectName = (null != sObjList && sObjList.size() > 0) ? SObjectUtility.getSObjectTypeName(sObjList[0]) : null;
            try{
                AccessControls controls = AccessControls.removeAllInaccessible(System.AccessType.CREATABLE,sObjList);
                if(!controls.invalidRequest && controls.sObjectAccess.isCreateable){
                    Database.UndeleteResult[] results = Database.undelete(controls.accessDecision.getRecords(),allOrNothing);
                    LoggingHandler.processUndeleteResults(results,objectName);
                }
            }catch(Exception ex) {
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
                LoggingHandler.popAll();
            }
        }
    }
}