/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Helper class for PM3TriggerAccount 
 */
public with sharing class PM3TriggerAccountHelper {
	
	/**
	* Method to create a new task for all the accounts in the list
	**/
	public void createTaskForAccount(List<Account> lstNewAccounts) {
		List<Task> lstTask = new List<Task>();
	    String userId = UserInfo.getUserId();
	    
	    for(Account accountObj : lstNewAccounts) {
	    	lstTask.add(
	    		new Task(
	    			OwnerId = userId, 
	    			Subject  = 'Meeting With ' + 
	    			accountObj.Name,
	    			WhatId = accountObj.Id));
	    }
	    System.debug(lstTask);
	    if(lstTask.size() > 0) {
	    	insert lstTask;
	    }
	}
}