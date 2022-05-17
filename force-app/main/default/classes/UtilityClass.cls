/**
* @author Kevin Winn
* @version 0.1
* @param
* @return
* @exception
* @see
* @since
* @serial
* @deprecated
*/
public virtual class UtilityClass 
{
	/**
	* @author Hari Krishnan
	* @date 07/16/2013
	* @description Gets the type name of the SObject.
	* @param SObject The SObject for which the name to be obtained.
	* @return String - The type name.
	*/
	public static String getSObjectTypeName(SObject so) 
	{
		return so.getSObjectType().getDescribe().getName();
	}

	/**
	 *@author Kevin Winn
	 *@date 12/31/2019
	 *@description Validate string as acceptable for Salesforce Id
	 *@params idParam the String value for the Id to validate
	 *@return returns Id if valid, otherwise null
	**/
	public static String validateId(String idParam)
	{
		String id = idParam == null ? StaticResources.EMPTY_STRING : String.escapeSingleQuotes(idParam);
		if((id.length() == 15 || id.length() == 18) && Pattern.matches(StaticResources.ID_REGEX_PATTERN, id))
		{
			return id;
		}
		return null;
	}
}