({
  doInit : function(component, event, helper) {
	var action = component.get("c.fetchCertificationList");
    //alert('Fetching certifications');
    action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.certificationList",response.getReturnValue());            
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
    $A.enqueueAction(action);
   }
})