/**
* @author Kevin Winn
* @date May 17, 2022
* @group Framework
* @description This factory creates the correct dispatcher and dispatches the trigger event(s) to the appropriate 
*               event handler(s). The dispatchers are automatically created using the Type API, hence dispatcher 
*               registration is not required for each dispatchers.
*/
public with sharing class TriggerFactory {
    /** 
    * @description Creates the appropriate dispatcher and dispatches the trigger event to the dispatcher's event handler method.
    * @param Schema.sObjectType Object type to process (SObject.sObjectType)
    */
    public static void createTriggerDispatcher(Schema.sObjectType soType) {
        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if (dispatcher == null){
            throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);
        }
        execute(dispatcher);
    }

    /** 
    * @description Dispatches to the dispatcher's event handlers.
    * @param ITriggerDispatcher A Trigger dispatcher that dispatches to the appropriate handlers
    */ 
    private static void execute(ITriggerDispatcher dispatcher) {
        TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap,
                                    Trigger.isBefore, Trigger.isAfter, Trigger.isDelete, 
                                    Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting);
        
        if (Trigger.isBefore) {
            dispatcher.bulkBefore(); //do bulk queries and caching
            if (Trigger.isDelete) {
                dispatcher.beforeDelete(tp);
            } else if (Trigger.isInsert) {
                dispatcher.beforeInsert(tp);
            } else if (Trigger.isUpdate) {
                dispatcher.beforeUpdate(tp);
            }        
        } else {
            dispatcher.bulkAfter(); //do bulk queries and caching
            if (Trigger.isDelete) {
                dispatcher.afterDelete(tp);
            } else if (Trigger.isInsert) {
                dispatcher.afterInsert(tp);
            } else if (Trigger.isUpdate) {
                dispatcher.afterUpdate(tp);
            } else if (Trigger.isUnDelete) {
                dispatcher.afterUnDelete(tp);
            }
        }
        dispatcher.andFinally();
    } 

    /** 
    * @description Gets the appropriate dispatcher based on the SObject. It constructs the instance of the dispatcher
    *               dynamically using the Type API. The name of the dispatcher has to follow this format:
    *               <ObjectName>TriggerDispatcher. For e.g. for the Feedback__c object, the dispatcher has to be named
    *               as FeedbackTriggerDispatcher.
    * @param Schema.sObjectType Object type to create the dispatcher
    * @return ITriggerDispatcher A trigger dispatcher  if one exists or null.
    */
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType) {
        String originalTypeName = soType.getDescribe().getName();
        String dispatcherTypeName = null;
        if (originalTypeName.toLowerCase().endsWith('__c')) {
            originalTypeName = null != MetadataQuery.NAMESPACE ? originalTypeName.substringAfter(MetadataQuery.NAMESPACE): originalTypeName;
            originalTypeName = originalTypeName.indexOf(StaticResources.FSC_NAMESPACE) != -1 ? originalTypeName.substringAfter(StaticResources.FSC_NAMESPACE) : originalTypeName;
            originalTypeName = originalTypeName.indexOf(StaticResources.SCHWAB_GATEWAY_NAMESPACE) != -1 ? originalTypeName.substringAfter(StaticResources.SCHWAB_GATEWAY_NAMESPACE) : originalTypeName;
            originalTypeName = originalTypeName.indexOf(StaticResources.ADDEPAR_V2_NAMESPACE) != -1 ? originalTypeName.substringAfter(StaticResources.ADDEPAR_V2_NAMESPACE) : originalTypeName;
            originalTypeName = originalTypeName.substringBefore('__c');
            dispatcherTypeName = originalTypeName + 'TriggerDispatcher';
        } else {
            //originalTypeName = null != MetadataQuery.NAMESPACE ? originalTypeName.substringAfter(MetadataQuery.NAMESPACE): originalTypeName;
            dispatcherTypeName = originalTypeName + 'TriggerDispatcher';
        }
        Type obType = Type.forName(dispatcherTypeName);
        ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
        return dispatcher;
    }
}