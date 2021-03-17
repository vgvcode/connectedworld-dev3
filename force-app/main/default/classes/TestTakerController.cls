public with sharing class TestTakerController {    
	@AuraEnabled
    public static List<Contact> fetchFiftyContacts()
    {
        //find users whose profile == test taker and select contacts which were created from these users
        System.debug('Inside fetchFiftyContacts');
        //List<Contact> loc = [select id, name from contact where id in (select contactid from user where profile.name='test taker') limit 50];
        List<Contact> loc = [select id, name from contact where Account.Name = 'Customers' or Account.IsPersonAccount=True limit 50];
        System.debug(loc);
        return loc;
    }
    
	@AuraEnabled
    public static List<Contact> fetchFiftyContactsByName(String searchKey)
    {
        //find users whose profile == test taker and select contacts which were created from these users
        System.debug('Inside fetchFiftyContactsByName');
        String name = '%' + searchKey + '%';
		//return [select id, name from contact where id in (select contactid from user where profile.name='test taker' and name like :name) limit 50];
		return [select id, name from contact where (Account.Name = 'Customers' or Account.IsPersonAccount=True) and name like :name limit 50];
    }
    
    @AuraEnabled
    public static Contact fetchById2(String contactId) 
    {
        Contact c = [select id, name, phone from contact where id = :contactId]; 
        System.debug('fetchById2:' + c.name);
        return c;
    }
    
    @AuraEnabled
    public static map<String, Object> fetchById(String contactId)
    {
        System.debug('Inside fetchById:' + contactId);
        Map<String, Object> mapOfObj = new Map<String, Object>();

        Contact c = [select id, name from contact where id = :contactId];
        mapOfObj.put('contact', c); 													
        
        //count, avgcorrect, avgtime
        AggregateResult[] agrList = [select test_taker__c, count(id)ct, avg(time_taken__c)avgtime from exam_instance__c where test_taker__c = :contactId group by test_taker__c];
        if (agrList.size() == 1) {
            mapOfObj.put('count', Integer.valueOf(agrList[0].get('ct')));				
            mapOfObj.put('avgtime', Double.valueOf(agrList[0].get('avgtime')));			
        } else {
            mapOfObj.put('count', 0);
            mapOfObj.put('avgtime', 0);
        }
        
        System.debug('fetchById: mapOfObj:' + mapOfObj);

        //all permission sets
        List<PermissionSet> psList = [SELECT Id, Name FROM PermissionSet where IsOwnedByProfile = False and 
                                      (PermissionSet.Name like '%Level%' or PermissionSet.Name like '%Adaptive%')];
        if (psList == null) {
            psList = new List<PermissionSet>();
        }
        mapOfObj.put('pslist', psList);													        
        System.debug('fetchById: psList:' + psList);
                
        //assigned permission sets
        User u = [SELECT Id, Name, ContactId, Need_Hint__c from User where ContactId = :contactId];
        System.debug('User ID:' + u.id + ', ' + u.Name);
        List<PermissionSet> assignedPsList = [SELECT Id, Name from PermissionSet where IsOwnedByProfile = False and Id in 
                                                 (Select PermissionSetId FROM PermissionSetAssignment where AssigneeId = :u.Id)];
        if (assignedPsList == null) {
            assignedPsList = new List<PermissionSet>();
        }
        mapOfObj.put('assignedpslist', assignedPsList);									
        System.debug('fetchById: assignedPsList:' + assignedPsList);
		
        //adaptive criteria
        Adaptive_Exam__c[] aeList = [select id, name, exam__r.name, exam__r.descriptive_name__c, test_taker__r.name, criteria__c from adaptive_exam__c where test_taker__c = :contactId];
        System.debug('aeList:' + aeList);
		Map<String, Object> adaptiveCriteria = new Map<String, Object>();
        if ((aeList != null) && (aeList.size() > 0)) {
            for(Adaptive_Exam__c ae : aeList) {
	            Exam__c e = ae.exam__r;
                Map<String, Object> listOfCriteria = new Map<String, Object>();
                if (ae.Criteria__c != null) {
                    listOfCriteria = (Map<String, Object>) JSON.deserializeUntyped(ae.Criteria__c);                    
                }
                adaptiveCriteria.put(e.descriptive_name__c, listOfCriteria);  									                                                              
                }
            }
        
        mapOfObj.put('adaptivecriteria', adaptiveCriteria);
        System.debug('fetchById: adaptivecriteria:' + adaptiveCriteria);
        
        //exam names, exam ids
        String[] listOfExamDescNames = new String[0];
        String[] listOfExamNames = new String[0];
        String examDescNames = '';
        String examNames = '';
        List<Exam__c> examList = [select id, name, descriptive_name__c from exam__c where id in (select exam__c from exam_instance__c where test_taker__c = :contactId)];
        if (examList.size() > 0) {
            for(Exam__c e : examList) {
                listOfExamDescNames.add(String.valueOf(e.Descriptive_Name__c));
                listOfExamNames.add(String.valueOf(e.name));
            }
            examDescNames = String.join(listOfExamDescNames, ', ');
            examNames = String.join(listOfExamNames, ', ');
        } else {
            examDescNames = '';
            examNames = '';
    	}
        mapOfObj.put('examdescnames', examDescNames);									
        mapOfObj.put('examnames', examNames);            								
        System.debug('fetchById: examdescnames:' + examDescNames);
        System.debug('fetchById: examnames:' + examNames);
        
        mapOfObj.put('needhint', String.valueOf(u.Need_Hint__c));
        System.debug('fetchById: needhint: ' + u.Need_Hint__c);

        return mapOfObj;
    }
    
    @AuraEnabled
    public static void savePermissionSets(string contactId, string psvaluesStr) {
        System.debug('contactId:' + contactId);
        System.debug('psvaluesStr:' + psvaluesStr);
        
        //get the user with this contact id
        User u = [SELECT Id, Name, ContactId from User where ContactId = :contactId];
        System.debug('User:' + u);
        String assigneeId = u.Id;
        
        //fetch all the ps assignments for this user
        List<PermissionSet> oldPsList = [SELECT Id, Name from PermissionSet where IsOwnedByProfile = False and Id in 
                                         (Select PermissionSetId FROM PermissionSetAssignment where AssigneeId = :u.Id)];
        
        //fetch the new ps list (right side column)
        List<String> newPsIds = psvaluesStr.split(',');
        List<PermissionSet> newPsList = [SELECT Id, Name from PermissionSet where Id in :newPsIds];
        
        List<PermissionSetAssignment> insertPsaList = new List<PermissionSetAssignment>();

        //find the psa's that need to be inserted (those in the new list but not found in the old list )
        for(PermissionSet newPs : newPsList) {
            Boolean found = false;
            for(PermissionSet oldPs : oldPsList) {
                if (newPs.Id == oldPs.id) {
                    found = true;
                    System.debug('Found:' + newPs.Name + ' with id:' + newPs.Id);
                    break;
                }
            }
            if (! found) {
                System.debug('Not found:' + newPs.Name);
                //create new psa and add to psa list
                PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = newPs.id);
                insertPsaList.add(psa);
                //createExamSummary(contactId, newPs.Name);
                if (newPs.Name.containsIgnoreCase('Adaptive')) {
                    //String descName = newPs.Name.replaceAll('_', ' ');
                    //create adaptive exam - this will trigger creation of adaptive questions for this exam
                    //Exam__c baseExam = [select id, name, question_bank_exam__c from Exam__c where descriptive_name__c = :descName];
                    //system.debug('Making future call to create adaptive exam:' + newPs.Name + ' for ' + u.Name);
                    //createAdaptiveExam(baseExam.Id, contactId, newPs.Name + ' for ' + u.Name, baseExam.Question_Bank_Exam__c, baseExam.Number_of_adaptive_questions__c);
                    createAdaptiveExam2(newPs.Name, u.Name, u.contactId);
                }
            }            
        }

        if (insertPsaList.size() > 0) {
            System.debug('Insert PSA List:' + insertPsaList);
            insert(insertPsaList);
        } else {
            System.debug('Nothing to insert');
        }
        
        List<ID> deletePsIdList = new List<ID>();
        //find the psa's that need to be deleted (those in the old list but not found in the new list)
        for(PermissionSet oldPs : oldPsList) {
            Boolean found = false;
	        for(PermissionSet newPs : newPsList) {
                if (oldPs.id == newPs.id) {
                    found = true;
                    System.debug('Found, hence not to delete:' + oldPs.Name + ' with id:' + oldPs.Id);
                    break;
                }
            }
            if (! found) {
                System.debug('Not found, hence to be deleted:' + oldPs.Name + ' with id:' + oldPs.Id);
                //delete this from the list
                deletePsIdList.add(oldPs.Id);
                if (oldPs.Name.startsWithIgnoreCase('Adaptive')) {
                    String name = oldPs.Name + ' For ' + u.Name;
                    System.debug('Name of exam to be deleted:' + name);
                    deleteAdaptiveExam(contactId, name);
                }
            }
        }
        
        List<PermissionSetAssignment> deletePsaList = [select id from permissionsetassignment where permissionsetid in :deletePsIdList];
        if (deletePsaList.size() > 0) {
            System.debug('Delete PSA List:' + deletePsaList);
            delete(deletePsaList);
        } else {
            System.debug('Nothing to delete');
        }
    }
    
    @AuraEnabled
    public static void saveNeedHint(string contactId, Boolean needhint) {
        System.debug('contactId:' + contactId);
        System.debug('needhint:' + String.valueOf(needhint));
         
        //get the user with this contact id
        User u = [SELECT Id, Name, ContactId, Need_Hint__c from User where ContactId = :contactId];
        System.debug('User:' + u);
        
        u.Need_Hint__c = needhint;
        update(u);
    }
       
    //@future
    //not being used
    //public static void createAdaptiveExam(String baseExamId, String testTakerId, String descriptiveName, String questionBankExamId, Decimal numberOfQuestions) {
    //    //set as future method since permission set change and ae creation cannot occur in the same Apex block
    //    Adaptive_Exam__c ae = new Adaptive_Exam__c(
    //        Exam__c = baseExamId,
    //        Test_Taker__c = testTakerId,
    //        Name__c = descriptiveName,
    //        Question_Bank_Exam__c = questionBankExamId,
    //        Number_Of_Questions__c = numberOfQuestions
    //    );
    //    System.debug('createAdaptiveExam:' + ae.Name__c);
    //    //this will trigger creation of adaptive questions
	//	insert(ae);        
    //}
    
    @future
    public static void createAdaptiveExam2(String psName, String userName, Id contactId) {
        String baseExamDescName = psName.replaceAll('_', ' ');
        //create adaptive exam - this will trigger creation of adaptive questions for this exam
        Exam__c baseExam = [select id, name, question_bank_exam__c, number_of_adaptive_questions__c from Exam__c where descriptive_name__c = :baseExamDescName];
        system.debug('Making future call to create adaptive exam:' + psName + ' for ' + userName);

        //set as future method since permission set change and ae creation cannot occur in the same Apex block
        Adaptive_Exam__c ae = new Adaptive_Exam__c(
            Exam__c = baseExam.Id,
            Test_Taker__c = contactId,
            Name__c = psName + ' for ' + userName,
            //Question_Bank_Exam__c = baseExam.Question_Bank_Exam__c,
            Number_Of_Questions__c = baseExam.Number_of_adaptive_questions__c
        );
        System.debug('createAdaptiveExam:' + ae.Name__c);
        //this will trigger creation of adaptive questions
		insert(ae);        
    }    
    
    @future
    public static void deleteAdaptiveExam(String contactId, String name) {
        try {
            adaptive_exam__c ae = [select id, name__c from adaptive_exam__c where test_taker__c = :contactId and name__c = :name];
            delete(ae);
        } catch (Exception e) {
            System.debug('No exam found with name:' + name + ' for test_taker: ' + contactId);                        
        }        
    }
}