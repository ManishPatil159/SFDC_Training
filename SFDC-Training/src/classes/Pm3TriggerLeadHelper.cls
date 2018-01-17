/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Helper class for PM3TriggerLeads 
 */
public with sharing class Pm3TriggerLeadHelper {
	/**
	* Method to clone a lead.
	**/
	public void cloneLeads(List<sObject> lstNewLeads) {
		//deepClone(preserveId, preserveReadonlyTimestamps, preserveAutonumber)
		List<Lead> lstLeadsToCreate = lstNewLeads.deepClone(false, true);
		
		insert lstLeadsToCreate;
	}
	
	/**
	* Method to update Lead owner based on direction picklist
	* additional changes done:  created one more Rule Entry to existing Assignment Rule, with empty
	* criteria and Do Not Reassign Owner checkbox checked.
	*/
	public void updateLeadQueue(List<Lead> lstLeads) {
		
		Map<String,Id> mapGroup = new Map<String, Id>();
		for(Group groupObj : [SELECT Id, Name 
									 FROM Group 
									 WHERE 
									 	Name = 'North Queue' 
									 	OR Name = 'East Queue' 
									 	OR Name = 'West Queue' 
									 	OR Name = 'South Queue']) {
			mapGroup.put(groupObj.Name, groupObj.Id);
		}
		
		for(Lead leadObj : lstLeads) {
			if(leadObj.Direction__c == 'North') {
				leadObj.OwnerId = mapGroup.get('North Queue');
			}
			if(leadObj.Direction__c == 'East') {
				leadObj.OwnerId = mapGroup.get('East Queue');
			}
			if(leadObj.Direction__c == 'West') {
				leadObj.OwnerId = mapGroup.get('West Queue');
			}
			if(leadObj.Direction__c == 'South') {
				leadObj.OwnerId = mapGroup.get('South Queue');
			}
		}
	}
    
}