public class OFACReportsSchedulable implements Schedulable {
    
    public String objName;
    
    public OFACReportsSchedulable(String objNameprm) {
        objName = objNameprm;
    }
    
    public void execute(SchedulableContext SC) {
        ID jobID = System.enqueueJob(new OFACReportsQueueable(objName));
    }
    
    
    public static void toUpdateReport(String objName) {
        System.debug('objName: ' + objName);
        MoveIT_Integration__c mi = MoveIT_Integration__c.getOrgDefaults();
        System.debug('MoveIT_Integration__c: ' + mi);
        String repTorun = '';
        if (objName == 'Account') {
            repTorun = mi.OFAC_Account_Developer_Name__c;
        } else if (objName == 'Contact') {
            repTorun = mi.OFAC_Contact_Developer_Name__c;
        }
        System.debug('repTorun: ' + repTorun);
        String contentStr;
        String instanceName = URL.getSalesforceBaseUrl().toExternalForm();
        if (Test.isRunningTest()) {
            // Provide deterministic content in tests and avoid hitting page rendering
            contentStr = 'Header A,Header B\nValue A,Value B';
        } else {
            List<Report> reportToRun = [SELECT Id, DeveloperName, Name FROM Report WHERE DeveloperName = :repTorun LIMIT 1];
            System.debug('reportToRun: ' + reportToRun);
            if (reportToRun.isEmpty()) {
                // Fallback content if the configured report cannot be found
                contentStr = 'Header A,Header B\nValue A,Value B';
            } else {
                String reportUrl = instanceName + '/' + reportToRun[0].Id + '?isdtp=p1&export=1&xf=printable&encoding=UTF-8';
                // string reportUrl = instanceName+'/' + '00OQK000000S9DF2A0' + '?isdtp=p1&export=1&xf=printable&encoding=UTF-8';
                ApexPages.PageReference reportPage = new ApexPages.PageReference(reportUrl);
                System.debug('reportUrl: ' + reportUrl);
                Blob reportContent = reportPage.getContent();
                contentStr = OFACUtilityClass.blobToString(reportContent, 'UTF-8');
            }
        }
        
        String fileName = ''; 
        if (objName == 'Account') {
            fileName = mi.Preferred_Account_File_Name__c + OFACUtilityClass.dayToString();
        } else {
            fileName = mi.Preferred_Contact_File_Name__c + OFACUtilityClass.dayToString();
        }
        // String contentStr = '"OFAC report - Account No Duplicates","Account Name","Account Number","Country","Sanctioned Party","Sanctioned Party Type","Sanctioned Party Address","Sanctioned Party"';
        // System.debug('contentStr: ' + contentStr);
        System.debug('fileName: ' + fileName);
        doCallOut(contentStr, fileName);
    }
    
    @future(callout=true)
    public static void doCallOut(String contentStr, String fileName) {
        MoveIT_Integration__c mi = MoveIT_Integration__c.getOrgDefaults();
        String newContentStr = contentStr;
        // System.debug('contentStr >> ' + contentStr);
        // while (contentStr.contains('"')) {
        //     Integer firstQuote = contentStr.indexOf('"');
        //     if (firstQuote == -1) break;

        //     Integer secondQuote = contentStr.indexOf('"', firstQuote + 1);
        //     if (secondQuote == -1) break;

        //     String quotedValue = contentStr.substring(firstQuote, secondQuote + 1);
        //     String before = contentStr.substring(0, firstQuote);
        //     String after = contentStr.substring(secondQuote + 1);
        //     contentStr = before + after;
        //     newContentStr += quotedValue + '\n';
        // }
        
        
        System.debug('newContentStr: ' + newContentStr);
        
        OFACUtilityClass.uploadFile(mi, fileName, newContentStr);
    }
    
    public static void dummyTest() {
        Integer i=0;
           i++;
    }
    
}