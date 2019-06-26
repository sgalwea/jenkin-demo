public with sharing class aws_OpportunityExtension {

//this class serves the purpose of overriding the standard save action by providing 
//a default value for the StageName field.

    private ApexPages.StandardController ctrl; 

    public aws_OpportunityExtension(ApexPages.StandardController controller) {
        ctrl = controller;
    }
    
    public PageReference save(){
    	//add default value to StageName field prior to enacting save
        ctrl.getRecord().put('StageName', 'Prospecting');
        return ctrl.save();
    }

}