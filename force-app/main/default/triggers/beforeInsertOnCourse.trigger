trigger beforeInsertOnCourse on Course__c (before insert) {
	List<Course__c> courseList = new List<Course__c>();
    Group courseq = [select Id from Group where  Type = 'Queue' AND NAME = 'Course Queue' LIMIT 1];
    for(Course__c c : Trigger.new) {
        c.OwnerId = courseq.Id;
    }
}