global class AP1_GenericRecordCreationEngine implements Schedulable {
	global void execute(SchedulableContext ctx) {
    	List<Event> lstEvent = new List<Event>();
    	for(Event eventObj : [SELECT Id, Subject, JSON_Object__c FROM Event]) {
    		if(eventObj.JSON_Object__c != '' && eventObj.JSON_Object__c != null) {
    			Map<String, Object> jsonInstance;
        		jsonInstance = (Map<String, Object>)JSON.deserializeUntyped(eventObj.JSON_Object__c);
        		String objectName = String.valueOf(jsonInstance.get('ObjectName'));
    			sObject targetType = Schema.getGlobalDescribe().get(objectName).newSObject();
    											
    			
    			lstEvent.add(eventObj);
    		}
    	}
	}
}