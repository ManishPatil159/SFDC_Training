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
 *
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-17-2018   Manish Patil  				Test class for Contact Trigger
 */
@isTest
private class TestContactTrigger {

    @testSetup
    private static void initData() {
    	List<Account> lstAccounts =  TestDataFactory.createAccounts(200);
    	insert lstAccounts;
    }
    
    /**
    * Method to check if accounts are applied to contacts based on their emails
    **/
    @isTest
    private static void testContactTriggerInsert() {
    	
    	Test.startTest();
    	List<Contact> lstContacts = TestDataFactory.createContacts(200);
    	insert lstContacts;
    	Test.stopTest();
    	
		Map<Id, Account> mapAccount = new Map<Id, Account>(
											[SELECT Name, PersonEmail__c 
											 FROM Account]);
    	for(Contact contactObj : [SELECT Name, Email, AccountId FROM Contact]) {
    		Account accountObj = mapAccount.get(contactObj.AccountId);
    		System.assert(accountObj.PersonEmail__c.contains(contactObj.Email.split('\\@')[1]));
    	}
    }
    
    /**
    * Method to check if contact has an email which is not present in accounts. 
    **/
    @isTest
    private static void testContactTriggerCkeckIfEmailNotMatch() {
    	
    	Test.startTest();
    	List<Contact> lstContacts = TestDataFactory.createContacts(200);
    	Contact cntctObj = lstContacts.get(0);
    	cntctObj.Email ='test@xyz.com';
    	insert lstContacts;
    	Test.stopTest();
    	
		Map<Id, Account> mapAccount = new Map<Id, Account>(
											[SELECT Name, PersonEmail__c 
											 FROM Account]);
											 
		for(Contact contactObj : [SELECT Name, Email, AccountId FROM Contact]) {
			if(lstContacts.get(0).Id == contactObj.Id){
				System.assert(String.isEmpty(contactObj.AccountId));
			}
			else {
    			Account accountObj = mapAccount.get(contactObj.AccountId);
    			System.assert(accountObj.PersonEmail__c.contains(contactObj.Email.split('\\@')[1]));
			}
    	}
    }
}