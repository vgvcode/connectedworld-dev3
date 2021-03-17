trigger afterUpdateOnQuestion on Question__c (after update) {
    List<ID> qIDList = new List<ID>();    

    for(Question__c q : Trigger.New) {        
        System.debug('New q id:' + q.id);

        Question__c oldq = Trigger.oldMap.get(q.id);
        System.debug('Before update trigger. Old q id:' + oldq.id);

        if (oldq.image__c != q.image__c) {
            System.debug('Image was changed');
            //TO-DO:  Delete the old image from s3
            qIDList.add(q.id);
        }                    
    }

    //avoid recursive calls
    if (qIDList.size() > 0) {
	    //push all images to s3 in a future call
	    s3.richTextFieldToS3(qIDList);    
    }
}