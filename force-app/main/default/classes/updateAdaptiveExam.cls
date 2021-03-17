public class updateAdaptiveExam {
    @future(callout=true)
    public static void doUpdate(string recId) {
        adaptive_exam__c ae = [select id, exam__c, lastModifiedDate, attempts__c, number_of_questions__c, 
                               test_taker__c, question_pass_threshold__c, question_fail_threshold__c,
                               from__c, to__c from adaptive_exam__c where id = :recId];
        //if we want to use date check
        //Date start_date = ae.LastModifiedDate.date();
        //Date current_date = Date.today();
        //Integer days = start_date.daysBetween(current_date);
        //System.debug('Days:' + days);
        
        ae.attempts__c = 0;
        
        //delete the previous questions
        adaptiveTest.deleteOldQuestions(ae.id);
        String qbe_id = ae.exam__r.question_bank_exam__c;
        
        System.debug('Qbe:' + qbe_id + ', Test Taker:' + ae.Test_Taker__c + 
                     ', Question Pass Threshold:' + ae.Question_Pass_Threshold__c + ', Question Fail Threshold:' + ae.Question_Fail_Threshold__c +
                     ', From:' + ae.From__c + ', To:' + ae.To__c);
        Map<Object, Object> cmap = adaptiveTest.generateFilterCriteria(qbe_id, ae.Test_Taker__c, ae.Question_Pass_Threshold__c, ae.Question_Fail_Threshold__c, ae.from__c, ae.to__c);
        
        //store the map as json in the adaptive exam
        String cmapStr = adaptiveTest.map2jsonStr(cmap);
        if (cmapStr == null) {
            ae.Criteria__c = 'All questions';
        } else {
            ae.Criteria__c = cmapStr;
        }
        
        Integer number_of_questions = ae.number_of_questions__c.intValue();
        
        adaptiveTest.doGenerate(ae.id, qbe_id, cmap, number_of_questions);
        update(ae);
    }
}