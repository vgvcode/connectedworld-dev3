public class adaptiveTest {

    public static void doGenerate(ID ae_id, String qbe_id, Map<Object, Object> cmap, Integer nq) {
		List<adaptive_question__c> aqList1 = new List<adaptive_question__c>();

        if (cmap.size() > 0) {
            for (Object t : cmap.keySet()) {
                //Select all the matching questions from question bank filtered by criteria and create a list
                String topic = String.valueOf(t);
                List<String> difficulty = (List<String>)(cmap.get(t));
                
                List<question__c> qList = [select id, quest__c, flex_tag_2__c from question__c where exam__c = :qbe_id and flex_tag_1__c = :topic and flex_tag_2__c in :difficulty];
                System.debug('Topic: ' + topic + ', Difficulty: ' + String.valueOf(difficulty) + ', qList size:' + qList.size());
                for (Question__c q : qList) {
                    adaptive_question__c aq = new adaptive_question__c(adaptive_exam__c = ae_id, question__c = q.Id);
                    aqList1.add(aq);
                }            
            }            
        } else {
            	//fetch all questions
                List<question__c> qList = [select id, quest__c, flex_tag_2__c from question__c where exam__c = :qbe_id];
                System.debug('qList size:' + qList.size());
                for (Question__c q : qList) {
                    adaptive_question__c aq = new adaptive_question__c(adaptive_exam__c = ae_id, question__c = q.Id);
                    aqList1.add(aq);
                }                        
        }
        system.debug('Aq List1:' + aqList1);
        
        //select questions randomly from this list to meet the required number of questions
		List<adaptive_question__c> aqList2 = new List<adaptive_question__c>();
        
        if (aqList1.size() > 0) {
            for (Integer ix=0; ix<nq; ix++) {
                Integer len = aqList1.size();
                Integer aqIndex = Integer.valueof((Math.random() * len));
                adaptive_question__c aq = aqList1.remove(aqIndex);
                System.debug('Removed question id:' + aq.question__c + ' from ' + aqIndex + ' of adaptive question list');
                aqList2.add(aq);            
            }
            
            insert(aqList2);            
        }
      
        system.debug('Succesfully generated ' + aqList2.size() + ' questions for adaptive exam:' + ae_id);
    }

    public static Map<Object, Object> generateFilterCriteria(String exam_id, String emp_id, Decimal max_threshold, Decimal min_threshold, Datetime fromDt, Datetime toDt) {
        AggregateResult[] agrList;
        
        if (fromDt == null && toDt == null) {
             agrList = [select flex_tag_1__c, flex_tag_2__c, avg(score__c)avg_score from exam_results_detail__c where test_taker__c = :emp_id and exam__c = :exam_id 
                        group by flex_tag_1__c, flex_tag_2__c];              
        }
        else if (fromDt != null && toDt == null) {
            agrList = [select flex_tag_1__c, flex_tag_2__c, avg(score__c)avg_score from exam_results_detail__c where test_taker__c = :emp_id and exam__c = :exam_id 
                       and lastModifiedDate >= :fromDt
                       group by flex_tag_1__c, flex_tag_2__c];          
        } else if (fromDt == null && toDt != null) {
            agrList = [select flex_tag_1__c, flex_tag_2__c, avg(score__c)avg_score from exam_results_detail__c where test_taker__c = :emp_id and exam__c = :exam_id 
                       and lastModifiedDate <= :toDt
                       group by flex_tag_1__c, flex_tag_2__c];                      
        } else {
             agrList = [select flex_tag_1__c, flex_tag_2__c, avg(score__c)avg_score from exam_results_detail__c where test_taker__c = :emp_id and exam__c = :exam_id 
                        and lastModifiedDate >= :fromDt and lastModifiedDate <= :toDt
                        group by flex_tag_1__c, flex_tag_2__c];           
        }
        
        // Topic	Difficulty	Avg Score
        // algebra 	1 			0.95
        // algebra 	2 			0.90
        // algebra 	3 			0.15
        // algebra 	4 			0.10
        // algebra 	5 			0.10
        // calculus 1 			0.92
        // calculus 2 			0.4
        // calculus 3 			0.7
        // calculus 4 			0.9
        // After applying criteria
        // algebra: [3, 4, 5] calculus: [2, 3, 5]
        
        System.debug('exam_id:' + exam_id + ', emp_id:' + emp_id);
        System.debug('agrList:' + agrList);
        Map<Object, Object> criteria_map = new Map<Object, Object>();
        
        List<String> d = null;

        for (AggregateResult ar : agrList) {
            Object topic = ar.get('flex_tag_1__c');
            Object level = ar.get('flex_tag_2__c');
            Object avg_score = ar.get('avg_score');
            System.debug('Topic:' + String.valueOf(topic));
            System.debug('Level:' + String.valueOf(level));
            System.debug('Avg Score:' + String.valueOf(avg_score));
			
            if (!criteria_map.containsKey(topic)) {
                //add all levels initially and remove as criteria are met
                d = new List<String>();
                d.add('1'); d.add('2'); d.add('3'); d.add('4'); d.add('5');
                criteria_map.put(topic, d);
                system.debug('Topic:' + topic + ' not present in criteria map');
                system.debug('Added default criteria:' + d);
            }
            
            //if score is >= than max threshold, remove this level in the criteria
            if (Double.valueOf(avg_score) >= max_threshold) {
                System.debug(avg_score + ' is >= ' + max_threshold);
                System.debug('Removing ' + level);
                d = (List<String>)criteria_map.get(topic);
                d.remove(d.indexOf(String.valueOf(level)));
                System.debug('List after removal of level:' + d);
            } else if (Double.valueOf(avg_score) < min_threshold) {
                    //if score is < min threshold, add the previous level back in the criteria
                    System.debug(avg_score + ' is < ' + min_threshold);
                    Integer int_level = Integer.valueOf(level);
                    if (int_level > 1) {
                        int_level = int_level - 1;
                        System.debug('Adding ' + int_level);
                        d = (List<String>)criteria_map.get(topic);
                        //add if not already present
                        if (!d.contains(String.valueof(int_level))) {
                            d.add(String.valueOf(int_level));
                            System.debug('List after addition of level:' + d);                                                            
                        }
                    }
                } else {
                    System.debug(avg_score + ' is >= ' + min_threshold + ' and < ' + max_threshold);
                }
            
            System.debug('Levels:' + d);

            //include questions from the lowest difficulty level - so ['3', '5', '4', '1'] will result in ['1']
            //if you need more levels, change the second argument from 1 to 2, 3 etc.
            List<String> lowestN = getLowestN(d, 1);
            System.debug('Topic:' + topic + ', LowestN:' + lowestN);
            criteria_map.put(topic, lowestN);
        }
              
        System.debug('Criteria Map:' + criteria_map);
        return criteria_map;
    }
     
    public static String map2jsonStr(Map<Object, Object> cmap) {
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        for(Object t : cmap.keyset()) {
            String tstr = String.valueOf(t);
            List<String> difficulty = (List<String>)(cmap.get(t));
	        gen.writeObjectField(tstr, difficulty);           
        }
        gen.writeEndObject();
    	return gen.getAsString();
    }
    
    public static void deleteOldQuestions(ID ae_id) {
        List<adaptive_question__c> old_questions = [select id from adaptive_question__c where adaptive_exam__c = :ae_id];
        Integer num = old_questions.size();
        delete(old_questions);
        System.debug('Successfully deleted ' + num + ' old questions');
    }
    
    public static List<String> getLowestN(List<String> difficulty, Integer n) {
        //Returns the list of lowest N values
        List<String> lowestN = new List<String>();
        difficulty.sort();
        if (difficulty.size() < n) {
            return difficulty;
        } else {
            for(Integer i=0; i<n; i++) {
                lowestN.add(difficulty.get(i));
            }                    
	        return lowestN;
        }
    }
}