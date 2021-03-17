({
    showTestTakerDetailsEventHandler: function(component, event, helper)
    {
        console.log('Inside showTestTakerDetailsEventHandler');
        var contactId = event.getParam("contactId");
        console.log('showTestTakerDetailsEventHandler: contactId:' + contactId);
        var action = component.get("c.fetchById");
        action.setParams({"contactId" : contactId});
        action.setCallback(this, function(a) {
            helper.fetchByIdCallback(component, a);
        });
        $A.enqueueAction(action);
        console.log('showTestTakerDetailsEventHandler: Enqueued action');
    }
})