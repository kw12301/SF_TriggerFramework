/**
* @author Kevin Winn
* @date May 19, 2022
* @group Governance
* @description contains methods to manage CRUD and FLS checks.  Leverages Security.stripInacccessible() methods to remove 
*           fields and records from a list of SObjects that the running user does not have access to based on the given
*           System.AccessType provided.  Use this class prior to performing DML but after successfully querying or obtaining 
*           a list of records.
*/
public class AccessControls {

    /**
     * @description wrapper identifying all CRUD, Query, Search, and Merge permissions for an SObject for the running user
     */
    public SObjectAccess sObjectAccess;
    /**
     * @description The SObjectAccessDecision wrapper for the list of objects. 
     */
    public SObjectAccessDecision accessDecision;
    /**
     * @description Boolean to identify if the request submitted to this class is valid.   
     */
    public Boolean invalidRequest;

    /**
     * @description Constructor for sObjectAccess wrapper.  Call AccessControls.getSObjectAccessControls(Sobject) to get all CRUD, Query, Search, and Merge permissions 
     *              for a SObject based on the running users permissions.  
     * @param SObject the SObject to check permissions on
     * @return Type: AccessControls.SObjectAccess
     */
    public AccessControls(SObject sObj){
        try{
            this.sObjectAccess = getSObjectAccess(sobj);
            this.accessDecision = Security.stripInaccessible(AccessType.READABLE, new List<SObject>{sobj},true);
            this.invalidRequest = false;
        } catch(NoAccessException ex){
            this.invalidRequest = true;
            LoggingHandler.debugException(ex, StaticResources.NO_ACCESS_EXCEPTION, SObjectUtility.getSObjectTypeName(sobj));
            LoggingHandler.popAll();
        }        
    }

    /**
     * @description Constructor for accessDecision wrapper.  Checks Field FLS only on the list of objects already queried
     *              using the Security.stripInaccessible(System.AccessType,List<SObject>,false) method  
     *              Call AccessControls.removeInaccessibleFields(AccessType,List<Sobject>) prior to performing DML on a 
     *              list to remove inaccessible fields based on the AccessType.
     * @param System.AccessType the access type to perform field FLS checks on.  
     *                          Possible values include CREATABLE,READABLE,UPDATABLE, and UPSERTABLE
     * @param List<SObject> a generic SObject list containing a single Object type to perform FLS checks on.
     * @return Type: AccessControls
     */
    public AccessControls(System.AccessType accessType,List<SObject> sobjectList){
       if(null != sobjectList){
           try{
               this.sObjectAccess = getSObjectAccess(sobjectList[0]);
               this.accessDecision = Security.stripInaccessible(accessType, sobjectList,false);
               this.invalidRequest = false;
           } catch(NoAccessException ex){
                this.invalidRequest = true;
               LoggingHandler.debugException(ex, StaticResources.NO_ACCESS_EXCEPTION, SObjectUtility.getSObjectTypeName(sobjectList[0]));
               LoggingHandler.popAll();
           }
       }else{
           this.invalidRequest = true;
       }
    }

    /**
     * @description Constructor for accessDecision wrapper.  Checks Object AND Field FLS on the list of objects already queried
     *              using the Security.stripInaccessible(System.AccessType,List<SObject>,True) method.
     *              Call AccessControls.removeAllInaccessible(AccessType,List<Sobject>) prior to performing DML on a list to 
     *              remove all inaccessible records and fields based on the AccessType.
     * @param System.AccessType the access type to perform field FLS checks on.  
     *                          Possible values include CREATABLE,READABLE,UPDATABLE, and UPSERTABLE
     * @param List<SObject> a generic SObject list containing a single Object type to perform Object and FLS checks on.
     * @return Type: AccessControls
     */
    public AccessControls(System.AccessType accessType,List<SObject> sobjectList,Boolean baseCrudCheck){
        if(null != sobjectList){
            try{
                this.sObjectAccess = getSObjectAccess(sobjectList[0]);
                this.accessDecision = Security.stripInaccessible(accessType, sobjectList,baseCrudCheck);
                this.invalidRequest = false;
            } catch(NoAccessException ex){
                this.invalidRequest = true;
                LoggingHandler.debugException(ex, StaticResources.NO_ACCESS_EXCEPTION, SObjectUtility.getSObjectTypeName(sobjectList[0]));
                LoggingHandler.popAll();
            }
        }else{
            this.invalidRequest = true;
        }
    }

    /**
     * @description private helper method to get the SObjectAccess wrapper 
     * @param SObject the SObject to check permissions on
     */
    private SObjectAccess getSObjectAccess(SObject sobj){
        if(null == sObjectAccess  || sObjectAccess.sobjectName != SObjectUtility.getSObjectTypeName(sobj)){
            this.sObjectAccess = new SObjectAccess(SObjectUtility.getSObjectDescribeResult(sobj));
        }
        return this.SObjectAccess;
    }

    /**
     * @description public method to get the SObjectAccess wrapper for the given SObject
     * @param SObject the SObject to check permissions on
     * @return Type: AccessControls
     * @example AccessControls.getSObjectAccessControls(new Account());
     */
    public static AccessControls getSObjectAccessControls(SObject sobj){ 
        return new AccessControls(sobj);
    }

    /**
     * @description public method to remove inaccessible fields from a list of SObjects
     * @param System.AccessType The enum identifying the access type to perform FLS checks on
     * @param List<Sobject> The list of SObjects to strip inaccessible fields from
     * @return Type: AccessControls
     * @example AccessControls.removeInaccessibleFields(System.AccessType.UPDATEABLE,someListOfSObjects);
     */
    public static AccessControls removeInaccessibleFields(System.AccessType accessType,List<SObject> sobjectList){
        return new AccessControls(accessType,sobjectList);
    }

    /**
     * @description public method to remove inaccessible fields AND records from a list of SObjects
     * @param System.AccessType The enum identifying the access type to perform FLS checks on
     * @param List<Sobject> The list of SObjects to strip inaccessible fields and records from
     * @return Type: AccessControls
     * @example AccessControls.removeAllInaccessible(System.AccessType.UPDATEABLE,someListOfSObjects);
     */
    public static AccessControls removeAllInaccessible(System.AccessType accessType,List<Sobject> sobjectList){
        return new AccessControls(accessType,sobjectList,true);
    }
   
    /**
     * @description private wrapper to define access for a given SObject
     * @param Schema.DescribeSObjectResult The Describe result for the SObject
     * @return Type: SobjectAccess
     */
    public class SObjectAccess {
        public string sobjectName;
        public Boolean isReadable;
        public Boolean isCreateable;
        public Boolean isUpdateable;
        public Boolean isUpsertable;
        public Boolean isDeleteable;
        public Boolean isQueryable;
        public Boolean isSearchable;
        public Boolean isMergeable;
        public SObjectAccess(Schema.DescribeSObjectResult describeResult){
            this.sobjectName = describeResult.getName();
            this.isReadable = describeResult.isAccessible();
            this.isCreateable = describeResult.isCreateable();
            this.isUpdateable = describeResult.isUpdateable();
            this.isUpsertable = describeResult.isCreateable() && describeResult.isUpdateable() ? true : false;
            this.isDeleteable = describeResult.isDeletable();
            this.isQueryable = describeResult.isQueryable();
            this.isSearchable = describeResult.isSearchable();
            this.isMergeable = describeResult.isMergeable();
        }
    }
}