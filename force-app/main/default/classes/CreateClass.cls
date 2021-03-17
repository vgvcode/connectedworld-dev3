public class CreateClass {
    public void doCreate() {
        MetadataService.MetadataPort metadataservice = new MetadataService.MetadataPort();
        metadataservice.SessionHeader = new MetadataService.SessionHeader_element();
        metadataservice.SessionHeader.sessionId = UserInfo.getSessionId();
        List<MetadataService.CustomObject> fields = new List<MetadataService.CustomObject>();
        MetadataService.CustomObject customobject = new MetadataService.CustomObject();
        customobject.fullName = 'custom_create__c';
        customobject.label = 'custom created object';
        customobject.pluralLabel = 'custom created objects';
        customObject.nameField = new MetadataService.CustomField();
        customobject.nameField.type_x = 'Text';
        customobject.nameField.label = 'status';
        customobject.deploymentStatus = 'Deployed';
        customObject.sharingModel = 'ReadWrite';
        fields.add(customobject);
        metadataservice.createMetadata(fields);

        List<MetadataService.CustomField> fields2 = new List<MetadataService.CustomField>();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'custom_create__c.custom_create_field__c';
        customField.label = 'Custom created field';
        customField.defaultvalue = 'false';
        customField.type_x = 'Checkbox';
        fields2.add(customField);
        metadataservice.createMetadata(fields2);        
    }
}