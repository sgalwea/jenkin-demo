public with sharing class aws_PositionHelper {
    
/*
Create an interviewer record for each position passed in and make the hiring manager for the 
position the employee for the interviewer record. 

As compared with the aws_OpportunityHelper, this is a much more straightforward bit of code. The
only tricky bit is getting the hiring manager name for each position, since this is not readily 
available. 

One other challenge includes handling the owner of the interviewer. Since this is a lookup relationship
owner must be set in the interviewer record. So who to be the owner? The CreatedById was chosen for
simplicity, but there are other possible options, and exceptiosn to handle, including: 
1. Use the position owner instead?
2. In which case, if position owner is a queue, how is that handled?
3. Should queues be added to interviewers? 
*/  

    public static List<Interviewer__c> createHiringManagerInterviewers(List<Position__c> positions){
        
        //9 July, 2012 removed to support change of Interviewer__c.name to autonumber
        //create a map between position id and hiring manager name so that the hiring manager name can be 
        //placed in the text name field of position__c.name. 
        //Map<Id,String> posMap = new Map<Id,String>();
        //for (Position__c p: [select Hiring_Manager__r.name, name from Position__c where id in : (new Map<Id,Position__c>(positions)).keyset()]) {
        //    posMap.put(p.Id, p.Hiring_Manager__r.name);
        //}
        
        List<Interviewer__c> newInterviewers = new List<Interviewer__c>();
        for (Position__c p : positions){
            Interviewer__c newInt = new Interviewer__c();
            newInt.Position__c = p.Id;
            newInt.Employee__c = p.Hiring_Manager__c;
            newInt.OwnerId = p.CreatedById; 
            //newInt.Name = posMap.get(p.Id); //9 July - removed to support change of Interviewer__c.name to autonumber
            newInterviewers.add(newInt);
        }
        return newInterviewers;
    }

}