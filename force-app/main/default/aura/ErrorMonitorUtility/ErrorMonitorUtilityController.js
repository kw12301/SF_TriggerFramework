({
	// Sets an empApi error handler on component initialization
    onInit : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',true);
        let listener = component.find('errorEventListener');
        listener.subscribeToChannel(channel,true);
        helper.doInit(component,event,helper);
    },
    // Invokes the subscribe method on the empApi component
    subscribe : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',true);
        let listener = component.find('errorEventListener');
        listener.subscribeToChannel(channel,true);
        helper.doInit(component,event,helper);
    },
    // Invokes the unsubscribe method on the empApi component
    unsubscribe : function(component, event, helper) {
        let channel = component.get('v.channel');
        let subscribed = component.set('v.subscribe',false);
        let listener = component.find('errorEventListener');
        listener.unsubscribeFromChannel();
        helper.doInit(component,event,helper);
    },
    fireMessage : function(component,event,helper){
        helper.prepareToast(component,event,helper);
    }
})