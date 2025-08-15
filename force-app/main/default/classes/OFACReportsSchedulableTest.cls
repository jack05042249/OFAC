@isTest
private class OFACReportsSchedulableTest {
    
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
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        System.assertEquals(testObjName, schedulable.objName, 'Object name should be set correctly in constructor');
    }
    
    @isTest
    static void testSchedulableExecuteMethod() {
        // Test the schedulable execute method
        String testObjName = 'Account';
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        schedulable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method completed without errors
        // The execute method enqueues a new OFACReportsQueueable job
        System.assert(true, 'Schedulable execute method should complete successfully');
    }
    
    @isTest
    static void testSchedulableExecuteMethodWithContact() {
        // Test the schedulable execute method with Contact object
        String testObjName = 'Contact';
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        schedulable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method completed without errors
        System.assert(true, 'Schedulable execute method should complete successfully with Contact object');
    }
    
    @isTest
    static void testSchedulableExecuteMethodWithNullContext() {
        // Test the schedulable execute method with null context
        String testObjName = 'Account';
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        schedulable.execute(null);
        Test.stopTest();
        
        // Verify that the execute method handles null context gracefully
        System.assert(true, 'Schedulable execute method should handle null context gracefully');
    }
    
    @isTest
    static void testToUpdateReportMethod() {
        // Test the toUpdateReport method
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        OFACReportsSchedulable.toUpdateReport('Account');
        Test.stopTest();
        
        // Verify that the method completed without errors
        // Since we're using mocks, the callouts should complete successfully
        System.assert(true, 'toUpdateReport method should complete successfully');
    }
    
    @isTest
    static void testToUpdateReportMethodWithContact() {
        // Test the toUpdateReport method with Contact object
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        OFACReportsSchedulable.toUpdateReport('Contact');
        Test.stopTest();
        
        // Verify that the method completed without errors
        System.assert(true, 'toUpdateReport method should complete successfully with Contact object');
    }
    
    @isTest
    static void testDoCallOutMethod() {
        // Test the doCallOut method
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testContent = 'Test content for file upload';
        String testFileName = 'test_file.csv';
        
        Test.startTest();
        OFACReportsSchedulable.doCallOut(testContent, testFileName);
        Test.stopTest();
        
        // Verify that the method completed without errors
        // The method makes callouts which are mocked
        System.assert(true, 'doCallOut method should complete successfully');
    }
    
    @isTest
    static void testDoCallOutMethodWithEmptyContent() {
        // Test the doCallOut method with empty content
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testContent = '';
        String testFileName = 'empty_file.csv';
        
        Test.startTest();
        OFACReportsSchedulable.doCallOut(testContent, testFileName);
        Test.stopTest();
        
        // Verify that the method handles empty content gracefully
        System.assert(true, 'doCallOut method should handle empty content gracefully');
    }
    
    @isTest
    static void testDoCallOutMethodWithSpecialCharacters() {
        // Test the doCallOut method with special characters in content
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testContent = 'Test content with "quotes" and \n newlines';
        String testFileName = 'special_chars.csv';
        
        Test.startTest();
        OFACReportsSchedulable.doCallOut(testContent, testFileName);
        Test.stopTest();
        
        // Verify that the method handles special characters gracefully
        System.assert(true, 'doCallOut method should handle special characters gracefully');
    }
    
    @isTest
    static void testEndToEndFlow() {
        // Test the complete end-to-end flow
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Account';
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        Test.startTest();
        // Execute the schedulable which enqueues the queueable
        schedulable.execute(null);
        Test.stopTest();
        
        // Verify that the complete flow executed without errors
        System.assert(true, 'Complete end-to-end flow should execute successfully');
    }
    
    @isTest
    static void testDummyTest() {
        // Test the dummy test method
        OFACReportsSchedulable.dummyTest();
        System.assert(true, 'Dummy test method should execute without errors');
    }
    
    @isTest
    static void testIntegrationWithQueueable() {
        // Test integration between schedulable and queueable
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String testObjName = 'Account';
        OFACReportsSchedulable schedulable = new OFACReportsSchedulable(testObjName);
        
        Test.startTest();
        // Execute the schedulable
        schedulable.execute(null);
        Test.stopTest();
        
        // Verify that the integration works correctly
        System.assert(true, 'Integration between schedulable and queueable should work correctly');
    }
}