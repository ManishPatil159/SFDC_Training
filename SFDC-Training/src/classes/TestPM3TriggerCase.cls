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
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Helper class for PM3TriggerAccount 
 */

@isTest
private class TestPM3TriggerCase {
	@TestSetup
	private static void initData() {
		List<Account> lstAccount = new List<Account>();
		List<Contact> lstContact = new List<Contact>();
		
		for(Integer i = 0; i<100; i++) {
			lstAccount.add(new Account(Name='Account - ' + i, PersonEmail__c = 'abc' + i + '@test.com' ));
		}
		insert lstAccount;
		
		for(Integer i = 0; i<100; i++) {
			lstContact.add(new Contact(LastName='Contact - ' + i, Email = 'abc' + i + '@test.com', AccountId =  lstAccount[i].Id));
		}
		insert lstContact;
	}
	
	@isTest
	private static void checkCaseCreation() {
		List<Case> lstCase = new List<Case>();
		
		List<Account> lstAccount = [SELECT Id, PersonEmail__c FROM Account];
		List<Contact> lstContact = [SELECT Id, Email FROM Contact];
		System.debug(lstContact);
		
		Id [] fixedSearchResults= new Id[200];
		for(Integer i = 0; i< 100; i++ ) {
			fixedSearchResults.add(lstAccount[i].Id);
		}
		for(Integer i = 0; i< 100; i++ ) {
			fixedSearchResults.add(lstContact[i].Id);
		}
       	//fixedSearchResults[0] = '001x0000003G89h';
       	Test.setFixedSearchResults(fixedSearchResults);
		
		
		for(Integer i = 0; i < 100; i++) {
			lstCase.add(new Case(Status='New', Origin = 'Web', SuppliedEmail= 'abc' + i + '@test.com'));
		}
		Test.startTest();
		insert lstCase;
		Test.stopTest();
		
		List<Case> lstSavedCases = [SELECT Id, SuppliedEmail, AccountId, ContactId FROM Case];
		
		System.assertEquals(100, lstCase.size());
		for(Integer i = 0; i< 100; i++) {
			System.assertEquals(lstAccount[i].Id, lstSavedCases[i].AccountId, 'Compare Account Ids');
			System.debug(i);
			System.assertEquals(lstContact[i].Id, lstSavedCases[i].ContactId, 'Compare Contact Ids');
			
		}
	}

}