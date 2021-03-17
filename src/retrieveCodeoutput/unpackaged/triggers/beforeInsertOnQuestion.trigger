trigger beforeInsertOnQuestion on Question__c (before insert) {
	//list of all question IDs
    List<ID> qIDList = new List<ID>();
    
    for(Question__c q : Trigger.New) {
        qIDList.add(q.id);
    
		//image being reused?       
    	if (q.Reuse_Image_URL__c != null && q.Reuse_Image_Url__c.length() > 0) {
        	System.debug('Reuse URL:' + q.Reuse_Image_URL__c);
        	q.Image_URL__c = q.Reuse_Image_URL__c;
        	System.debug('Reuse Image URL copied to Image URL for Question:' + q.id);                        
    	}
        
        createTags.doCreate2(q);
    }

    //image upload is handled via after insert trigger 
	//if you supply an image here and a reuse image url, the image will overwrite the reuse image url      
}