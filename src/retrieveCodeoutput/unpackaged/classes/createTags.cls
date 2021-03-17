public class createTags {
    public static void doCreate2(Question__c q) {
        JSONGenerator gen = JSON.createGenerator(true);
        
        //place the first topic in flex_tag_1
        List<String> topics = new List<String>();
        if (q.topics__c != null) {
            topics = q.topics__c.split(';');
            System.debug('Topics length:' + topics.size());
            q.Flex_Tag_1__c = topics[0];        
        } else {
            q.Flex_Tag_1__c = null;
        }
        
        //place the subject in flex_tag_2
        List<String> subjects = new List<String>();
        if (q.Subjects__c != null) {
            subjects = q.Subjects__c.split(';');
            System.debug('Subjects length:' + subjects.size());
            q.Flex_Tag_2__c = subjects[0];
        } else {
            q.Flex_Tag_2__c = null;
        }
        
        //flex_tag_3..5 unused  (can be used for sub topics)
        
        //place the custom tag 1 and 2 in flex_tag_4 and 5
        if (q.Custom_Tag_Key_1__c != null) {
            q.Flex_Tag_4__c = q.Custom_Tag_Value_1__c;
        } else {
            q.Flex_Tag_4__c = null;
        }
        
        if (q.Custom_Tag_Key_2__c != null) {
            q.Flex_Tag_5__c = q.Custom_Tag_Value_2__c;
        } else {
            q.Flex_Tag_5__c = null;
        }
        
        gen.writeStartObject();
        
        if (topics.size() > 0) {
            gen.writeObjectField('topics', topics);
        }
        
        if (subjects.size() > 0) {
            gen.writeObjectField('subject', subjects);
        }
        
        if (q.Difficulty__c != null) {
            gen.writeStringField('difficulty', q.Difficulty__c);
        }
        
        if (q.Custom_Tag_Key_1__c != null) {
            gen.writeStringField(q.Custom_Tag_Key_1__c, q.Custom_Tag_Value_1__c);
        }
        
        if (q.Custom_Tag_Key_2__c != null) {
            gen.writeStringField(q.Custom_Tag_Key_2__c, q.Custom_Tag_Value_2__c);
        }
        
        gen.writeEndObject();
        
        String tags = gen.getAsString();
        q.Tags__c = tags;
        System.debug('Tags:' + tags);        
    }
}