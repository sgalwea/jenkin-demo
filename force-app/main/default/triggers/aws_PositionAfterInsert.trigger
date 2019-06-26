trigger aws_PositionAfterInsert on Position__c (after insert) {
    
/*
NOTE: The following code is a simplification for demo purposes, and does not cover all possible 
avenues of logic for accomplishing this requirement completely.

Trigger rule #1 is to always assume a list of records that are being acted upon. Even though
a user will almost always be working with 1 record, any API access could be a list of data. The
list of records is represented by the item Trigger.new. 

Go through trigger records for positions with status of not closed (and not null). Any such
records add them to a list for taking the action of creating a new interviewer record. 

Call a helper method (like a function) to create the actual interviewer records, then save
them. 

For code that contains the creation of interviewer records in memory see the aws_PositionHelper class.

It should be noted that the following use cases are not addressed in this instance:
1. Updates to records where hiring manager changes. This would need to be addressed as 
we could end up where the initial interviewer created needs to be manually cleaned up. Normally,
a trigger such as this could be used to remove the old interviewer record and add a new one for 
the new hiring manager. 
2. In this case we would also want to check to see if the interviewer record for the new hiring 
manager already exists so as to not create a duplicate. 
 
*/  
    
    
    System.debug('>>> begin PositionAfterInsert trigger with ' + Trigger.new);
    List<Position__c> positionsForInterviewers = new List<Position__c>();               //list of positions we will work with
    for (Position__c p : Trigger.new) {                                                 //loop through all trigger Positions
        if (p.Status__c != null && !String.valueof(p.Status__c).equals('Closed')){
            positionsForInterviewers.add(p);                                            //add this position to the list to act on
        }
    }
    
    if (positionsForInterviewers.size() > 0){
        System.debug('>>> there are ' +positionsForInterviewers.size()+ ' Positions with status not Closed ');
        List<Interviewer__c> newInterviewers = new List<Interviewer__c>();              //create a list of interviewers to fill with new records
        newInterviewers = aws_PositionHelper.createHiringManagerInterviewers(positionsForInterviewers); // call the helper to return the interviewers
        insert newInterviewers;                                                         //save the interviewers
        System.debug('>>> interviewers inserted' +newInterviewers);
    }
    System.debug('>>> finished PositionAfterInsert trigger');
}