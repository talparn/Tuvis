public with sharing class CandidateController {

    //Get all the fields from Field Set in order to display them in the modal
    @AuraEnabled
    public static String getInitialParameters(){
        String res = '';
        Map <String, object> mso = new Map <String, object>();
        mso.put('candidateDetailsFieldSet', getCandidateDetailsFieldSetFieldSet());
        res = JSON.serialize(mso);
        return res;
    }

    public static List <Map<String, Object>> getCandidateDetailsFieldSetFieldSet(){
        List<String> ls = new List<String>();
        List <Map<String, Object>> lmss = new List <Map<String, Object>>();
        for(Schema.FieldSetMember f : SObjectType.Candidate__c.FieldSets.CandidateFieldsForm.getFields()) {
            Map<String, Object> tmp = new Map<String, Object>();
            tmp.put('name', f.getFieldPath());
            tmp.put('required', (f.getDbRequired() || f.getRequired()));
            lmss.add(tmp);
            ls.add(f.getFieldPath());
        }
        return lmss;
    }

    //Get all the Candidates records that are in progress
    @AuraEnabled
    public static List<Candidate__c> candidateRecords(){
        List<Candidate__c> canList = [SELECT Id, Name, Email__c FROM Candidate__c WHERE Status__c != 'Position Closed' AND Status__c != 'Progress Completed' ORDER BY Name ASC];
        return canList;
    }
}