/**
* @author Kevin Winn
* @date 2022
* @group Org Framework
* @description This class provides a method to generate a custom apex object that groups this organizations fields for a given SObject into the following categories:
*       Standard Fields:  A wrapper class containing all standard Salesforce Fields for an SObject.
*       Custom Fields: A wrapper class containing all custom fields created by this org on an SObject.
*       Namespaced Fields:  A wrapper class containing all fiels on the SObject that have a namespace association.
*       Unhandled Fields: A wrapper class containing all unhandled fields that don't fit into the other buckets for this SObject
*       Use this class with mapping tools to define TradingSchema Settings. 
*/
public with sharing class ObjectFieldTree {

    /**@Description The SObject to build the Field Tree on */
    public SObject sobj;

    /**@Description A list of wrapped standard fields for the given SObject */
    public List<StandardField> standardFields;

    /**@Description A list of wrapped custom fields for the given SObject */
    public List<CustomField> customFields;

    /**@Description A list of wrapped namespaced fields for the given SObject */
    public List<NamespacedField> namespacedFields;

    /**@Description A list of wrapped unhandled fields for the given SObject */
    public List<UnhandledField> unhandledFields;
    
    /**
     * @description Constructor for class
     * @param SObject the SObject to build the field tree for
     * @param List<StandardField> a List of StandardField apex objects representing standard fields for the given sobject.
     * @param List<CustomField> a List of CustomField apex objects representing custom fields for the given sobject.
     * @param List<NamespacedField> a List of NamespacedField apex objects representing namespaced fields for the given sobject.
     * @param List<UnhandledField> a List of UnhandledField apex objects representing unknown fields for the given sobject.
     */
    public ObjectFieldTree(SObject sobj,List<StandardField> standard,List<CustomField> custom,List<NamespacedField> named,List<UnhandledField> unhandled) {
        this.sobj = sobj;
        this.standardFields = standard;
        this.customFields = custom;
        this.namespacedFields = named;
        this.unhandledFields = unhandled;
    }

    /**
     * @description Static method to get the ObjectFieldTree
     * @param SObject the SObject to build the tree for
     * @return Type: ObjectFieldTree
     * @example ObjectFieldTree.getTree(new Account());
     */
    public static ObjectFieldTree getTree(SObject sobj){
        List<StandardField> standards = new List<StandardField>();
        List<CustomField> customs = new List<CustomField>();
        List<NamespacedField> named = new LIst<NamespacedField>();
        List<UnhandledField> unhandled = new List<UnhandledField>();
        Map<String,Schema.SobjectField> fields = sobj.getSObjectType().getDescribe().fields.getMap();
        for(String s : fields.keySet()){
            if(s.indexOf('__') == - 1){
                standards.add(new StandardField(fields.get(s).getDescribe()));
            } else if(s.countMatches('__') > 1){
                String namespace = s.substringBefore('__');
                named.add(new NamespacedField(fields.get(s).getDescribe(),namespace));
            } else if(s.countMatches('__') == 1 && s.indexOf('__c') != -1){
                customs.add(new CustomField(fields.get(s).getDescribe()));
            } else{
                unhandled.add(new UnhandledField(fields.get(s).getDescribe()));
            }
        }
        return new ObjectFieldTree(sobj,standards,customs,named,unhandled);
    }

    /**
     *@description public wrapper for defining a Standard Field for the given SObject in this org.
    **/
    public class StandardField{

        public String apiName;
        public String label;
        public String fieldType;
        public Boolean isEncrypted;
        public Boolean isExternalId;
        public AccessControl access;
        public Schema.DescribeFieldResult describeField;

        /**
         * @description Constructor for class
         * @param Schema.DescribeFieldResult The DescribeFieldResult object for the given field
         */
        public StandardField(Schema.DescribeFieldResult dfr){
            this.apiName = dfr.getName();
            this.label = dfr.getLabel();
            this.fieldType = String.valueOf(dfr.getType());
            this.isEncrypted = dfr.isEncrypted();
            this.isExternalId = dfr.isExternalId();
            this.access = new AccessControl(dfr);
            this.describeField = dfr;
        }
    }

    /**
     *@description public wrapper for defining a Custom Field for the given SObject in this org.
    **/
    public class CustomField {
        public String apiName;
        public String label;
        public String fieldType;
        public Boolean isEncrypted;
        public Boolean isExternalId;
        public AccessControl access;
        public Schema.DescribeFieldResult describeField;

        /**
         * @description Constructor for class
         * @param Schema.DescribeFieldResult The DescribeFieldResult object for the given field
         */
        public CustomField(Schema.DescribeFieldResult dfr){
            this.apiName = dfr.getName();
            this.label = dfr.getLabel();
            this.fieldType = String.valueOf(dfr.getType());
            this.isEncrypted = dfr.isEncrypted();
            this.isExternalId = dfr.isExternalId();
            this.access = new AccessControl(dfr);
            this.describeField = dfr;
        }
    }

    /**
     *@description public wrapper for defining a Namespaced Field for the given SObject in this org.
    **/
    public class NamespacedField {
        public String apiName;
        public String label;
        public String fieldType;
        public Boolean isEncrypted;
        public Boolean isExternalId;
        public AccessControl access;
        public String namespace;
        public Schema.DescribeFieldResult describeField;

        /**
         * @description Constructor for class
         * @param Schema.DescribeFieldResult The DescribeFieldResult object for the given field
         * @param String the namespace for the given field
         */
        public NamespacedField(Schema.DescribeFieldResult dfr,String namespace){
            this.apiName = dfr.getName();
            this.label = dfr.getLabel();
            this.fieldType = String.valueOf(dfr.getType());
            this.isEncrypted = dfr.isEncrypted();
            this.isExternalId = dfr.isExternalId();
            this.access = new AccessControl(dfr);
            this.namespace = namespace;
            this.describeField = dfr;
        }
    }

    /**
     *@description public wrapper for defining an Unhandled Field for the given SObject in this org.
    **/
    public class UnhandledField{
        public String apiName;
        public String label;
        public String fieldType;
        public Boolean isEncrypted;
        public Boolean isExternalId;
        public AccessControl access;
        public Schema.DescribeFieldResult describeField;

        /**
         * @description Constructor for class
         * @param Schema.DescribeFieldResult The DescribeFieldResult object for the given field
         */
        public UnhandledField(Schema.DescribeFieldResult dfr){
            this.apiName = dfr.getName();
            this.label = dfr.getLabel();
            this.fieldType = String.valueOf(dfr.getType());
            this.isEncrypted = dfr.isEncrypted();
            this.isExternalId = dfr.isExternalId();
            this.access = new AccessControl(dfr);
            this.describeField = dfr;
        }
    }

    /**
     *@description public wrapper for defining access controls for all Fields for the SObjeect
    **/
    public class AccessControl{
        public Boolean isCreateable;
        public Boolean isAccessible;
        public Boolean isUpdateable;
        public Boolean isDeleteable;
        public Boolean isUpsertable;
        public Boolean isReadOnly;
        public Boolean isCalculated;
        /**
         * @description Constructor for class
         * @param Schema.DescribeFieldResult The DescribeFieldResult object for the given field
         */
        public AccessControl(Schema.DescribeFieldResult dfr){
            this.isAccessible = dfr.isAccessible();
            this.isCreateable = dfr.isCreateable();
            this.isUpdateable = dfr.isUpdateable();
            this.isDeleteable = dfr.isRestrictedDelete();
            this.isReadOnly = (dfr.isAccessible() && (!dfr.isCreateable() || !dfr.isUpdateable() || dfr.isCalculated())) ? true : false;
            this.isCalculated = dfr.isCalculated();
        }
    }
}