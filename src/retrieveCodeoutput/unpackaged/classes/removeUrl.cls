public class removeUrl {
    @future(callout=true)
    public static void doRemove(String recId) {
        Question__c q = [SELECT id, image__c, image_url__c from question__c where id = :recId LIMIT 1];
		q.Image_URL__c = '';
		update(q);
        System.debug('URL removed from Question:' + recId);
    }
}