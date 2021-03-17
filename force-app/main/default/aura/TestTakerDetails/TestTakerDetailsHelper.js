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
                this.createCriteria(component, rv['adaptivecriteria']);
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
                this.createReports(component);
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
	},
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
    },
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
    },
    createReports : function(component) {
        var testTaker = component.get('v.contact')['Name'];
        var reportTypes = component.get('v.reportTypes'); // array of objects
        var examdescnames = component.get('v.examdescnames'); //array of strings
        var examnames = component.get('v.examnames'); //array of strings
        var allExamReports = [];
        for (var i=0; i < examdescnames.length; i++) {
	        var myReports = [];
            for (var j=0; j < reportTypes.length; j++) {
                var url = encodeURI("https://connectedworld-dev2-dev-ed.lightning.force.com/lightning/r/Report/" + 
                    		reportTypes[j].id + "/view" +
                    		"?fv0=" + testTaker +
                    		"&fv1=" + examnames[i]);
                var oneReport = {'name' : reportTypes[j].name, 'url' : url};
	            myReports.push(oneReport);
            }
            var thisExamReports = {'name' : examdescnames[i], 'reports' : myReports};
            console.log('Pushing:' + thisExamReports);
	        allExamReports.push(thisExamReports);
        }
        console.log('All exam reports:' + allExamReports);
		component.set("v.reports", allExamReports);
    },
    createCriteria : function(component, obj) {
        var acstr = '';
        try {
            for (var exam in obj) {
                acstr = acstr + exam + ':\n';
                var first = 1;
                for (var c in obj[exam]) {
                    acstr = acstr + '   ' + c;
                    if (first == 1) {
                        first = 0;
                        for (var lev in obj[exam][c]) {
                            acstr = acstr + " " + obj[exam][c][lev];
                        }
                    } else {
                        for (var lev in obj[exam][c]) {
                            acstr = acstr + " " + obj[exam][c][lev];
                        }
                    }
                }
                acstr = acstr + '\n';
            }
        } catch(err) {
            //do nothing - fall out gracefully
        }
	
        //var criteria = JSON.stringify(obj, undefined, 4).replace('/\\/g', '');
        component.set("v.adaptivecriteria", acstr);            
    }
})