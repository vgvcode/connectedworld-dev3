public class FetchMyCoursesController {
    @AuraEnabled
    public static List<Contact_Course__c> fetchContactCourseList(){
        String userName = userInfo.getName();
        List<contact_course__c> listOfContactCourses = [select Id, course__r.name, course__r.name__c, contact__r.name, course__r.provider__c, start_date__c, end_date__c from contact_course__c where contact__r.name = :userName];
        System.debug(listOfContactCourses);
        return listOfContactCourses;
    }
}