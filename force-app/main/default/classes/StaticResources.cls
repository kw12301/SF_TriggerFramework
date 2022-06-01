/**
* @author Kevin Winn
* @date May 17, 2022
* @group Constants
* @description contains all hard-coded values and constants
*/
public with sharing class StaticResources {  
	//namespace
	public static final String FSC_NAMESPACE = 'FinServ__';
    public static final String SCHWAB_GATEWAY_NAMESPACE = 'CSOVG__';
    public static final String ADDEPAR_V2_NAMESPACE = 'addeparsf__';
    public static final String ADDEPAR_V3_NAMESPACE = '';
    public static final String THIS_PACKAGE_NAMESPACE = ADDEPAR_V3_NAMESPACE;

    //Metadata
    public static final String QUALIFIED_API_NAME = 'QualifiedAPIName';
    public static final String ID_FIELD = 'Id';
    public static final String PROTECTED_X = 'Protected_x';
    public static final String MASTER_LABEL = 'MasterLabel';
    public static final String IS_TEST_DATA = 'IsTestData__c';
    public static final String INLINE_HELP_TEXT = 'InlineHelpText__c';
    public static final String HELP_LINK = 'HelpLink__c';
    public static final String IS_ACTIVE_FIELD = 'IsActive__c';
    public static final String CONNECTION_OBJECT = 'ConnectionSettings.';
    public static final String SYSTEM_DEFAULT = 'Default';
    public static final String SYSTEM_TEST = 'SystemTest';
	
    //regex
    public static final String EMPTY_STRING = '';
    public static final String EMPTY_SPACE = ' ';
    public static final String AMPRASAND = '&';
    public static final String EQUAL = '=';
    public static final String SEMICOLON = ';';
    public static final String SINGLE_LINE = ' - ';
    public static final String QUESTION_MARK = '?';
    public static final String NEW_STATUS = 'New';
    public static final String TRUE_STRING = 'True';
    public static final String FORWARD_SLASH = '/';
    public static final String BACK_SLASH = '\\';
    public static final String LINE_BREAK = '\n';
    public static final String OPEN_SQUARE_BRACKET = '[';
    public static final String CLOSED_SQUARE_BRACKET = ']';
    public static final String OPEN_HTTPS = 'https://';
    public static final String ID_REGEX_PATTERN = '^[a-zA-Z0-9]*$';
    public static final String RECORDTYPE = 'RecordType';
    public static final String METADATA_CUSTOM_FIELD = 'CustomField';
    public static final String FAULT = 'Fault';
    public static final String FAULT_STRING = 'faultstring';
    public static final String HTML_BOLD_OPEN = '<b>';
    public static final String HTML_BOLD_CLOSE = '</b>';

    //exceptions
    public static final String SALESFORCE_EXCEPTION = 'Salesforce exception';
    public static final String INTEGRATION_EXCEPTION = 'Integration exception';
    public static final String NO_ACCESS_EXCEPTION = 'No Access exception';
    public static final String QUERY_EXCEPTION = 'Query exception';
    public static final String TYPE_EXCEPTION = 'Type exception';
    public static final String EVENT_BUS_EXCEPTION = 'Event Bus Exception';

    //Library
    public static final String ADDEPAR_LIBRARY_NAME = 'Addepar';
    public static final String ADDEPAR_ENTITY_TYPES_FILE = 'Entity Types';
    public static final String ADDEPAR_ALL_ATTRIBUTES_FILE = 'All Attributes';

    //base url and extensions
    public static final String URL_BASE = String.valueOf(URL.getSalesforceBaseUrl());
    public static final String URL_BASE_EXTERNAL_FORM = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()) + FORWARD_SLASH;
    public static final String URL_DEV_CONSOLE_BASE = '_ui' + FORWARD_SLASH + 'common' + FORWARD_SLASH + 'apex' + FORWARD_SLASH + 'debug' + FORWARD_SLASH + 'ApexCSIPage';
    public static final String URL_DEV_CONSOLE = URL_BASE_EXTERNAL_FORM + URL_DEV_CONSOLE_BASE;

    //apex rest services
    public static final String REST_BASE = URL_BASE_EXTERNAL_FORM + 'services/apexrest/';

    //aura docs link
    public static final String MY_DOMAIN_URL = String.valueOf(URL.getOrgDomainUrl().toExternalForm());
    public static final String MY_DOMAIN = MY_DOMAIN_URL.substringBefore('.');
    public static final String AURA_DOC_BASE = '.lightning.force.com' + FORWARD_SLASH + 'auradocs' + FORWARD_SLASH + 'reference.app#reference?descriptor=c:ToolingApp&defType=application';
    public static final String AURA_REFERENCE_DOC_APP = MY_DOMAIN + AURA_DOC_BASE;

    //ErrorLog picklist values
    public static final List<Schema.PicklistEntry> PICKLIST_ERROR_OBJECT = ErrorLog__c.Object__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> PICKLIST_ERROR_TYPE = ErrorLog__c.ErrorType__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> PICKLIST_ERROR_SUBTYPE = ErrorLog__c.ErrorType__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> PICKLIST_ERROR_DML_TYPE = ErrorLog__c.DMLType__c.getDescribe().getPicklistValues();
    public static final List<Schema.PicklistEntry> PICKLIST_ERROR_DML_STATUSCODE = ErrorLog__c.DMLStatusCode__c.getDescribe().getPicklistValues();
    
    //default push topic constants
    public static final String PUSHTOPIC_NAME = 'LoggingHandlerSpy';
    public static final String PUSHTOPIC_QUERY = 'Select Id, Name, CreatedDate, CreatedById, LastModifiedById, Cause__c, DMLId__c, ' +
                                                    'DMLIndex__c, DMLMessage__c,DMLFieldNames__c, DMLFields__c, DMLRecords__c, DMLStatusCode__c, ' +
                                                    'DMLType__c, ErrorSubType__c,ErrorType__c, LineNumber__c, Message__c, Object__c From ErrorLog__c';
    public static final Decimal PUSHTOPIC_API_VERSION = 54.0;
    public static final Boolean PUSHTOPIC_NOTIFY_CREATE = true;
    public static final Boolean PUSHTOPIC_NOTIFY_UPDATE = true;
    public static final Boolean PUSHTOPIC_NOTIFY_UNDELETE = true;
    public static final Boolean PUSHTOPIC_NOTIFY_DELETE = true;
    public static final String PUSHTOPIC_NOTIFY_FIELDS = 'Referenced';

    //test constants    
    public static final String TEST_LOGGING_SETTINGS_NAME = 'TestPurge';
    public static final Integer TEST_LIST_SIZE = 10;
    public static final Integer TEST_BULK_SIZE = 200;
    public static final Integer TEST_CHUNK_SIZE = 10000;
    public static final String TEST_CRON_JOB_EXPRESSION = '0 0 0 * * ?';
    public static final String TEST_SOAP_ENDPOINT = 'https://test.salesforce.com/services/SOAP/u/29.0';
    public static final String TEST_CUSTOMER_ONE = 'Customer 1';
    public static final String TEST_CUSTOMER_TWO = 'Customer 2';
    public static final String TEST_PREFIX = 'TEST_';
    public static final String TEST_ERRORLOG_TYPE = SALESFORCE_EXCEPTION;
    public static final String TEST_ERRORLOG_SUBTYPE = 'System.DMLException';
    public static final String TEST_ERRORLOG_OBJECT = 'Account';
    public static final String TEST_ERRORLOG_STATECODE = 'YY';
    public static final String TEST_ERRORLOG_DML_TYPE = 'FIELD_INTEGRITY_EXCEPTION';
    public static final String TEST_ERRORLOG_DML_FIELDS = '(BillingStateCode)';
    public static final String TEST_ERRORLOG_DML_MESSAGE = 'The BillingStateCode field contains ZZ, which isn\'t an available state. Your administrator can add it for you.';

}