@RestResource(urlMapping='/CandidateInfo/*')
global class CandidateServiceRequest{
    //(MavenTool Extension) endpoint: https://mindful-fox-k2w4z2-dev-ed.my.salesforce.com/services/apexrest/CandidateInfo?email__c={emailInput}&mobile__c={mobileInput}
    @HttpGet
    global static List<Candidate__c> getCandidateRecord() {
        String stremail = '';
        String strMobile = '';
        list<Candidate__c> lstCand;
        RestRequest restReq = RestContext.request;

        // Reading parametrs from URL --> The outbput will be based on Email and Mobile of the Candidate
        stremail = restReq.params.get('email__c'); 
        strMobile = restReq.params.get('mobile__c');

        if(!String.isBlank(stremail) && !String.isBlank(strMobile)) {
            lstCand = [SELECT Id, Name, Email__c, Mobile__c, Additional_Notes__c, Status__c,
                        (SELECT Id, Subject, Type FROM Tasks) 
                        FROM Candidate__c WHERE Email__c =: stremail AND Mobile__c =: strMobile];
        }

        return lstCand;
    }
}
