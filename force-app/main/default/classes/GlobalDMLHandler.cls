/**
* @author Kevin Winn
* @date May 17, 2022
* @group Framework
* @description global class for dml transactions.  Writes errors to LoggingHandler
*/

public with sharing class GlobalDMLHandler {
    /**
    * @description Insert object method
    * @param Sobject the sObject to insert
    */
    public static void insertObject(Sobject sObj) {
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? String.valueOf(objects[0].getSObjectType()) : null;
        try {
            Database.SaveResult[] results = Database.insert(objects,false);
            LoggingHandler.processSaveResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Upsert object method
    * @param Sobject the sObject to upsert
    */
    public static void upsertObject(Sobject sObj) {
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? String.valueOf(objects[0].getSObjectType()) : null;
        try {
            Database.UpsertResult[] results = Database.upsert(objects,false);
            LoggingHandler.processUpsertResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Update object method
    * @param Sobject the sObject to update
    */
    public static void updateObject(Sobject sObj) {
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? String.valueOf(objects[0].getSObjectType()) : null;
        try {
            Database.SaveResult[] results = Database.update(objects,false);
            LoggingHandler.processSaveResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @author Kevin Winn
    * @date May 17, 2022
    * @description Delete object method
    * @param Sobject the sObject to delete
    */
    public static void deleteObject(Sobject sObj) {
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? String.valueOf(objects[0].getSObjectType()) : null;   
        try {
            Database.DeleteResult[] results = Database.delete(objects,false);
            LoggingHandler.processDeleteResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @author Kevin Winn
    * @date May 17, 2022
    * @description Delete object method
    * @param Sobject the sObject to delete
    */
    public static void undeleteObject(Sobject sObj) {
        List<SObject> objects = new LIst<SObject>{sobj};
        String objectName = (null != objects && objects.size() > 0) ? String.valueOf(objects[0].getSObjectType()) : null;
        try {
            Database.UnDeleteResult[] results = Database.undelete(objects,false);
            LoggingHandler.processUnDeleteResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @description Insert list of objects method
    * @param List<Sobject> the sObject list to insert
    */
    public static void insertObjectList(List<Sobject> sObjList) {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;    
        try {
            Database.SaveResult[] results = Database.insert(sObjList,false);
            LoggingHandler.processSaveResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObjList[0].getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Upsert list of objects method
    * @param List<Sobject> the sObject list to upsert
    */
    public static void upsertObjectList(List<Sobject> sObjList) {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try {
            Database.UpsertResult[] results = Database.upsert(sObjList,false);
            LoggingHandler.processUpsertResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObjList[0].getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Update list of objects method
    * @param List<Sobject> the sObject list to update
    */
    public static void updateObjectList(List<Sobject> sObjList) {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try {
            Database.SaveResult[] results = Database.update(sObjList,false);
            LoggingHandler.processSaveResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObjList[0].getSObjectType()));
            LoggingHandler.popAll();
        }
    }
    
    /**
    * @description Delete list of objects method
    * @param List<Sobject> the sObject list to delete
    */
    public static void deleteObjectList(List<Sobject> sObjList) {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try {
            Database.DeleteResult[] results = Database.delete(sObjList,false);
            LoggingHandler.processDeleteResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObjList[0].getSObjectType()));
            LoggingHandler.popAll();
        }
    }

    /**
    * @description Undelete list of objects method
    * @param List<Sobject> the sObject list to undelete
    */
    public static void undeleteObjectList(List<Sobject> sObjList) {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try {
            Database.UnDeleteResult[] results = Database.undelete(sObjList,false);
            LoggingHandler.processUnDeleteResults(results,objectName);
        } catch(Exception ex) {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObjList[0].getSObjectType()));
            LoggingHandler.popAll();
        }
    }
}