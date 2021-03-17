({
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