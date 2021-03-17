({
	searchKeyUp : function(component, event) 
    {
        var myEvent = $A.get("e.c:SearchKeyChange");
        myEvent.setParams({"searchKey" : event.target.value});
        myEvent.fire();		
	}
})