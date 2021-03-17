({
  doInit : function(component, event, helper) {
	var action = component.get("c.fetchTrendingCourseList");
    //alert('Fetching courses');
    action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.courseList",response.getReturnValue());            
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
   },
    
   navigateToCourseDetail: function(component, event, helper) {
       var recordId = event.getSource().get("v.title");
       $A.get("e.force:navigateToSObject").setParams({"recordId": recordId}).fire();
   }
})