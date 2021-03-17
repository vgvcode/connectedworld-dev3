public with sharing class TrendingCoursesController {
    @AuraEnabled
    public static list<Course__c> fetchTrendingCourseList(){
        User u = [select id, name, contact.id from user where id = :userInfo.getUserId() limit 1];
        System.debug(u.name);
        Contact c = [select id, course_role__c from contact where id = :u.contact.id limit 1];
        System.debug(c.course_role__c);
        List<course__c> listOfCourses = [select Id, name, name__c, number_registered__c, provider__c, start_date__c, end_date__c 
                                         from course__c where visible_to__c includes (:c.Course_Role__c) order by trending__c desc limit 5];
        System.debug(listOfCourses);
        return listOfCourses;
    }
}