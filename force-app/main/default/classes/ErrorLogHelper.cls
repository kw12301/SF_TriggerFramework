/**
* @author Kevin Winn
* @date 01/01/2020
* @group Helpers
* @description helper class for ErrorLog__c handling
*/
public with sharing class ErrorLogHelper {
	/** 
	* @description get all error records that have not been deleted
	*/
	@auraEnabled
	public static List<ErrorLog__c> getErrorLogs(){
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(List<ErrorLog__c> records : [Select Id, Name, Object__c, ErrorType__c, ErrorStackTrace__c, CreatedDate,Duplicate__c 
											From ErrorLog__c 
											Where IsDeleted = false
											Order By CreatedDate]){
			if(!records.isEmpty())	{
				logs.addAll(records);
			}
		}
		return logs;
	}

	/**
	 * @description method to delete error logs older than n days from today
	 * @param Integer the age in days
	 */
	public static void deleteAgedErrorLogs(Integer ageInDays){
		Date age = (ageInDays < 0) ? Date.today() - ageInDays : (Date.Today() + (-1 * ageInDays));
		for(List<ErrorLog__c> records : [Select Id From ErrorLog__c Where CreatedDate <= : age]){
			if(!records.isEmpty())	{
				GlobalDMLHandler.deleteObjectList(records);
			}
		}
	}
}