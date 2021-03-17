({
    handleOptionsChange: function(component, event, helper)
    {
        component.set("v.optionsSaved", false);
    },
    optionsSave : function (component, event, helper) 
    {
        var contact = component.get("v.contact");
        var contactId = String(contact.Id);
        //alert(contactId);
        var psvalues = component.get("v.psvalues");
        var psvaluesStr = psvalues.join();
        //alert(psvaluesStr);
        var action = component.get("c.savePermissionSets");
        action.setParams({
            "contactId" : contactId, 
            "psvaluesStr" : psvaluesStr
        });
        action.setCallback(this, function(a) {
            helper.savePermissionSetsCallback(component, a);                          
        });
        //alert('Set callback');
        $A.enqueueAction(action);
        //alert('Enqueued action');
        console.log('savePermissionSets: Enqueued action');
    }
})