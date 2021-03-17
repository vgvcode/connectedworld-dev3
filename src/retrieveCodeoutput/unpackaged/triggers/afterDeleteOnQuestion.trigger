trigger afterDeleteOnQuestion on Question__c (after delete) {
    List<ID> examIDList = new List<ID>();
    List<String> imageURLList = new List<String>();
    for(Question__c q : Trigger.Old) {
        examIDList.add(q.exam__c);
        imageURLList.add(q.Image_URL__c);
    }
    
    if (imageURLList.size() > 0) {
        system.debug('List of s3 image urls to be deleted:' + imageURLList);
        //future call
        s3.deleteFilesFromS3(imageURLList);                
    }
    
    system.debug('List of exams where questions were deleted:' + examIDList);   
}