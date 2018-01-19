/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Trigger on Lead to clone a record
 */
trigger PM3TriggerLead on Lead (after delete, after insert, after undelete, after update, 
								before delete, before insert, before update) {
    
    /*
    * 1.System.debug the following statements for any object
	*	a)Trigger.New b) Trigger.Old c) Trigger.NewMap d) Trigger.oldMapap 
	* 2.System.debug the following statements for all events (Before & After)
	*	a)Trigger.New b) Trigger.Old c) Trigger.NewMap d) Trigger.oldMapap
    */
   	System.debug(Trigger.New);
	System.debug(Trigger.newMap);
	System.debug(Trigger.Old);
	System.debug(Trigger.oldMap);
    
    if(Trigger.isInsert) {
    	Pm3TriggerLeadHelper helperObj = new Pm3TriggerLeadHelper();
    	if(Trigger.isAfter){
    		if(CheckTriggerRecursion.runOnce()){
        		helperObj.cloneLeads(Trigger.New);
    		}
 		}
 		if(Trigger.isBefore) {
 			helperObj.updateLeadQueue(Trigger.New);
 		}
    }
 	if(Trigger.isUpdate){}
 	if(Trigger.isDelete){}
 	if(Trigger.isUndelete){}
}