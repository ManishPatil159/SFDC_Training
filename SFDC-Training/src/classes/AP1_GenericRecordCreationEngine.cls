/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Jan-24-2017   Manish Patil  	Advanced Programming - 1 Assignment code
*											Process which will execute per minute & the Event's 
*											records creating the respective sObject. 
*/

global class AP1_GenericRecordCreationEngine implements Schedulable {
	global void execute(SchedulableContext ctx) {
    	List<Event> lstEvent = new List<Event>();
    	List<sObject> lstSObjects = new List<sObject>(); 
    	for(Event eventObj : [SELECT Id, Subject, JSON_Object__c FROM Event]) {
    		if(eventObj.JSON_Object__c != '' && eventObj.JSON_Object__c != null) {
    			Map<String, Object> jsonInstance;
        		jsonInstance = (Map<String, Object>)JSON.deserializeUntyped(eventObj.JSON_Object__c);
        		String objectName = String.valueOf(jsonInstance.get('ObjectName'));
        		sObject targetObj = Schema.getGlobalDescribe().get(objectName).newSObject();
    			for(String keyName : jsonInstance.keySet()) {
    				if(keyName != 'ObjectName')
    					targetObj.put(keyName, String.valueOf(jsonInstance.get(keyName)));
    			}
    			lstSObjects.add(targetObj);
    			lstEvent.add(eventObj);
    			/*
    			
				targetType.put('Name', String.valueOf(jsonInstance.get('Name')));
    			lstSObjects.add(targetType);
    			lstEvent.add(eventObj);
    			*/
    		}
    	}
    	insert lstSObjects;
    	delete lstEvent;
	}
}

/**
for(Integer i = 0; i<60; i++) {
 System.schedule('Scheduled Job C-'+i, '0 '+ i +' * * * ?', new AP1_GenericRecordCreationEngine());
}
**/
