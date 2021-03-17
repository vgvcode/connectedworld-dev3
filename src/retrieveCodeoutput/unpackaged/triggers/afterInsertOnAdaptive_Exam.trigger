trigger afterInsertOnAdaptive_Exam on Adaptive_Exam__c (after insert) {
	//create the adaptive exam questions
    List<adaptive_question__c> aeqList = new List<adaptive_question__c>();

    for(Adaptive_Exam__c ae : Trigger.New) {
        Double n = ae.number_of_questions__c;
        Exam__c base_exam = [select id, question_bank_exam__c from exam__c where id = :ae.exam__c];
        String qbe_id = base_exam.question_bank_exam__c;
        System.debug('Question Bank Id:' + qbe_id);
        //String qbe_id = ae.Question_Bank_Exam__c;
        List<question__c> selected_questions_list = new List<question__c>();
        //get a few random questions for this adaptive exam
        if ((n > 0) && (qbe_id != null)) {
            List<question__c> qbe_questions_list = [select id, flex_tag_1__c from question__c where exam__c = :qbe_id];
            for(Integer i=0; i<n; i++) {
                Integer randomNumber = Integer.valueof((Math.random() * qbe_questions_list.size()));
                question__c q = qbe_questions_list.remove(randomNumber);
                selected_questions_list.add(q);            
            }
            //create adaptive question objects from selected questions
            for(question__c q : selected_questions_list) {
                adaptive_question__c aeq = new adaptive_question__c(adaptive_exam__c = ae.id, question__c = q.id);
                aeqList.add(aeq);
            }
        }
    }

    system.debug('afterInsertOnAdaptive_Exam: List to be inserted:' + aeqList);
    if (aeqList.size() > 0) {
        insert(aeqList);        
    }           
}