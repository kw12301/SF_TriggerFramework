/**
* @author Kevin Winn
* @date May 17, 2022
* @group Maintenance 
* @description scheduling for deletion of error log records
**/
public with sharing class DeleteErrorLogScheduled implements Schedulable {
	/**
	 * @description executes Schedulable Class.  Calls DeleteErrorLogBatch
	 * @param SchedulableContext the context of the Schedulable class
	 */
	public void execute(SchedulableContext sc)	{
		Database.executeBatch(new DeleteErrorLogBatch());
	}
}