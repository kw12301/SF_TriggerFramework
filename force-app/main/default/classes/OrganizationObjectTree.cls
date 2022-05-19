/**
* @author Kevin Winn
* @date 2022
* @group Framework
* @description This class provides a method to generate a custom apex object that groups this organizations SObjects into the following categories:
*       Standard Objects:  A wrapper class containing all standard Salesforce SObjects in this org.
*       Custom Objects: A wrapper class containing all custom objects created by this org.
*       Namespaced Objects:  A wrapper class containing all SObjects that have a namespace association.
*       Custom Settings: A wrapper class containing all custom settings created by this org.
*       Namespaced Settings: A wrapper class containing all custom settings deployed under a namespace.
*       Use this class with mapping tools to define TradingSchema Settings. 
*/
public with sharing class OrganizationObjectTree {

    /**@Description A list of wrapped standard SObjects */
    public List<StandardObject> standardObjects;
    /**@Description A list of wrapped custom SObjects */
    public List<CustomObject> customObjects;
    /**@Description A list of wrapped namespaced SObjects */
    public List<NamespacedObject> namespacedObjects;
    /**@Description A list of wrapped Custom Setting SObjects */
    public List<CustomSetting> customSettings;
    /**@Description A list of wrapped namespaced Custom Setting SObjects */
    public List<NamespacedCustomSetting> namespacedCustomSettings;

    /**
     * @description Constructor for class
     * @param List<StandardObject> a List of StandardObject apex objects representing standard objects for this org.
     * @param List<CustomObject> a List of CustomObject apex objects representing custom objects for this org.
     * @param List<NamespacedObject> a List of NamespacedObject apex objects representing namespaced objects for this org.
     * @param List<CustomSetting> a List of CustomSetting apex objects representing org custom setting objects for this org.
     * @param List<NamespacedCustomSetting> a List of NamespacedCustomSetting apex objects representing namespaced Custom Setting objects for this org.
     */
    public OrganizationObjectTree(List<StandardObject> standard,List<CustomObject> custom,List<NamespacedObject> namespacedObjects,List<CustomSetting> customSettings,List<NamespacedCustomSetting> namedSettings){
        this.standardObjects = standard;
        this.customObjects = custom;
        this.namespacedObjects = namespacedObjects;
        this.customSettings = customSettings;
        this.namespacedCustomSettings = namedSettings;
           
    }

    /**
     * @description Static method to get the OrganizationObjectTree
     * @return Type: OrganizationObjectTree
     * @example OrganizationObjectTree.getTree();
     */
    public static OrganizationObjectTree getTree(){
        return setOrganizationObjectTree();
    }

    /**
     * @description private method to get and set OrganizationObjectTree
     * @return Type: OrganizationObjectTree
     */
    private static OrganizationObjectTree setOrganizationObjectTree(){
        List<StandardObject> standard = new List<StandardObject>();
        List<CustomObject> custom = new List<CustomObject>();
        List<NamespacedObject> named = new List<NamespacedObject>();
        List<CustomSetting> settings = new List<CustomSetting>();
        List<NamespacedCustomSetting> namedSettings = new List<NamespacedCustomSetting>();
        for(Schema.SObjectType soType : Schema.getGlobalDescribe().values()){
            String name = soType.getDescribe().getName();
            if(soType.getDescribe().isCreateable() && !name.containsIgnoreCase('history') && !name.containsIgnoreCase('tag') 
                && !name.containsignorecase('share') && !name.containsIgnoreCase('feed')) {
                if(name.indexOf('__') == -1){
                    standard.add(new StandardObject(name,soType));
                }else{
                    if(soType.getDescribe().isCustomSetting()){
                        if(name.countMatches('__') > 1){
                            namedSettings.add(new NamespacedCustomSetting(name,soType,String.valueOf(name.substringBefore('__'))));
                        }else{
                            settings.add(new CustomSetting(name,soType));
                        }
                    } else if(name.countMatches('__') == 1 && name.indexOf('__c') != -1){
                        custom.add(new CustomObject(name,soType));
                    } else if(name.countMatches('__') > 1){
                        named.add(new NameSpacedObject(name,soType,String.valueOf(name.substringBefore('__'))));
                    } else{
                        continue;
                    }
                }
            }
        }
        return new OrganizationObjectTree(standard,custom,named,settings,namedSettings);
    }

    /**
     *@description public wrapper for defining a Standard SObject in this org.
     *@return Type: StandardObject
    **/
    public class StandardObject {
        public String apiName;
        public String label;
        public Schema.SObjectType sObjType;
        public StandardObject(String key, Schema.SObjectType sobjType){
            this.apiName = key;
            this.label = sobjType.getDescribe().getLabel();
            this.sObjType = sobjType;
        }
    }

    /**
     *@description public wrapper for defining a Custom SObject specific to this org.
     *@return Type: CustomObject
    **/
    public class CustomObject {
        public String apiName;
        public String label;
        public Schema.SObjectType sObjType;
        public CustomObject(String key, Schema.SObjectType sobjType) {
            this.apiName = key;
            this.label = sobjType.getDescribe().getLabel();
            this.sObjType = sobjType;
        }
    }

    /**
     *@description public wrapper for defining a Namespaced SObject specific to this org.
     *              namespaced objects are created by package installs from the AppExchange
     *@return Type: NameSpacedObject
    **/
    public class NamespacedObject {
        public String apiName;
        public String label;
        public String namespace;
        public Schema.SObjectType sObjType;
        public NamespacedObject(String key, Schema.SObjectType sobjType,String namespace){
            this.apiName = key;
            this.label = sobjType.getDescribe().getLabel();
            this.sObjType = sobjType;
            this.namespace = namespace;
        }
    }

    /**
     *@description public wrapper for defining all org specific CustomSetting Sobjects deployed in this org.
     *@return Type: CustomSetting
    **/
    public class CustomSetting {
        public String apiName;
        public String label;
        public Schema.SObjectType sObjType;
        public CustomSetting(String key, Schema.SObjectType sobjType){
            this.apiName = key;
            this.label = sobjType.getDescribe().getLabel();
            this.sObjType = sobjType;
        }
    }

     /**
     *@description public wrapper for defining all namespaced CustomSetting Sobjects deployed in this org.
     *@return Type: CustomSetting
    **/
    public class NamespacedCustomSetting {
        public String apiName;
        public String label;
        public String namespace;
        public Schema.SObjectType sObjType;
        public NamespacedCustomSetting(String key, Schema.SObjectType sobjType,String namespace){
            this.apiName = key;
            this.label = sobjType.getDescribe().getLabel();
            this.sObjType = sobjType;
            this.namespace = namespace;
        }
    }
}
