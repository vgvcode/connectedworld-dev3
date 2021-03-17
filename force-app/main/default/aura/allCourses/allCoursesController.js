({
  doInit : function(component, event, helper) {
	var action = component.get("c.fetchCourseList");
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
	   //var navService = cmp.find("navService");       
       //var title = event.getSource().get("v.title");
       //var params = title.split(",");
       //console.log(params[0]);
       //alert(params[0]);
       //alert(params[1]);
       //var pageReference = {
       //     type: "comm__namedPage",
       //     attributes: {
       //         name: "Course Detail",
       //         recordId: params[0],
       //         streamId: params[1]
       //     }           
       //};
       // Set the URL on the link or use the default if there's an error
	   //navService.navigate(pageReference); 
       //$A.get("e.force:navigateToSObject").setParams({"recordId": recordId}).fire();
       var recordId = event.getSource().get("v.title");
       $A.get("e.force:navigateToSObject").setParams({"recordId": recordId}).fire();
   }
})