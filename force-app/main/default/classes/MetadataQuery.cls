/**
* @author Kevin Winn
* @date May 17, 2022
* @group Metadata Tooling
* @description Trading Metadata
*               Contains methods to cache all expected fields from metadata settings to support integration.
*               New fields added to future releases will need to be added to query methods in this class
*/
public with sharing class MetadataQuery {

	/**
    * @description method to cache the Namespace for this package
    * @return Type: String
    */
    public static final String NAMESPACE = StaticResources.ADDEPAR_V3_NAMESPACE;
  
    /**
    * @description cache all Connection Settings
    * @return Type: ConnectionSetting__mdt[]
    */
    public static ConnectionSetting__mdt[] getConnectionSettings() {
        ConnectionSetting__mdt[] settings = Database.query(connectionSettingsQuery());
        return settings;
    }

    /**
    * @description cache all Endpoint Settings
    * @return Type: EndpointSetting__mdt[]
    */
    public static EndpointSetting__mdt[] getEndpointSettings() {
        EndpointSetting__mdt[] settings = Database.query(endpointSettingsQuery());
        return settings;
    }

    /**
    * @description cache all Endpoint Settings
    * @return Type: Persona__mdt[]
    */
    public static Persona__mdt[] getPersonas() {
        Persona__mdt[] settings = Database.query(personasQuery());
        return settings;
    }

    /**
    * @description cache all field settings
    * @return Type: TradingField__mdt[]
    */
    public static TradingField__mdt[] getTradingFields() {
        TradingField__mdt[] settings = Database.query(tradingFieldsQuery());
        return settings;
    }

    /**
    * @description cache all AP field settings
    * @return Type: TradingMap__mdt[]
    */
    public static TradingMap__mdt[] getTradingMaps() {
        TradingMap__mdt[] settings = Database.query(tradingMapQuery());
        return settings;
    }

    /**
    * @description cache all AP field settings
    * @return Type: TradingObject__mdt[]
    */
    public static TradingObject__mdt[] getTradingObjects() {
        TradingObject__mdt[] settings = Database.query(tradingObjectsQuery());
        return settings;
    }

    /**
    * @description cache all AP field settings
    * @return Type: TradingSchema__mdt[]
    */
    public static TradingSchema__mdt[] getTradingSchemas() {
        TradingSchema__mdt[] settings = Database.query(tradingSchemaQuery());
        return settings;
    }

    /**
    * @author Kevin Winn
    * @return Type: TradingSetting__mdt[]
    */
    public static List<TradingSetting__mdt> getTradingSettings() {
        TradingSetting__mdt[] settings = Database.query(tradingSettingsQuery());
        return settings;
    }

    /**
    * @description prepare query string for standard metadata fields
    * @return Type: String
    * @see https://help.salesforce.com/articleView?id=custommetadatatypes_accessing.htm&amp;type=5
    */
    private static String standardMetaFieldsQuery() {
        return 'Select Id,MasterLabel,QualifiedAPIName,NameSpacePrefix,';
    }

    /**
    * @description prepare query string for Connection Settings metadata object
    * @return Type: String
    */
    private static String connectionSettingsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'APIKey__c,'+
        		NAMESPACE + 'APISecret__c,'+
        		NAMESPACE + 'APIVersion__c,'+
        		NAMESPACE + 'BaseURL__c,'+
        		NAMESPACE + 'FirmId__c,'+
        		NAMESPACE + 'Password__c,'+
                NAMESPACE + 'FirmDomain__c,'+
                NAMESPACE + 'Username__c From ConnectionSetting__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Endpoint Settings metadata object
    * @return Type: String
    */
    private static String endpointSettingsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'ConnectionSetting__c,'+
                NAMESPACE + 'HttpVerb__c,'+
                NAMESPACE + 'ContentType__c,'+
                NAMESPACE + 'ApiVersionVariable__c,'+
                NAMESPACE + 'EndpointURL__c,'+
                NAMESPACE + 'FirmUrlVariable__c,'+
                NAMESPACE + 'ConnectionSetting__r.QualifiedAPIName From EndpointSetting__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Endpoint Settings metadata object
    * @return Type: String
    */
    private static String personasQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + StaticResources.IS_ACTIVE_FIELD +','+
                NAMESPACE + StaticResources.IS_TEST_DATA +','+
                NAMESPACE + StaticResources.INLINE_HELP_TEXT+','+
                NAMESPACE + StaticResources.ICON_URL+','+
                NAMESPACE + StaticResources.CARD_BODY+','+
                NAMESPACE + StaticResources.NODE+ ' From Persona__mdt Order By QualifiedAPIName ASC';  
        return base;
    }



    /**
    * @description prepare query string for Trading Fields metadata object
    * @return Type: String
    */
    private static String tradingFieldsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'APIName__c From TradingField__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Trading Map metadata object
    * @return Type: String
    */
    private static String tradingMapQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'RecordTypeDeveloperName__c,'+
        		NAMESPACE + 'SyncDirection__c,'+
        		NAMESPACE + 'SObject__c,'+
                NAMESPACE + 'SObject__r.QualifiedAPIName,'+
        		NAMESPACE + 'SObjectField__c,'+
                NAMESPACE + 'SObjectField__r.QualifiedAPIName,'+
                NAMESPACE + 'TradingField__c,'+
                NAMESPACE + 'TradingField__r.QualifiedAPIName From TradingMap__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Trading Object metadata object
    * @return Type: String
    */
    private static String tradingObjectsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'APIName__c From TradingObject__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Trading Map metadata object
    * @return Type: String
    */
    private static String tradingSchemaQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'DecimalPlaces__c,'+
        		NAMESPACE + 'DisplayName__c,'+
        		NAMESPACE + 'FieldType__c,'+
                NAMESPACE + 'NumberLength__c,'+
                NAMESPACE + 'PicklistValues__c,'+
        		NAMESPACE + 'Required__c,'+
                NAMESPACE + 'TradingObject__c,'+
                NAMESPACE + 'TradingObject__r.QualifiedAPIName,'+
                NAMESPACE + 'TradingField__c,'+
                NAMESPACE + 'TradingField__r.QualifiedAPIName From TradingSchema__mdt';  
        return base;
    }

    /**
    * @description prepare query string for Trading Settings metadata object
    * @return Type: String
    */
    private static String tradingSettingsQuery() {
        String base = standardMetaFieldsQuery();
        base += NAMESPACE + 'Namespace__c,'+
                NAMESPACE + 'TradingEnabledAttribute__c From TradingSetting__mdt';  
        return base;
    }    
}