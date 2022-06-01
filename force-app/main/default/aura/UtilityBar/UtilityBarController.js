({
	// Sets an empApi error handler on component initialization
    onInit : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',true);
        let listener = component.find('apiEventListener');
        listener.subscribeToChannel(channel,true);
        helper.doInit(component,event,helper);
    },
    // Invokes the subscribe method on the empApi component
    subscribe : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',true);
        let listener = component.find('apiEventListener');
        listener.subscribeToChannel(channel,true);
        helper.doInit(component,event,helper);
    },
    // Invokes the unsubscribe method on the empApi component
    unsubscribe : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',false);
        let listener = component.find('apiEventListener');
        listener.unsubscribeFromChannel();
        helper.doInit(component,event,helper);
    },
    fireMessage : function(component,event,helper){
        let msg = component.get('v.message');
        let http = msg.data.payload.EndpointSetting__c + ' | Status: ';
        if(msg.data.payload.IsSuccess__c == true)            {
            helper.displayToast(component, 'success',http + msg.data.payload.StatusCode__c +' ' + msg.data.payload.Status__c);
        }
        else{
            helper.displayToast(component, 'warning',http + msg.data.payload.StatusCode__c +' ' + msg.data.payload.Status__c);
        }
    }
})