public class OFACReportsQueueable implements Queueable, Database.AllowsCallouts {
    public List<Report> reportToRun;
    public String objName, accessToken;
    public Integer processNum;
    public OFACReportsQueueable(String objNameStr) {
        objName = objNameStr;
    }
    public void execute(QueueableContext context) {
       OFACReportsSchedulable.toUpdateReport(objName);
    }
    

    // public static void toUpdateReport(String objNamess) {
    //     MoveIT_Integration__c mi = MoveIT_Integration__c.getOrgDefaults();
    //     String repTorun = '';
    //     System.debug(objNamess);
    //     if (objNamess == 'Account') {
    //         repTorun = mi.OFAC_Account_Developer_Name__c;
    //     } else if (objNamess == 'Contact') {
    //         repTorun = mi.OFAC_Contact_Developer_Name__c;
    //     }
    //     List <Report> reportToRun = [SELECT Id, DeveloperName, Name FROM Report WHERE 
    //                                  DeveloperName =: repTorun];
        
    //     String instanceName = URL.getSalesforceBaseUrl().toExternalForm();
    //     string reportUrl = instanceName+'/' + reportToRun[0].Id + '?isdtp=p1&export=1&xf=printable&encoding=UTF-8';
    //     ApexPages.PageReference reportPage = new ApexPages.PageReference(reportUrl);
    //     Blob reportContent = reportPage.getContent();
        
    //     String fileName = ''; 
    //     String reportLabel = '';
    //     if (objNamess == 'Account') {
    //         fileName = mi.Preferred_Account_File_Name__c + OFACUtilityClass.dayToString();
    //         reportLabel = mi.OFAC_Account_Report_Label__c;
    //     } else {
    //         fileName = mi.Preferred_Contact_File_Name__c + OFACUtilityClass.dayToString();
    //         reportLabel = mi.OFAC_Contact_Report_Label__c;
    //     }
    //     String contentStr = OFACUtilityClass.blobToString(reportContent, 'UTF-8');
    //     doCallOutv2(contentStr, fileName, reportLabel);
    // }
    
   
    // @future(callout=true)
    // public static void doCallOutv2(String contentStr, String fileName, String reportLabel) {
    //     MoveIT_Integration__c mi = MoveIT_Integration__c.getOrgDefaults();
    //     String newContentStr = '';
        
    //     System.debug('newlinee >> ' + contentStr.contains('\n'));
    //     while (contentStr.contains('\n')) {
    
    //         String content = contentStr.substringBefore('\n');
    //         if (content.right(1) == '"') {
    //             if (content != '"' + reportLabel + '"'){
    //                 newContentStr = newContentStr + content + '\n';
    //             } else {
    //                 break;
    //             }
    //         } else {
    //             if (content != '') {
    //                 newContentStr = newContentStr + content + ' ';
    //             }
    //         }
    //         contentStr = contentStr.substringAfter('\n');
    //     }        
    //     String accessToken = OFACUtilityClass.getAccessToken(mi);
    //     OFACUtilityClass.uploadFile(mi, fileName, newContentStr);
    // }
    
    public static void dummyTest() {
        Integer i=0;
        i++;
    }
}