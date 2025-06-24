@isTest 
private class OFACReportsTest {

    // Mock HTTP Callout class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('token')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"access_token":"mock_access_token","token_type":"Bearer","expires_in":"3600"}');
                res.setStatusCode(200);
            } else if (req.getEndpoint().contains('/files')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"message":"File uploaded successfully"}');
                res.setStatusCode(201);
            } else {
                res.setStatusCode(404);
            }
            return res;
        }
    }

    @testSetup
    static void setupData() {
        // Insert org-level default MoveIT_Integration__c
        insert new MoveIT_Integration__c(
            SetupOwnerId = UserInfo.getOrganizationId(), // Ensure this is org-wide
            LoginURL__c = 'https://dataexchange.intrado.com/api/v1/token',
            FolderURL__c = 'https://dataexchange.intrado.com/api/v1/folders/',
            folderId__c = '987457846',
            username__c = 'apiuser_prod',
            password__c = 'Z76QJ7aBLWUbsCW!',
            OFAC_Account_Developer_Name__c = 'OFAC_report_Account_No_Duplicates_3Nm',
            OFAC_Contact_Developer_Name__c = 'OFAC_report_Contact_No_Duplicates_0p9',
            Preferred_Account_File_Name__c = 'SF_Business_WSFS_SFS_EBS',
            Preferred_Contact_File_Name__c = 'SF_Contact_WSFS_SFS_EBS',
            OFAC_Account_Report_Label__c = 'OFAC report - Account No Duplicates',
            OFAC_Contact_Report_Label__c = 'OFAC report - Contact No Duplicates'
        );
    }

    @isTest
    static void testOFACReportsEndToEnd() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        OFACReportsSchedulable sched = new OFACReportsSchedulable('Account');
        sched.execute(null);
        Test.stopTest();

        List<OFAC_Report_Log__c> logs = [SELECT Id, File_Name__c, Status__c FROM OFAC_Report_Log__c];
        
        System.debug('Logs: ' + logs);
        System.assertEquals(1, logs.size(), 'Exactly one log should be created');
        System.assertEquals('Successful', logs[0].Status__c, 'Log status should be Successful');
    }
}
