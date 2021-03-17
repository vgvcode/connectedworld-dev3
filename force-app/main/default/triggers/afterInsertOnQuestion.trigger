trigger afterInsertOnQuestion on Question__c (after insert) {
    //upload image to aws s3 and update the image url field via future call 
    List<ID> qIDList = new List<ID>();
    
    for(Question__c q : Trigger.New) {        
        if (q.image__c != null) {
            system.debug('Added question id to list:' + q.id);
            qIDList.add(q.id);
        }        
    }
    s3.richTextFieldToS3(qIDList);
}