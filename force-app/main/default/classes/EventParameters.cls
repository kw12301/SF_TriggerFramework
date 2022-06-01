/**
* @author Kevin Winn
* @date 01/01/2020
* @group Event Framework
* @description Constructor for EventParameters framework
*/
public with sharing class EventParameters {

	/**
	 * @description enums for platform events.
	 * 			FULL_PUSH: push all records for sObject to Addepar based on TradingSchema settings
	 * 			FULL_PULL: pull all records for Sobject from Addepar based on TradingSchema settings
	 * 			FIELDS_PUSH: push Sobject fields to Addepar based on TradingSchema settings
	 * 			FIELDS_PULL: pull Sobject fields from Addepar based on TradingSchema settings
	 */
	public Enum	PlatformEvent {FULL_PUSH, FULL_PULL, FIELDS_PUSH, FIELDS_PULL}

	/**
	 * @Description Constructor for PlatformEven enum
	 */
	public PlatformEvent sierraEvent;

	
	public EventParameters() {
		
	}
}