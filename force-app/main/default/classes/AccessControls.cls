/**
* @author Kevin Winn
* @date May 19, 2022
* @group Entitlements
* @description contains methods to manage CRUD and FLS checks.  Leverages Security.
*/
public class AccessControls {

    public SObjectAccess sObjectAccess;
    public SObjectAccessDecision accessDecision;
    public Boolean invalidRequest;

    public AccessControls(SObject sObj){
        try{
            this.sObjectAccess = getSObjectAccess(sobj);
            this.accessDecision = Security.stripInaccessible(AccessType.READABLE, new List<SObject>{sobj},true);
            this.invalidRequest = false;
        } catch(NoAccessException ex){
            this.invalidRequest = true;
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, SObjectUtility.getSObjectTypeName(sobj));
            LoggingHandler.popAll();
        }        
    }

    public AccessControls(System.AccessType accessType,List<SObject> sobjectList){
       if(null != sobjectList){
           try{
               this.sObjectAccess = getSObjectAccess(sobjectList[0]);
               this.accessDecision = Security.stripInaccessible(accessType, sobjectList,false);
               this.invalidRequest = false;
           } catch(NoAccessException ex){
                this.invalidRequest = true;
               LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, SObjectUtility.getSObjectTypeName(sobjectList[0]));
               LoggingHandler.popAll();
           }
       }else{
           this.invalidRequest = true;
       }
    }

    public AccessControls(System.AccessType accessType,List<SObject> sobjectList,Boolean baseCrudCheck){
        if(null != sobjectList){
            try{
                this.sObjectAccess = getSObjectAccess(sobjectList[0]);
                this.accessDecision = Security.stripInaccessible(accessType, sobjectList,baseCrudCheck);
                this.invalidRequest = false;
            } catch(NoAccessException ex){
                this.invalidRequest = true;
                LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, SObjectUtility.getSObjectTypeName(sobjectList[0]));
                LoggingHandler.popAll();
            }
        }else{
            this.invalidRequest = true;
        }
    }

    private SObjectAccess getSObjectAccess(SObject sobj){
        if(null == sObjectAccess  || sObjectAccess.sobjectName != SObjectUtility.getSObjectTypeName(sobj)){
            this.sObjectAccess = new SObjectAccess(SObjectUtility.getSObjectDescribeResult(sobj));
        }
        return this.SObjectAccess;
    }

    public static AccessControls getSObjectAccessControls(SObject sobj){
       
        return new AccessControls(sobj);
    }

    public static AccessControls removeInaccessibleFields(System.AccessType accessType,List<SObject> sobjectList){
        return new AccessControls(accessType,sobjectList);
    }

    public static AccessControls removeAllInaccessible(System.AccessType accessType,List<Sobject> sobjectList){
        return new AccessControls(accessType,sobjectList,true);
    }
   
    /**
     * @description private wrapper to define access for a given SObject
     * @param Schema.DescribeSObjectResult The Describe result for the SObject
     * @return Type: SobjectAccess
     */
    private class SObjectAccess {
        public string sobjectName;
        public Boolean isReadable;
        public Boolean isCreateable;
        public Boolean isUpdateable;
        public Boolean isUpsertable;
        public Boolean isDeleteable;
        public Boolean isQueryable;
        public Boolean isSearchable;
        public SObjectAccess(Schema.DescribeSObjectResult describeResult){
            this.sobjectName = describeResult.getName();
            this.isReadable = describeResult.isAccessible();
            this.isCreateable = describeResult.isCreateable();
            this.isUpdateable = describeResult.isUpdateable();
            this.isUpsertable = describeResult.isCreateable() && describeResult.isUpdateable() ? true : false;
            this.isDeleteable = describeResult.isDeletable();
            this.isQueryable = describeResult.isQueryable();
            this.isSearchable = describeResult.isSearchable();
        }
    }
}
