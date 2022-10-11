/**
 * @author Kevin Winn
 * @date 04/11/2022
 * @group Utilities
 * @description Utilities for SObject manipulation and identification
 */
public virtual class SObjectUtility {
  /**
   * @description Gets the type name of the SObject as a string.
   * @param SObject The SObject for which the name to be obtained.
   * @return Type: String
   * @example SObjectUtility.getSObjectTypeName(new Account());
   */
  public static String getSObjectTypeName(SObject so) {
    return so.getSObjectType().getDescribe().getName();
  }

  /**
   * @description Dynamically construct a new SObject based on the given name
   * @param String the string name for the SObject to construct
   * @return Type: SObject
   * @example SObjectUtility.getSObjectForName('Account');
   */
  public static SObject getSObjectForName(String sobjectName) {
    return Schema.getGlobalDescribe()
      .get(StringUtils.secureString(sobjectName))
      .newSobject();
  }

  /**
   * @description Gets the Schema.DescribeSObjectResult of the SObject.
   * @param SObject The SObject to describe.
   * @return Type: Schema.DescribeSObjectResult
   * @example SObjectUtility.getSObjectDescribeResult(new Account());
   */
  public static Schema.DescribeSObjectResult getSObjectDescribeResult(
    SObject so
  ) {
    return so.getSObjectType().getDescribe();
  }

  /**
     *@description Validate string as acceptable for Salesforce Id.  Return null if invalid, otherwise valid Id as string
     *@param String the String value for the Id to validate
     *@return Type: String
     @example SObjectUtility.validateId('xxxxxxxxxxxxxxxxxx');
    **/
  public static String validateId(String idParam) {
    String id = idParam == null ? '' : StringUtils.secureString(idParam);
    if (
      (id.length() == 15 || id.length() == 18) &&
      Pattern.matches(StaticResources.ID_REGEX_PATTERN, id)
    ) {
      return id;
    }
    return null;
  }

  /**
   *@description Method to mimic Select * functionality of SQL.  Builds string query to select all createable fields from given sobject name.
   *@param String The sobject name to select all fields from
   *@return Type: String
   *@example Database.query(SObjectUtility.selectAllCreateableFields('Account'));
   **/
  public static String selectAllCreateableFields(String sobjectName) {
    String query = ('SELECT ' +
    String.join(
      new List<String>(
        getCreatableFields(StringUtils.secureString(sobjectName))
      ),
      ','
    ) +
    ' FROM ' +
    StringUtils.secureString(sobjectName));
    return query;
  }

  /**
   *@description Method to mimic Select * functionality of SQL, but limited to mapped Addepar fields.
   *              If the running user cannot access all fields on the given object, a query exception is thrown.
   *@param String The sobject name to select all fields from
   *@param List<String> A list of strings containing the Salesforce field names mapped to Addepar fields.
   *@return Type: String
   *@example Database.query(SObjectUtility.selectAllAddeparFields('Account',listOfFieldNames));
   **/
  public static String selectAllAddeparFields(
    String sobjectName,
    List<String> fieldList
  ) {
    String query = ('Select ' +
    String.join(new List<String>(StringUtils.secureString(fieldList)), ',') +
    ' FROM ' +
    StringUtils.secureString(sobjectName));
    return query;
  }

  /**
   * @description Method to get all Creatable fields for an SObject.  Used with SelectAllFields to ensure FLS is enforced
   * @param String the string representation of the SObject name
   * @return Type: Set<String> all creatable fields for the SObject
   * @example SObjectUtility.getCreateableFields('Account');
   */
  public static Set<String> getCreatableFields(String sobjectName) {
    Set<String> results = new Set<String>();
    SObject sobj = getSObjectForName(StringUtils.secureString(sobjectName));
    AccessControls controls = AccessControls.getSObjectAccessControls(sobj);
    if (controls.invalidRequest || !controls.sObjectAccess.isCreateable) {
      return results;
    } else {
      Map<String, Schema.SobjectField> fields = sobj.getSObjectType()
        .getDescribe()
        .fields.getMap();
      for (String f : fields.keySet()) {
        if (
          (f.toLowerCase() != 'name') &&
          fields.get(f).getDescribe().isCreateable()
        ) {
          results.add(f.toLowerCase());
        }
      }
      return results;
    }
  }
}
