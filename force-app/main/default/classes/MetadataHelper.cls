/**
* @author Kevin Winn
* @date May 17, 2022
* @group Metadata Tooling
* @description helper class for MetadataManager.  Contains methods to leverage built-in Metadata.DeployContainer() functions and also methods to leverage the MDAPI 
*				Services provided through the MetadataService.cls.
*/
public with sharing class MetadataHelper {
	
	/**
	 * @description retrieve a new Metadata.DeployContainer
	 * @return Type: Metadata.DeployContainer
	 */
	public static Metadata.DeployContainer getContainer() {
        return new Metadata.DeployContainer();
    }

	/**
	 * @description method to prepare a new instance of a CustomMetadata type.  If request is invalid, method returns an empty instance of CustomMetadata
	 * @param Map<String,Object> the fieldMap containing String names for metadata fields as keys with an Object represention for values
	 * @return Type: Metadata.CustomMetadata
	 */
	public static Metadata.CustomMetadata prepareNewCustomMetadataInstance(Map<String,Object> fieldMap){
		Metadata.CustomMetadata instance = new Metadata.CustomMetadata();
		if(!fieldMap.containsKey(StaticResources.QUALIFIED_API_NAME) || !fieldMap.containsKey(StaticResources.MASTER_LABEL) || fieldMap.isEmpty()){
			LoggingHandler.debugException(
				new CustomMetadataException(
					'Missing Required Fields for new Metadata.CustomMetadata instance'), 
					StaticResources.SALESFORCE_EXCEPTION, 
					'CustomMetadata'
				);
			LoggingHandler.popAll();
		} else{
			instance.fullName = String.valueOf(fieldMap.get(StaticResources.QUALIFIED_API_NAME));
			instance.label = String.valueOf(fieldMap.get(StaticResources.MASTER_LABEL));
			for(String s : fieldMap.keySet()){
				if(!ignoredForCustomMetadataValues().contains(s)){
					Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
					customField.field = s;
					customField.value = fieldMap.get(s);
					instance.values.add(customField);
					fieldMap.remove(s);
				}else{
					fieldMap.remove(s);
				}
			}
		}
		return instance;
	}

	/**
	 * @description method to set the 'IsTestData__c' field value on a new instance of CustomMetadata
	 * @param Map<String,Object> the fieldMap for the new CustomMetadata Instance
	 * @param Boolean indicator as to whether to set the test data field as true or false
	 * @return Type: Map<String,Object>
	 */
	public static Map<String,Object> prepareInstanceAsTestData(Map<String,Object> fieldMap,Boolean trueORfalse){
		
		fieldMap.put(StaticResources.THIS_PACKAGE_NAMESPACE + StaticResources.IS_TEST_DATA,trueORfalse);
        return fieldMap;
	}

	/**
	 * @description method to set the Protected field value on a new instance of CustomMetadata
	 * @param Map<String,Object> the fieldMap for the new CustomMetadata Instance
	 * @param Boolean indicator as to whether to set the record as protected
	 * @return Type: Map<String,Object>
	 */
	public static Map<String,Object> prepareInstanceAsProtected(Map<String,Object> fieldMap,Boolean trueORfalse){
		
		fieldMap.put(StaticResources.THIS_PACKAGE_NAMESPACE + StaticResources.PROTECTED_X,trueORfalse);
        return fieldMap;
	}

	/**
	 * @description method to set the Protected field value on a new instance of CustomMetadata
	 * @param Map<String,Object> the fieldMap for the new CustomMetadata Instance
	 * @param String The inline help text for the instance being defined
	 * @return Type: Map<String,Object>
	 */
	public static Map<String,Object> prepareInlineHelpText(Map<String,Object> fieldMap,String inlineHelp){
		
		fieldMap.put(StaticResources.THIS_PACKAGE_NAMESPACE + StaticResources.INLINE_HELP_TEXT,inlineHelp);
        return fieldMap;
	}

	/**
	 * @description method to set the Protected field value on a new instance of CustomMetadata
	 * @param Map<String,Object> the fieldMap for the new CustomMetadata Instance
	 * @param Boolean indicator as to whether this CustomMetadata instance is an active setting
	 * @return Type: Map<String,Object>
	 */
	public static Map<String,Object> prepareInstanceAsActive(Map<String,Object> fieldMap,Boolean trueOrFalse){
		
		fieldMap.put(StaticResources.THIS_PACKAGE_NAMESPACE + StaticResources.IS_ACTIVE_FIELD,trueOrFalse);
        return fieldMap;
	}

	/**
	 * @description method to add instances of CustomMetadata to the DeployContainer
	 * @param Metadata.DeployContainer the container to add the instance of CustomMetadata to
	 * @param Metadata.CustomMetadata the instance of CustomMetadata to add to the DeployContainer
	 * @return Type: Metadata.DeployContainer
	 */
	public static Metadata.DeployContainer addinstanceToContainer(Metadata.DeployContainer container,Metadata.CustomMetadata metadataInstance){
		container.addMetadata(metadataInstance);
        return container;
	}

	/**
	 * @description private helper to add all field names that cannot be written to using Metadata.CustomMetadataValue
	 * @return Type: Set<String>
	 */
	private static Set<String> ignoredForCustomMetadataValues(){
		Set<String> results = new Set<String>();
		results.add(StaticResources.QUALIFIED_API_NAME);
		results.add(StaticResources.ID_FIELD);
		results.add(StaticResources.MASTER_LABEL);
		return results;
	}

	/**
	 * @description method to instantiate a new MetadataService.MetadataPort for MDAPI deployments.  Service updated to use API version 54.0
	 * @return Type: MetadataService.MetadataPort
	 * @example MetadataHelper.openMdapiService();
	 */
	public static MetadataService.MetadataPort openMdapiService(){
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;
	}

	/**
	 * @description Define a custom object to deploy through the Mdapi Service.  Use during configuration if org decides to use package objects instead of
	 * 				pre-existing SObjects.
	 * @param String The Label for the object.  
	 * @param String The API Name for the object
	 * @param String the label for the Name field on the new object
	 * @return Type: MetadataService.CustomObject
	 * @example MetadataHelper.defineCustomObject('Trading Account','TradingAccount');
	 */
	public static MetadataService.CustomObject defineCustomObject(String label,String apiName,String nameFieldLabel){
		MetadataService.CustomObject results = new MetadataService.CustomObject();
		results.fullName = String.valueOf(apiName.trim() + '__c');
		results.label = label;
		results.pluralLabel = label +'s';
		results.nameField = new MetadataService.CustomField();
		results.nameField.type_x = 'Text';
		results.nameField.label = nameFieldLabel;
		results.deploymentStatus = 'Deployed';
		results.sharingModel = 'ReadWrite';
		return results;
	}

	/**
	 * @description Define a MasterDetail field for an SObject.  
	 * @param String The fully qualified SObject API name to add the MasterDetail field to  
	 * @param String The label for the MasterDetail field.  All whitespace will be removed for the API name
	 * @param String The label for the relationship field.  All whitespace will be removed for the API name for the relationship name 
	 * @param String The fully qualified API name for the reference object that will assume the parent role in this MasterDetail relationship.
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineMasterDetailField('TradingAccount__c','Salesforce Account','SalesforceAccounts','Account');
	 */
	public static MetadataService.CustomField defineMasterDetailField(String sobjectName,String fieldName,String relationshipLabel,String referenceObject){
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = sobjectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'MasterDetail';
        customField.relationshipOrder = 0;
        customField.relationshipLabel = relationshipLabel;
        customField.relationshipName = String.valueOf(relationshipLabel.trim());
        customField.referenceTo = referenceObject;
        customField.writeRequiresMasterRead = false;
        return customField;
    }

	/**
	 * @description Define a Lookup Relationship field for an SObject.  
	 * @param String The fully qualified SObject API name to add the Lookup field to  
	 * @param String The label for the Lookup field.  All whitespace will be removed for the API name
	 * @param String The label for the relationship field.  All whitespace will be removed for the API name for the relationship name 
	 * @param String The fully qualified API name for the reference object that will assume the parent role in this Lookup relationship.
	 * @param Boolean an indicator to identify if this lookup field is a required field
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineLookupField('TradingAccount__c','Salesforce Account','SalesforceAccounts','Account',false);
	 */
	public static MetadataService.CustomField defineLookupField(String sobjectName,String fieldName,String relationshipLabel,String referenceObject,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = sobjectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Lookup';
        customField.relationshipLabel = relationshipLabel;
        customField.relationshipName = String.valueOf(relationshipLabel.trim());
        customField.referenceTo = referenceObject;
        customField.required = required;

        return customField;
    }

	/**
	 * @description Define an External Id Text field for an SObject 
	 * @param String The fully qualified SObject API name to add the External Id field to  
	 * @param String The label for the External Id field.  All whitespace will be removed for the API name
	 * @param Integer The length of the External Id expressed as an integer.  Max = 255
	 * @param Boolean An indicator as to whether this External Id field value is unique for each record
	 * @param Boolean an indicator to identify if this External Id field is a required field on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineExternalIdTextField('Account','Addepar Id',16,true,false);
	 */
	public static MetadataService.CustomField defineExternalIdTextField(String objectName,String fieldName,Integer length,Boolean unique,Boolean required){
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Text';
        customField.length = length;
        customField.externalId = true;
        customField.unique = unique;
        customField.required = required;
        return customField;
    }

	/**
	 * @description Define a Currency field for an SObject 
	 * @param String The fully qualified SObject API name to add the Currency field to  
	 * @param String The label for the Currency field.  All whitespace will be removed for the API name
	 * @param Integer The precision for the currency field.  This the the number of digits that can be stored to the left and right of the decimal
	 * @param Integer The scale for the currency field.  Aka the number of digits to the right of the decimal
	 * @param String The default value for the currency field represented as a string.
	 * @param Boolean an indicator to identify if this Currency field is a required field on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineCurrencyField('Trading Account','Desired Margin Balance',2,18,'1.00',false);
	 */
	public static MetadataService.CustomField defineCurrencyField(String objectName,String fieldName,Integer precision,Integer scale,String defaultValue,Boolean required){
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Currency';
        customField.precision = precision;
        customField.scale = scale;
        customField.defaultValue = defaultValue;
        customField.required = required;
        return customField;
    }

	/**
	 * @description Define a Text field for an SObject 
	 * @param String The fully qualified SObject API name to add the Text field to  
	 * @param String The label for the Text field.  All whitespace will be removed for the API name
	 * @param Integer The length for the Text field.  Max = 255
	 * @param Boolean an indicator to identify if this Text field is a required field on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineTextField('Trading Account','Manager',255,false);
	 */
    public static MetadataService.CustomField defineTextField(String objectName,String fieldName,Integer length,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Text';
        customField.length = length > 255 ? 255 : length;
        customField.required = required;
        return customField;
    }

	/**
	 * @description Define a TextArea field for an SObject 
	 * @param String The fully qualified SObject API name to add the TextArea field to  
	 * @param String The label for the TextArea field.  All whitespace will be removed for the API name
	 * @param Integer The length for the TextArea field.  Max = 255
	 * @param Integer The number of visible lines for the UI for this field.
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineTextAreaField('Trading Account','Description',255,3);
	 */
    public static MetadataService.CustomField defineTextAreaField(String objectName,String fieldName,Integer length,Integer visibleLines) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'TextArea';
        customField.length = length > 255 ? 255 : length;
		customField.visibleLines = visibleLines;
        return customField;
    }

	/**
	 * @description Define a Long TextArea field for an SObject 
	 * @param String The fully qualified SObject API name to add the Long TextArea field to  
	 * @param String The label for the Long TextArea field.  All whitespace will be removed for the API name
	 * @param Integer The length for the Long TextArea field.  Max 131,072
	 * @param Integer The number of visible lines for the UI for this field.
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineLongTextAreaField('Trading Account','Trade Settings',131072,5);
	 */
    public static MetadataService.CustomField defineLongTextAreaField(String objectName,String fieldName,Integer length,Integer visibleLines) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'LongTextArea';
		customField.length = length > 131072 ? 131072 : length;
		customField.visibleLines = visibleLines;
        return customField;
    }

	/**
	 * @description Define a Checkbox field for an SObject 
	 * @param String The fully qualified SObject API name to add the Checkbox field to  
	 * @param String The label for the Checkbox field.  All whitespace will be removed for the API name
	 * @param String the default value for the checkbox as a string.  Accepts 'true', 'false', 'True', 'False', 'TRUE', 'FALSE'
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineBooleanField('Trading Account','Trade Settings',131072,5);
	 */
    public static MetadataService.CustomField defineBooleanField(String objectName,String fieldName,String defaultTrueOrFalse) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Checkbox';
        customField.defaultValue = defaultTrueOrFalse.toLowerCase();
        return customField;
    }

	/**
	 * @description Define a Date field for an SObject 
	 * @param String The fully qualified SObject API name to add the Date field to  
	 * @param String The label for the Date field.  All whitespace will be removed for the API name
	 * @param Boolean An indicator to identify this field as required on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineDateField('Trading Account','Last Rebalanced',false);
	 */
    public static MetadataService.CustomField defineDateField(String objectName,String fieldName,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Date';
        customField.required = required;
        return customField;
    }

	/**
	 * @description Define a DateTime field for an SObject 
	 * @param String The fully qualified SObject API name to add the DateTime field to  
	 * @param String The label for the DateTime field.  All whitespace will be removed for the API name
	 * @param Boolean An indicator to identify this field as required on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineDateTimeField('Trading Account','Last Action',false);
	 */
    public static MetadataService.CustomField defineDateTimeField(String objectName,String fieldName,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'DateTime';
        customField.required = required;
        return customField;
    }

	/**
	 * @description Define an Email field for an SObject 
	 * @param String The fully qualified SObject API name to add the Email field to  
	 * @param String The label for the Email field.  All whitespace will be removed for the API name
	 * @param String the default value for the Email field
	 * @param Boolean An indicator to identify this field as required on the SObject
	 * @param Boolean An indicator to identify this field as unique on the SObject
	 * @param Boolean An indicator to set this Email field as an External Id field on the SObject
	 * @return Type: MetadataService.CustomField
	 * @example MetadataHelper.defineEmailField('Trading Account','Last Action',false);
	 */
    public static MetadataService.CustomField defineEmailField(String objectName,String fieldName,String defaultVal,Boolean required,Boolean unique,Boolean external) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
		customField.fullName = objectName + '.' + String.valueOf(fieldName.trim().deleteWhitespace() + '__c');
        customField.label = fieldName;
        customField.type_x = 'Email';
		customField.defaultValue = defaultVal;
        customField.required = required;
		customField.unique = unique;
		customField.externalId = external;
        return customField;
    }

    public static MetadataService.CustomField defineIntegerField(String objectName,String fieldName,Integer precision, Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();

        return customField;
    }

    public static MetadataService.CustomField defineDoubleField(String objectName,String fieldName,Integer precision, Integer scale,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();

        return customField;
    }

    public static MetadataService.CustomField definePercentField(String objectName,String fieldName,Integer precision, Integer scale,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();

        return customField;
    }

    public static MetadataService.CustomField definePicklistField(String objectName,String fieldName,Boolean required) {
        MetadataService.CustomField customField = new MetadataService.CustomField();

        return customField;
    }

    public static MetadataService.CustomField defineUrlField(String objectName,String fieldName,Boolean required,String defaultValue) {
        MetadataService.CustomField customField = new MetadataService.CustomField();

        return customField;
    }

	/**
	 * @Description Custom Exception class for CustomMetadata methods 
	 */
	public class CustomMetadataException extends Exception{

	}

	/**
	 * @Description Custom Exception class for MetadataService methods 
	 */
	public class MdapiServiceException extends Exception { 

	}

}