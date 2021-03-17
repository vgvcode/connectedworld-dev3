({
	fetchByIdCallback : function(component, a) {
        var state = a.getState();
        console.log("State:" + state);
        component.set("v.initial", false)
        if (state === "SUCCESS") {
            console.log("processCallback: SUCCESS");
            var rv = a.getReturnValue();
            if (rv != null) {
                console.log("processCallback: Got return values: " +
                            "\nContact:" + rv['contact'] + 
                            "\nCount:" + rv['count'] + 
                            "\nAvgCorrect: " + rv['avgcorrect'] + 
                            "\nAvgTime: " + rv['avgtime'] + 
                            "\nPsList: " + rv['pslist'] + 
                            "\nAssignedPsList: " + rv['assignedpslist'] + 
                            "\nAdaptive Criteria: " + rv['adaptivecriteria'] + 
                            "\nExam Descriptive Names: " + rv['examdescnames'] + 
                            "\nExam Names: " + rv['examnames'] +
                            "\nNeed Hint: " + rv['needhint']);
                component.set("v.contact", rv['contact']);
                component.set("v.count", rv['count']);
                component.set("v.avgcorrect", rv['avgcorrect']);
                component.set("v.avgtime", rv['avgtime']);
                (rv['needhint'] == "true") ? component.set("v.needhint", true) : component.set("v.needhint", false);
                var psoptions = [];
                for (var i=0; i<rv['pslist'].length; i++) { 
                    var item = { "label" : rv['pslist'][i]['Name'], "value": rv['pslist'][i]['Id'] };
                    psoptions.push(item);
                }
                console.log('psoptions:' + psoptions);
                component.set("v.psoptions", psoptions);
                var psvalues = [];
                for (var i=0; i<rv['assignedpslist'].length; i++) { 
                    psvalues.push(rv['assignedpslist'][i]['Id']);
                }
                console.log('psvalues:' + psvalues);
                component.set("v.psvalues", psvalues);
                //this.createCriteria(component, rv['adaptivecriteria']);
                //component.set("v.adaptivecriteria", JSON.stringify(rv['adaptivecriteria']));
                if (!rv['examdescnames']) {
                    component.set("v.examdescnames", []);                                        
                } else {
	                component.set("v.examdescnames", rv['examdescnames'].split(','));                    
                }
                
                if (!rv['examnames']) {
                    component.set("v.examnames", []);
                } else {
	                component.set("v.examnames", rv['examnames'].split(','));                
                }
                //this.createReports(component);
            }
            else {
                console.log("processCallback: No / incorrect number of values returned");
                component.set("v.contact", "");
                component.set("v.reporturl", "no data");
            }
        } else if (state === "INCOMPLETE") {
            console.log("processCallback: INCOMPLETE");
        } else if (state === "ERROR") {
            console.log("processCallback: ERROR");
            var error = response.getError();
            if (error) {
                console.log("processCallback: Errors:" + error);
            }
        }		
	}
})