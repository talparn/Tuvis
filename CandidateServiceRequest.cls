public with sharing class CandidateServiceRequest {
    public static List<Object> getCandidateRecords(){
        List<Object> candRecords = new List<Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://mindful-fox-k2w4z2-dev-ed.lightning.force.com//services/data/v54.0/query?q=select+id,name,email__c,status__c,additional_notes__c+from+Candidate__c');
        request.setMethod('GET');
        request.setHeader('Authorization','Bearer '+ UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        while (response.getStatusCode() == 302) {
            request.setEndpoint(response.getHeader('Location'));
            response = new Http().send(request);
        }
        // If the request is successful, parse the JSON response
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'records' key as a list
            List<Object> cands = (List<Object>) results.get('records');
            for(Object can : cands) {
                candRecords.add(can);
            }
        }
        system.debug('###candRecords: ' + candRecords);
        return candRecords;
    }
}