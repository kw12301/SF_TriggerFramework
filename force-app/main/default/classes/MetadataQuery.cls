/**
* @author Kevin Winn
* @date May 17, 2022
* @group Framework
* @description Trading Metadata
*               Contains methods to cache all expected fields from metadata settings to support integration.
*               New fields added to future releases will need to be added to query methods in this class
*/
public with sharing class MetadataQuery {

	/**
    * @description method to cache the Namespace for this package
    * @return Type: String
    */
    public static final String NAMESPACE = StaticResources.ADDEPAR_V2_NAMESPACE;
    
    /**
    * @description method to cache the System Default Qualified API Name for default settings
    *               combine with NAMESPACE string and metadata object name to query default metadata settings 
    * @return Type: String
    */
    public static final String SYSTEM_DEFAULT = 'Default';

    /**
    * @description method to cache the System Test Qualified API Name for test settings
    *               combine with NAMESPACE string and metadata object name to query test metadata settings 
    * @return Type: String
    */
    public static final String SYSTEM_TEST = 'SystemTest';

    /**
    * @author Kevin Winn
    * @date 04/04/2022
    * @description cache all AP field settings
    * @return Type: Trading_Setting__mdt[]
    * @see Trading_Setting__mdt
    */
    public static Trading_Setting__mdt tradingSettings() {
        Trading_Setting__mdt settings = Database.query(tradingSettingsQuery());
        return settings;
    }

    /**
    * @author Kevin Winn
    * @date 04/04/2022
    * @description cache all AP field settings
    * @return Type: Connection_Setting__mdt[]
    * @see Connection_Setting__mdt
    */
    public static Connection_Setting__mdt[] connectionSettings() {
        Connection_Setting__mdt[] settings = Database.query(connectionSettingsQuery());
        return settings;
    }

    /**
    * @author Kevin Winn
    * @date 04/04/2022
    * @description prepare query string for standard metadata fields
    * @return Type: String
    * @see https://help.salesforce.com/articleView?id=custommetadatatypes_accessing.htm&amp;type=5
    */
    private static String standardMetaFieldsQuery() {
        return 'Select Id,MasterLabel,QualifiedAPIName,NameSpacePrefix,';
    }

    /**
    * @author Kevin Winn
    * @date 04/04/2022
    * @description prepare query string for Trading Settings metadata object
    * @return Type: String
    */
    private static String tradingSettingsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'Namespace__c,'+
                NAMESPACE + 'Trading_Enabled_Attribute__c From Trading_Setting__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Connection Settings metadata object
    * @return Type: String
    */
    private static String connectionSettingsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'API_Key__c,'+
        		NAMESPACE + 'API_Secret__c,'+
        		NAMESPACE + 'API_Version__c,'+
        		NAMESPACE + 'Base_URL__c,'+
        		NAMESPACE + 'Firm_Id__c,'+
        		NAMESPACE + 'Password__c,'+
                NAMESPACE + 'Username__c From Connection_Setting__mdt';  
        return base;
    }
}