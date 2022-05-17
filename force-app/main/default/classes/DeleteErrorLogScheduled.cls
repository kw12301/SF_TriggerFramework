/**
* @author Kevin Winn
* @date May 17, 2022
* @group Scheduled 
* @description scheduling for deletion of error log records
**/
public with sharing class DeleteErrorLogScheduled implements Schedulable {
	public void execute(SchedulableContext sc)	{
		Database.executeBatch(new DeleteErrorLogBatch());
	}
}