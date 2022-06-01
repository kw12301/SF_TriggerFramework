({
	doInit : function(component,event,helper) {
		
	},
	prepareToast: function(compnent,event,helper){
		let msg = component.get('v.message');
        let recId = msg.data.payload.Id__c;
        let totalErrors = msg.data.payload.TotalErrors__c;
        let cat = msg.data.payload.Category__c;
        let cattype = msg.data.payload.Type__c;
        let errmsg = msg.data.payload.Message__c;
        let response = totalErrors + ' error(s) occurred: ' + 'Error Id: ' + recId + ' Message: ' + errmsg;
        helper.displayToast(component, 'error',response);

	},
	displayToast: function (component, type, message) {
    	const toastEvent = $A.get('e.force:showToast');
    	toastEvent.setParams({
			title: 'Something went wrong',
      		type: type,
      		message: message,
            mode: 'sticky'
    	});
    	toastEvent.fire();
  	},
})