({
    savePermissionSetsCallback : function(component, a) {
        var state = a.getState();
        console.log("State:" + state);
        if (state === "SUCCESS") {
            component.set("v.optionsSaved", true);
			alert('Data saved succesfully!');
        } else if (state === "INCOMPLETE") {
            console.log("savePermissionSetsCallback: INCOMPLETE");
        } else if (state === "ERROR") {
            console.log("savePermissionSetsCallback: ERROR");
            var error = response.getError();
            if (error) {
                console.log("savePermissionSetsCallback: Errors:" + error);
            }
        }	
    }
})