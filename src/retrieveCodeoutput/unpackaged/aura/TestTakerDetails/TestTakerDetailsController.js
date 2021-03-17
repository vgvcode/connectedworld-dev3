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
    },
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
    },
    handleCheckbox: function (component, event, helper)
    {
	    var checkComp = component.find("checkbox");
        component.set("v.needhint", checkComp.get("v.value"));
        component.set("v.needhintSaved", false);
	},
    needHintSave : function (component, event, helper) 
    {
        var contact = component.get("v.contact");
        var contactId = String(contact.Id);
        var needhint = component.get("v.needhint");
        var action = component.get("c.saveNeedHint");
        action.setParams({
            "contactId" : contactId, 
            "needhint" : needhint
        });
        action.setCallback(this, function(a) {
            helper.saveNeedHintCallback(component, a);                          
        });
        //alert('Set callback');
        $A.enqueueAction(action);
        //alert('Enqueued action');
        console.log('saveNeedHint: Enqueued action');
    }
})