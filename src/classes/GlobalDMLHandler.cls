/**
* @author Kevin Winn
* @date 12/31/2019
* @group Trigger Framework
* @description global class for dml transactions
**/

public with sharing class GlobalDMLHandler 
{
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Insert object method
    * @param sObj the sObject to insert
    */
    public static void insertObject(Sobject sObj) 
    {
        try 
        {
            insert sObj;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Upsert object method
    * @param sObj the sObject to upsert
    */
    public static void upsertObject(Sobject sObj) 
    {
        try 
        {
            upsert sObj;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Update object method
    * @param sObj the sObject to update
    */
    public static void updateObject(Sobject sObj) 
    {
        try 
        {
            update sObj;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
        }
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Delete object method
    * @param sObj the sObject to delete
    */
    public static void deleteObject(Sobject sObj) 
    {
        try 
        {
            delete sObj;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Delete object method
    * @param sObj the sObject to delete
    */
    public static void undeleteObject(Sobject sObj) 
    {
        try 
        {
            undelete sObj;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, String.valueOf(sObj.getSObjectType()));
        }
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Insert list of objects method
    * @param sObjList the sObject list to insert
    */
    public static void insertObjectList(List<Sobject> sObjList) 
    {
        insertObjectList(sObjList,true);
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Insert list of objects method
    * @param sObjList the sObject list to insert
    */
    public static void insertObjectList(List<Sobject> sObjList,Boolean allOrNothing) 
    {
        if(allOrNothing)
        {
            try 
            {
                insert sObjList;
            } 
            catch(Exception ex) 
            {
                String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            }
        }
        else
        {
            LoggingHandler.processDatabaseSaveResults(Database.insert(SObjList,false));
        }
            
    }



    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Upsert list of objects method
    * @param sObjList the sObject list to upsert
    */
    public static void upsertObjectList(List<Sobject> sObjList) 
    {
        upsertObjectList(sObjList,true);
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Insert list of objects method
    * @param sObjList the sObject list to upsert
    */
    public static void upsertObjectList(List<Sobject> sObjList,Boolean allOrNothing) 
    {
        if(allOrNothing)
        {
            try 
            {
                upsert sObjList;
            } 
            catch(Exception ex) 
            {
                String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            }
        }
        else
        {
            LoggingHandler.processDatabaseUpsertResults(Database.upsert(SObjList,false));
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Update list of objects method
    * @param sObjList the sObject list to update
    */
    public static void updateObjectList(List<Sobject> sObjList) 
    {
        updateObjectList(sObjList,true);
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Insert list of objects method
    * @param sObjList the sObject list to upsert
    */
    public static void updateObjectList(List<Sobject> sObjList,Boolean allOrNothing) 
    {
        if(allOrNothing)
        {
            try 
            {
                update sObjList;
            } 
            catch(Exception ex) 
            {
                String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
            }
        }
        else
        {
            LoggingHandler.processDatabaseSaveResults(Database.update(SObjList,false));
        }
    }
    
    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Delete list of objects method
    * @param sObjList the sObject list to delete
    */
    public static void deleteObjectList(List<Sobject> sObjList) 
    {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try 
        {
            delete sObjList;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
        }
    }

    /**
    * @author Kevin Winn
    * @date 12/31/2019
    * @description Undelete list of objects method
    * @param sObjList the sObject list to undelete
    */
    public static void undeleteObjectList(List<Sobject> sObjList) 
    {
        String objectName = (null != sObjList && sObjList.size() > 0) ? String.valueOf(sObjList[0].getSObjectType()) : null;
        try 
        {
            undelete sObjList;
        } 
        catch(Exception ex) 
        {
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, objectName);
        }
    }
}