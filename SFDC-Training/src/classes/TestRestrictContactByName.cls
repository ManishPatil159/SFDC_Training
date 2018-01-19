/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestRestrictContactByName {

    @isTest
    private static void TestRestrictContactByNameCreateTrigger() {
    	List<Contact> lstContact = new List<Contact>();
    	for(Integer i = 0; i<200; i++) {
    		if(i == 199)
    			lstContact.add(new Contact(LastName = 'INVALIDNAME'));
    		else
    			lstContact.add(new Contact(LastName = 'Conatct - ' + i));
    	}
    	Test.startTest();
    	Database.SaveResult[] saveResult = Database.insert(lstContact, false);
    	Test.stopTest();
    	
    	for (Database.SaveResult sr : saveResult) {
	    	if(!sr.isSuccess()) {
		    	for(Database.Error err : sr.getErrors()) {
		    		System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
	                            err.getMessage());
			    }
	    	}
    	}
    }
    
    @isTest
    private static void TestRestrictContactByNameUpdateTrigger() {
    	List<Contact> lstContact = new List<Contact>();
    	for(Integer i = 0; i<200; i++) {
    			lstContact.add(new Contact(LastName = 'Conatct - ' + i));
    	}
    	insert lstContact;
    	for(Integer i = 0; i<200; i++) {
    			lstContact[i].LastName = 'INVALIDNAME';
    	}
    	
    	Test.startTest();
    	Database.SaveResult[] saveResult = Database.update(lstContact, false);
    	Test.stopTest();
    	
    	for (Database.SaveResult sr : saveResult) {
	    	if(!sr.isSuccess()) {
		    	for(Database.Error err : sr.getErrors()) {
		    		System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
	                            err.getMessage());
			    }
	    	}
    	}
    }
}