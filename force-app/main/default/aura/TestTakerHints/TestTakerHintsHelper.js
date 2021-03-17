({
    saveNeedHintCallback : function(component, a) {
        var state = a.getState();
        console.log("State:" + state);
        if (state === "SUCCESS") {
            component.set("v.needhintSaved", true);
			alert('Data saved succesfully!');
        } else if (state === "INCOMPLETE") {
            console.log("saveNeedHintCallback: INCOMPLETE");
        } else if (state === "ERROR") {
            console.log("saveNeedHintCallback: ERROR");
            var error = response.getError();
            if (error) {
                console.log("saveNeedHintCallback: Errors:" + error);
            }
        }	        
    }
})