public class s3 {
    @future(callout=true)
    public static void richTextFieldToS3(List<ID> qidList) {
        for (ID qid : qidList) {
            System.debug('Retrieving question object with id:' + qid);
            Question__c q = [SELECT id, name, image__c from question__c where id = :qid LIMIT 1];
            String imgField = q.image__c;
            System.debug(imgField);
                
            try {
                // use reluctant regex to match each image tag individually
                // https://docs.oracle.com/javase/tutorial/essential/regex/quant.html
                Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher( imgField );
                
                Blob b = null;                    
                // iterate each image tag found
                while ( imgMatcher.find() ) {
               
                    // get the image tag html
                    String imageTag = imgMatcher.group();
                    System.debug( 'imageTag=' + imageTag );
                
                    // get the value of the src attribute
                    // the leading space is significant to avoid other attributes like data-cke-saved-src
                    String imageURL = imageTag.substringBetween( ' src="', '"' );
                    System.debug( 'imageURL=' + imageURL );
                
                    // if url contained parameters they might be html escaped, unescape them
                    // or, more conservatively, replace '&amp;' with '&'
                    String decodedURL = imageURL.unescapeHtml4();
                    System.debug( 'decodedURL=' + decodedURL );
                
                    // note, as of API 34.0 or later, getContent() is considered an http callout
                    // so take that into consideration for your unit tests and governor limits
                    // https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/apex_System_PageReference_getContent.htm
                    PageReference page = new PageReference( decodedURL );
                    b = page.getContent();
                    System.debug( 'blob.size()=' + b.size() );
                    
                    //Do only the first
                    break;
                    }    
                    
                if (b != null && b.size() > 0) {
                    String imageType = 'application/jpeg';
                    String fname = q.name + '.jpg';
                    String path = uploadToS3(b, fName, imageType);
                    if (path != null) {
                        q.Image_URL__c = path;
                        q.Upload_Status__c = 'Image uploaded to S3';
                    }
                } else {
                    //image was probably deleted and you got here from after update trigger
                    q.image_URL__c = '';
                }
                update(q);
            }
            catch (Exception e) {
                System.debug('Not a valid image. Upload to S3 aborted. Message:' + e.getMessage());
                q.Upload_Status__c = 'Not a valid image. Upload to S3 aborted. Message:' + e.getMessage();
                q.Image_URL__c = '';
                update(q);
                return;
            }
        }
    }
   
    public static String uploadToS3(Blob myBlob, String fNameWithExt, String cType) {
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
   
        AWS__c aws = [select id, access_key__c, secret_access_key__c, bucket_name__c from aws__c];       
        //Need to encrypt these
        String key = aws.access_key__c;
        String secret = aws.secret_access_key__c;
        String bucketname = aws.Bucket_Name__c;
        String host = 's3.amazonaws.com'; 
        String method = 'PUT';
        String filename = fNameWithExt;
        String contentType = cType;
         
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        String endPoint = 'https://' + host + '/' + bucketname + '/' + filename;
        req.setEndpoint('https://' + host + '/' + bucketname + '/' + filename);
        req.setHeader('Host', host);
        req.setHeader('Content-Length', String.valueOf(EncodingUtil.base64Encode(myBlob).length()));
        req.setHeader('Content-Encoding', 'base64');
        req.setHeader('Content-type', cType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString);
        req.setHeader('ACL', 'public-read');
        //req.setBody(attachmentBody);
        req.setBodyAsBlob(myBlob);
         
        String stringToSign = 'PUT\n\n' +
        contentType + '\n' +
        formattedDateString + '\n' +
        '/' + bucketname + '/' + filename;
        System.debug('The String to sign:' + stringToSign);
         
        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
        String signed = EncodingUtil.base64Encode(mac);
        String authHeader = 'AWS' + ' ' + key + ':' + signed;
        req.setHeader('Authorization',authHeader);
        String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');
         
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());
        Integer status = res.getStatusCode();
        if (status == 200) {
            return endPoint;
        } else {
            return null;
        }
    }    

    @future(callout=true)
    public static void deleteFilesFromS3(List<String> imageURLList) {
        for (String url : imageURLList) {
            deleteOneFileFromS3(url);
        }
    }
    
    public static Boolean deleteOneFileFromS3(String imageUrl) {
        //https://s3.amazonaws.com/vgvcode.testprep/pie-chart-question.jpg 
        /*
        DELETE /my-second-image.jpg HTTP/1.1
        Host: bucket.s3.amazonaws.com
        Date: Wed, 12 Oct 2009 17:50:00 GMT
        Authorization: authorization string
        Content-Type: text/plain
        */  
                
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        AWS__c aws = [select id, access_key__c, secret_access_key__c, bucket_name__c from aws__c];       
        //Need to encrypt these
        String key = aws.access_key__c;
        String secret = aws.secret_access_key__c;
        String bucketname = aws.Bucket_Name__c;
        String host = bucketname + '.' + 's3.amazonaws.com'; 
        String method = 'DELETE';
        //remove up to the bucketname and get only the trailing chars - e.g. pie-chart-question.jpg
        String filename = imageUrl.remove('https://s3.amazonaws.com/' + bucketname);
        System.debug(filename);  
        
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(filename);
        req.setHeader('Host', host);
        req.setHeader('Date', formattedDateString);
        
        String stringToSign = 'DELETE\n\n' +
            '/' + filename + '\n' +
            host + '\n' +
            formattedDateString;
        System.debug('The String to sign:' + stringToSign);
        
        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
        String signed = EncodingUtil.base64Encode(mac);
        String authHeader = 'AWS' + ' ' + key + ':' + signed;
        req.setHeader('Authorization',authHeader);
        String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());
        Integer status = res.getStatusCode();
        if (status == 204) {
            System.debug('Successfully deleted:' + imageUrl);
            return true;
        } else {
            System.debug('Unable to delete:' + imageUrl);
            return false;
        }
    }
    
    public static String urlToS3(String url, String fName) {
        System.Debug(url); 
        System.Debug(fName);
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setTimeout(60000);
        req.setHeader('Content-Type', 'application/pdf');
        req.setMethod('GET');
		HttpResponse res = h.send(req);
        System.debug('Response:' + res);
		Blob urlBody = res.getBodyAsBlob();
        System.debug('Length of blob:' + EncodingUtil.base64Encode(urlBody).length());
        String imageType = 'image/jpeg';
        return uploadToS3(urlBody, fName, imageType);
    }
    
    public static String attachmentToS3(String docId, String fName) {
        ContentVersion cv = [SELECT Id, Title, FileExtension, FileType, VersionData from ContentVersion WHERE ContentDocumentId = :docId];
        Blob attachmentBlob = cv.VersionData;
        String imageType = 'image/jpeg';
        return uploadToS3(attachmentBlob, fName, imageType);      

    }
}