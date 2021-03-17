trigger afterUpdateOnAdaptive_Exam on Adaptive_Exam__c (after update) {
    //update the records via future call
    for (adaptive_exam__c ae : Trigger.New) {
        //this will prevent recursive update        
        if (ae.Attempts__c >= ae.min_attempts__c) {
            System.debug('Making future call to updateAdaptiveExam');
            updateAdaptiveExam.doUpdate(ae.id);
            System.debug('Completed future call to updateAdaptiveExam');            
        }
    }
}