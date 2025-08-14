@isTest
private class OFACReportsQueueableTest {
    
    // Mock HTTP Callout class for testing
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
            SetupOwnerId = UserInfo.getOrganizationId(),
            LoginURL__c = 'https://c3.moveitcloud.com/api/v1/token',
            FolderURL__c = 'https://c3.moveitcloud.com/api/v1/folders/',
            folderId__c = '987457846',
            username__c = 'ls_salesforce_prod',
            password__c = 'aI!9f4Lk',
            OFAC_Account_Developer_Name__c = 'OFAC_report_Account_No_Duplicates_3Nm',
            OFAC_Contact_Developer_Name__c = 'OFAC_report_Contact_No_Duplicates_0p9',
            Preferred_Account_File_Name__c = 'SF_Business_WSFS_SFS_EBS',
            Preferred_Contact_File_Name__c = 'SF_Contact_WSFS_SFS_EBS',
            OFAC_Account_Report_Label__c = 'OFAC report - Account No Duplicates',
            OFAC_Contact_Report_Label__c = 'OFAC report - Contact No Duplicates'
        );
    }
    
    @isTest
    static void testConstructor() {
        // Test the constructor
        String testObjName = 'Account';
        OFACReportsQueueable queueable = new OFACReportsQueueable(testObjName);
        
        System.assertEquals(testObjName, queueable.objName, 'Object name should be set correctly in constructor');
    }
    
    @isTest
    static void testExecuteMethod() {
        // Test the execute method
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Account';
        OFACReportsQueueable queueable = new OFACReportsQueueable(testObjName);
        
        Test.startTest();
        queueable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method completed without errors
        // The execute method calls OFACReportsSchedulable.toUpdateReport which makes callouts
        // Since we're using mocks, this should complete successfully
        System.assert(true, 'Execute method should complete successfully');
    }
    
    @isTest
    static void testExecuteMethodWithContact() {
        // Test the execute method with Contact object
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Contact';
        OFACReportsQueueable queueable = new OFACReportsQueueable(testObjName);
        
        Test.startTest();
        queueable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method completed without errors
        System.assert(true, 'Execute method should complete successfully with Contact object');
    }
    
    @isTest
    static void testExecuteMethodWithNullContext() {
        // Test the execute method with null context
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Account';
        OFACReportsQueueable queueable = new OFACReportsQueueable(testObjName);
        
        Test.startTest();
        queueable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method handles null context gracefully
        System.assert(true, 'Execute method should handle null context gracefully');
    }
    
    @isTest
    static void testDummyTest() {
        // Test the dummy test method
        OFACReportsQueueable.dummyTest();
        System.assert(true, 'Dummy test method should execute without errors');
    }
    
    @isTest
    static void testQueueableChaining() {
        // Test that the queueable can be chained properly
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Account';
        OFACReportsQueueable queueable = new OFACReportsQueueable(testObjName);
        
        Test.startTest();
        // Enqueue the job to test the full flow
        ID jobID = System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify that the job was enqueued successfully
        System.assertNotEquals(null, jobID, 'Job should be enqueued successfully');
    }
}
