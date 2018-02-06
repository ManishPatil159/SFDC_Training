/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Jan-24-2017   Manish Patil  	Advanced Programming - 1 Assignment code
*											process which will run every 3 hours/day and remove the 
*											duplicate leads from the org. 
*/

global class AP1_DulplicateLeadDeleteScheduler implements Schedulable {
	global void execute(SchedulableContext ctx) {
		List<Lead> lstLead = [SELECT Name, email FROM Lead];
		Map<String, List<Lead>> mapLead = new Map<String, List<Lead>>();
		List<Lead> lstDeleteLeads = new List<Lead>();
		
		for(Lead leadObj : lstLead) {
			Object objInstance = getByPropertyName(System.Label.Lead_Duplicate_Property, leadObj);
		    if(mapLead.containsKey(String.valueOf(objInstance))) {
		    	lstDeleteLeads.add(leadObj);
		    }
		    else {
		        List<Lead> lstLeadForMap = new List<Lead>();
		        lstLeadForMap.add(leadObj);
		        mapLead.put(String.valueOf(objInstance), lstLeadForMap);
		    }
		}
		
		delete lstDeleteLeads;
	}
	
	private Object getByPropertyName(String param_name, Lead leadObj){
		String json_instance = Json.serialize(leadObj);
        Map<String, Object> untyped_instance;
        untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
        return untyped_instance.get(param_name);
    }
}

/**
* System.schedule('Scheduled Job 1', '0 0 * * * ?', new AP1_DulplicateLeadDeleteScheduler());
* System.schedule('Scheduled Job 2', '0 15 * * * ?', new AP1_DulplicateLeadDeleteScheduler());
* System.schedule('Scheduled Job 3', '0 30 * * * ?', new AP1_DulplicateLeadDeleteScheduler());
* System.schedule('Scheduled Job 4', '0 45 * * * ?', new AP1_DulplicateLeadDeleteScheduler());
**/