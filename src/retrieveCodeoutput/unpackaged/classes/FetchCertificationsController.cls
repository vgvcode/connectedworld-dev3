public class FetchCertificationsController {
    @AuraEnabled
    public static List<Certification__c> fetchCertificationList(){
        String userName = userInfo.getName();
        List<certification__c> listOfCertifications = [select Id, certificate_id__c, certification_name__c, expiry_date__c from certification__c where contact__r.name = :userName];
        System.debug(listOfCertifications);
        return listOfCertifications;
    }
}