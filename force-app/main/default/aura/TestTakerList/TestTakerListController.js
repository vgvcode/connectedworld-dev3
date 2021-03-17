({
    //on page load, fetch fifty contacts
	doInit : function(component, event) {
        var action = component.get("c.fetchFiftyContacts");
        action.setCallback(this, function(a)
                           {
                               component.set("v.contacts", a.getReturnValue());
                           });
       	$A.enqueueAction(action);
	},
    //when a name is typed in search bar, fetch contacts matching the name
    searchKeyChange: function(component, event) {
        var searchKey = event.getParam("searchKey");
        var action = component.get("c.fetchFiftyContactsByName");
        action.setParams({"searchKey" : searchKey});
        action.setCallback(this, function(a) 
                           {
                               component.set("v.contacts", a.getReturnValue());
                           });
        $A.enqueueAction(action);
    },
    fireShowDetailsEvent: function (component, event, helper) 
    {
		var contactId = event.getSource().get("v.title");
        //alert("You clicked: " + contactId);
        console.log("contactId:" + contactId);
        
        var myEvent = $A.get("e.c:EventShowTestTakerDetails");
        myEvent.setParams({"contactId" : contactId});
        myEvent.fire();	 
        console.log("Fired c:EventShowTestTakerDetails event");
    }
})