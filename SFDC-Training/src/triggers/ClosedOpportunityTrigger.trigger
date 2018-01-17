trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> lstTask = new List<Task>();
	String userId = UserInfo.getUserId();
	for(Opportunity opportunityObj : Trigger.New) {
		if(opportunityObj.StageName == 'Closed Won') {
			lstTask.add(
				new Task(OwnerId = userId, 
						 Subject  = 'Follow Up Test Task', 
						 WhatId = opportunityObj.Id)
			);
		}
	}
	if(lstTask.size()>0) {
		insert lstTask;
	}
}