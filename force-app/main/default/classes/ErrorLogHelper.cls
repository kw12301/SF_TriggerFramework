/**
* @author Kevin Winn
* @date 01/01/2020
* @group Error Log
* @description helper class for ErrorLog__c handling
*/
public with sharing class ErrorLogHelper 
{
	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get all error records that have not been deleted
	*/
	@auraEnabled
	public static List<ErrorLog__c> getErrorLogs()
	{
		List<ErrorLog__c> logs = new List<ErrorLog__c>();
		for(List<ErrorLog__c> records : [Select Id, Name, Object__c, ErrorType__c, ErrorStackTrace__c, CreatedDate,Duplicate__c 
											From ErrorLog__c 
											Where IsDeleted = false
											Order By CreatedDate])
		{
			if(!records.isEmpty())
			{
				logs.addAll(records);
			}
		}
		return logs;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by type name
	*
	@auraEnabled
	public static Map<String,Integer> getAggResultsByErrorType()
	{
		Map<String,Integer> aggMap = new Map<String,Integer>();
		for(List<AggregateResult> aggs : [Select ErrorType__c, COUNT(Id) qty
										From ErrorLog__c
										Group By ErrorType__c])
		{
			if(!aggs.isEmpty())
			{
				for(AggregateResult ar : aggs)
				{
					aggMap.put(String.valueOf(ar.get('ErrorType__c')),Integer.valueOf(ar.get('qty')));
				}
			}
			else{
				aggMap.put('No Errors',0);
			}	
		}
		return aggMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by Object name
	*
	@auraEnabled
	public static Map<String,Integer> getAggResultsByObjectType()
	{
		Map<String,Integer> aggMap = new Map<String,Integer>();
		for(List<AggregateResult> aggs : [Select Object__c, COUNT(Id) qty
										From ErrorLog__c
										Group By Object__c])
		{
			if(!aggs.isEmpty())
			{
				for(AggregateResult ar : aggs)
				{
					aggMap.put(String.valueOf(ar.get('Object__c')),Integer.valueOf(ar.get('qty')));
				}
			}
			else{
				aggMap.put('No Errors',0);
			}	
		}
		return aggMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by Created Date
	*
	@auraEnabled
	public static Map<Datetime,Integer> getAggResultsByCreatedDate()
	{
		Map<Datetime,Integer> aggMap = new Map<Datetime,Integer>();
		for(List<AggregateResult> aggs : [Select CreatedDate, COUNT(Id) qty
										From ErrorLog__c
										Group By CreatedDate])
		{
			if(!aggs.isEmpty())
			{
				for(AggregateResult ar : aggs)
				{
					aggMap.put(DateTime.valueOf(ar.get('CreatedDate')),Integer.valueOf(ar.get('qty')));
				}
			}
			else{
				aggMap.put(DateTime.now(),0);
			}	
		}
		return aggMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by type name filtered for one object
	* @param objectApiName the SObject API name to filter aggregate results by
	*
	@auraEnabled
	public static Map<String,Integer> getObjectAggResultsByErrorType(String objectApiName)
	{
		Map<String,Integer> aggMap = new Map<String,Integer>();
		for(List<AggregateResult> aggs : [Select ErrorType__c, COUNT(Id) qty
										From ErrorLog__c
										Where Object__c =: objectApiName
										Group By ErrorType__c])
		{
			if(!aggs.isEmpty())
			{
				for(AggregateResult ar : aggs)
				{
					aggMap.put(String.valueOf(ar.get('ErrorType__c')),Integer.valueOf(ar.get('qty')));
				}
			}
			else{
				aggMap.put('No Errors',0);
			}
		}
		return aggMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by Created Date filtered for one object
	* @param objectApiName the SObject API name to filter aggregate results by
	*
	@auraEnabled
	public static Map<Datetime,Integer> getObjectAggResultsByCreatedDate(String objectApiName)
	{
		Map<Datetime,Integer> aggMap = new Map<Datetime,Integer>();
		for(List<AggregateResult> aggs : [Select CreatedDate, COUNT(Id) qty
										From ErrorLog__c
										Where Object__c =: objectApiName
										Group By CreatedDate])
		{
			if(!aggs.isEmpty())
			{
				for(AggregateResult ar : aggs)
				{
					aggMap.put(DateTime.valueOf(ar.get('CreatedDate')),Integer.valueOf(ar.get('qty')));
				}
			}
			else{
				aggMap.put(DateTime.now(),0);
			}	
		}
		return aggMap;
	}

	/** 
	* @author Kevin Winn
	* @date 01/01/2020
	* @description get a map of count of errors by Created Date filtered for one object
	* @param objectApiName the SObject API name to filter aggregate results by
	*
	@auraEnabled
	public static List<ErrorLog__c> getErrorsByObject(String selectedObject)
	{
		return new List<ErrorLog__c>();
	}
*/
	public static void deleteAgedErrorLogs(Integer ageInDays)
	{
		Date age = (ageInDays < 0) ? Date.today() - ageInDays : (Date.Today() + (-1 * ageInDays));
		for(List<ErrorLog__c> records : [Select Id From ErrorLog__c WHere CreatedDate <= : age])
		{
			if(!records.isEmpty())
			{
				GlobalDMLHandler.deleteObjectList(records);
			}
		}
	}
}