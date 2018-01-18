/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-17-2018   Manish Patil  				Trigger for Contact
 */
trigger ContactTrigger on Contact ( after delete, 
									after insert, 
									after undelete, 
									after update, 
									before delete, 
									before insert, 
									before update) {
	    if(Trigger.isInsert) {
	    	if(Trigger.isBefore) {
	    		ContactTriggerHelper helper = new ContactTriggerHelper();
	    		helper.addAccountToContact(Trigger.New);
	 		}
	    	if(Trigger.isAfter){
	    		
	 		}
	    }
	 	if(Trigger.isUpdate){}
	 	if(Trigger.isDelete){}
	 	if(Trigger.isUndelete){}
    
}

/*
if(CheckTriggerRecursion.runOnce()){ }
*/