/**
* @author Kevin Winn
* @date 12/31/2019
* @group Scheduled Apex
* @description scheduling for deletion of error log records
* @see DeleteErrorLogBatch 
**/
public with sharing class DeleteErrorLogScheduled implements Schedulable
{
	public void execute(SchedulableContext sc)
	{
		Database.executeBatch(new DeleteErrorLogBatch());
	}
}