/***
  Force.com Cookbook Sample Code
  Chapter 4: Best Practices for Writing Apex
  "Bulk Processing Records in a Trigger"

  This Apex trigger is a good example of how to write a trigger that 
  processes records in bulk. Instead of looping over individual
  records in the Trigger.old or Trigger.new lists, it uses maps to organize records based on
  their ID or another identifying field, and sets to isolate distinct records.

  Sample code provided by salesforce.com. All rights reserved.
 ***/

trigger leadDuplicatePreventer on Lead (before insert, before update) {

  Map<String, Lead> leadMap = new Map<String, Lead>();

  for (Lead lead : System.Trigger.new) {
  
    // Make sure we don't treat an email address that
    // isn't changing during an update as a duplicate.
    if ((lead.Email != null) && (System.Trigger.isInsert || (lead.Email != System.Trigger.oldMap.get(lead.Id).Email))) {
  
      // Make sure another new lead isn't also a duplicate
      if (leadMap.containsKey(lead.Email)) {
        lead.Email.addError('Another new lead has the same email address.');
      } else {
        leadMap.put(lead.Email, lead);
      }
    }
  }
  
  // Using a single database query, find all the leads in
  // the database that have the same email address as any
  // of the leads being inserted or updated.
  for (Lead lead : [SELECT Email FROM Lead WHERE Email IN :leadMap.KeySet()]) {
    Lead newLead = leadMap.get(lead.Email);
    newLead.Email.addError('A lead with this email address already exists.');
  }
  
}