/**
* @author Kevin Winn
* @date 01/01/2020
* @group Framework
* @description Constructor for EventParameters framework
*/
public with sharing class EventParameters {

	/**
	 * @description enums for platform events.
	 * 			fullPush: push all records for sObject to Addepar based on TradingSchema settings
	 * 			fullPull: pull all records for Sobject from Addepar based on TradingSchema settings
	 * 			fieldsPush: push Sobject fields to Addepar based on TradingSchema settings
	 * 			fieldsPull: pull Sobject fields from Addepar based on TradingSchema settings
	 */
	public Enum	PlatformEvent {fullPush, fullPull, fieldsPush, fieldsPull}

	/**
	 * @Description Constructor for PlatformEven enum
	 */
	public PlatformEvent sierraEvent;

	
	public EventParameters() {
		
	}
}