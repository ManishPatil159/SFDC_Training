public with sharing class AnimalLocator {
    public static String getAnimalNameById(Integer ObjId) {
    	String animalName = '';
    	String apiUrl = 'https://th-apex-http-callout.herokuapp.com/animals/' + ObjId;
    	Http http = new Http();
    	HttpRequest request = new HttpRequest();
    	request.setEndpoint(apiUrl);
    	request.setMethod('GET');
    	HttpResponse response = http.send(request);
    	
    	if(response.getStatusCode() == 200) {
    		Map<String, Object> mapResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			Map<String,Object> attributes = (Map<String, Object>) mapResult.get('animal');
    		animalName =  String.valueOf(attributes.get('name'));
    	}
    	return animalName;
    }
}