public with sharing class fetchCoursesController {   
    @AuraEnabled
    public static list<Course__c> fetchCourseList(){
        User u = [select id, name, contact.id from user where id = :userInfo.getUserId() limit 1];
        System.debug(u.name);
        Contact c = [select id, course_role__c from contact where id = :u.contact.id limit 1];
        System.debug(c.course_role__c);
        String role = c.Course_Role__c;
        //if no role is provided, default to Individual contributor
        if (role == '') {
            role = 'Individual Contributor';
        }
        List<course__c> listOfCourses = [select Id, name__c, provider__c, fieldName__c, start_date__c, end_date__c from course__c where visible_to__c includes (:role)];
        System.debug(listOfCourses);
        return listOfCourses;
    }
}