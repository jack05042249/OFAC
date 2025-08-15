@IsTest
public class OFACUtilityClass_Test {
    @IsTest
    static void testDayToString() {
        String result = OFACUtilityClass.dayToString();
        System.assertNotEquals(null, result);
        System.assertEquals(6, result.length()); // mmddyy format
    }

    @IsTest
    static void testBlobToString() {
        Blob testBlob = Blob.valueOf('Hello');
        String decoded = OFACUtilityClass.blobToString(testBlob, 'UTF-8');
        System.assertEquals('Hello', decoded);
    }

    @IsTest
    static void testDummyTest() {
        Test.startTest();
        OFACUtilityClass.dummyTest();
        Test.stopTest();
    }

    @IsTest
    static void testGetAccessTokenAndUploadFile() {
        // Create dummy integration record
        MoveIT_Integration__c mi = new MoveIT_Integration__c(
            LoginURL__c = 'https://test.salesforce.com',
            Username__c = 'dummyUser',
            Password__c = 'dummyPass',
            FolderURL__c = 'https://example.com/',
            FolderId__c = '1234'
        );
        insert mi;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String token = OFACUtilityClass.getAccessToken(mi);
        System.assertEquals('dummyToken', token);

        OFACUtilityClass.uploadFile(mi, 'TestFile', 'Sample content');
        Test.stopTest();
    }

    // Mock HTTP Response for testing
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('test.salesforce.com')) {
                res.setStatusCode(200);
                res.setBody('{"access_token": "dummyToken"}');
            } else {
                res.setStatusCode(201);
                res.setBody('{"message":"File uploaded"}');
            }
            return res;
        }
    }
}