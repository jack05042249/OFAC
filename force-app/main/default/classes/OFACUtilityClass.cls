public class OFACUtilityClass {
    
    public class responseClass {
        public String access_token;
        public String token_type;
        public String expires_in;
        public String refresh_token;
    }
    
    public static String dayToString() {
        String fulldate = '';
        String mnth = String.valueOf(Date.today().month());
        if (mnth.length() == 1) {
            mnth = '0' + mnth;
        }
        String dy = String.valueOf(Date.today().day());
        if(dy.length() == 1) {
            dy = '0' + dy;
        }
        
        String yr = String.valueOf(Date.today().year()).right(2);
        fulldate = mnth + dy + yr;
        return fulldate;
    }
    
    public static string getAccessToken(MoveIT_Integration__c mi) {
        String accessToken = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(mi.LoginURL__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String payload = 'grant_type=password&username=' + mi.username__c + '&password=' + mi.password__c;
        req.setBody(payload);
        HttpResponse response = http.send(req);
        System.debug(response.getBody());
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
            
            responseClass rp = (responseClass)System.JSON.deserialize(response.getBody(), responseClass.class);
            accessToken = rp.access_token;
        }
        return accessToken;
    }
    
    public static void uploadFile (MoveIT_Integration__c mi, String fileName, String contentStr) {
        
            String accessToken = getAccessToken(mi);
            System.debug('accessToken: ' + accessToken);
        
            String formBoundary = '----sfdc-multi-form',
        
                headerForm = '--'+formBoundary+'\r\nContent-Disposition: form-data; name="{0}";\r\n\n',
                headerFile = '--'+formBoundary+'\r\nContent-Disposition: form-data; name="{0}"; filename="{1}";\r\nContent-Type: {2}\r\n\n';
        
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(mi.FolderURL__c + mi.folderId__c + '/files');
            // req.setMethod('GET');
            // req.setEndpoint(mi.FolderURL__c);
            req.setHeader('Authorization', 'Bearer ' + accessToken);
        
            String boundary = '----------------------------' + String.valueOf(System.currentTimeMillis());
        
            String header = '--' + boundary + '\r\nContent-Disposition: form-data; name="file"; filename="' + fileName+'.csv' + '"\r\nContent-Type: application/octet-stream\r\n\r\n';
        
            String footer = '\r\n--' + boundary + '--\r\n';
        
            String body = header + contentStr + footer;
        
            req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        
            req.setHeader('Content-Length', String.valueOf(body.length()));
        
            req.setBody(body);
        
            Http http = new Http();
        
            HttpResponse res = http.send(req);
            System.debug('res ' + res.getBody());
            List<OFAC_Report_Log__c> orl = new List<OFAC_Report_Log__c>();
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    orl.add(new OFAC_Report_Log__c(File_Name__c = fileName, Status__c = 'Successful', Status_Code__c = String.valueOf(res.getStatusCode())));
            } else {
                    orl.add(new OFAC_Report_Log__c(File_Name__c = fileName, Status__c = 'Failed', Error_Message__c = res.getBody(), Status_Code__c = String.valueOf(res.getStatusCode())));
            }
            insert orl;
        
    }
    
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
    public static void dummyTest() {
        Integer i=0;
        i++;
    }
    
}