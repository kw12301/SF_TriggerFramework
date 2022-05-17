/**
* @author Kevin Winn
* @date 04/11/2022
* @group Framework
* @description Utilities for SObject manipulation and identification
*/
public virtual class SObjectUtility {

    /**
    * @description Gets the type name of the SObject as a string.
    * @param SObject The SObject for which the name to be obtained.
    * @return Type: String
    */
    public static String getSObjectTypeName(SObject so) {
        return so.getSObjectType().getDescribe().getName();
    }

    /**
     *@description Validate string as acceptable for Salesforce Id.  Return null if invalid, otherwise valid Id as string
     *@param String the String value for the Id to validate
     *@return Type: String
    **/
    public static String validateId(String idParam) {
        String id = idParam == null ? '' : String.escapeSingleQuotes(idParam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches(StaticResources.ID_REGEX_PATTERN, id)) {
            return id;
        }
        return null;
    }

    /**
     *@description Method to mimic Select * functionality of SQL.  Builds string query to select all fields from given sobject name.
     *@param String The sobject name to select all fields from
     *@return Type: String
    **/
    public static String selectAllFields(String sobjectName) 
    {
        String query = ('SELECT ' + String.join(new List<String>(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().keySet()), ',') + ' FROM ' +sobjectName);
        return query;
    }

    /**
     *@description Method to mimic Select * functionality of SQL, but limited to mapped Addepar fields. 
     *@param String The sobject name to select all fields from
     *@param List<String> A list of strings containing the Salesforce field names mapped to Addepar fields.
     *@return Type: String
    **/
    public static String selectAllAddeparFields(String sobjectName,List<String> fieldList) {
        String query = ('Select ' + String.join(new List<String>(fieldList),',') + ' FROM ' + sobjectName);
        return query;
    }
}