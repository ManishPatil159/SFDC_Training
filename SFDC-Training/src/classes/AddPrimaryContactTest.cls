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
private class AddPrimaryContactTest {
	@testSetup
	static void initTest() {
		List<Account> lstAccount = new List<Account>();
		for(Integer i =0; i< 100; i++) {
			if(i <50 )
				lstAccount.add(new Account(Name='Account - '+ i, BillingState = 'NY'));
			else
				lstAccount.add(new Account(Name='Account - '+ i, BillingState = 'CA'));
		}
		insert lstAccount;
	}
	
	@isTest
	private static void testContactCreationByStateCodeTrailhead() {
		Contact contactObj = new Contact(LastName = 'LastName1', Email = 'contactEmail1@test1.com');
		
		List<Id> lstAccountIds = new List<Id>();
		for(Account accountObj : [SELECT Id FROM Account WHERE BillingState = 'CA']) { 
			lstAccountIds.add(accountObj.Id);	
		}
		
		AddPrimaryContact addPrimaryContactObj = new AddPrimaryContact(contactObj, 'CA');
		Test.startTest();
		System.enqueueJob(addPrimaryContactObj);
		Test.stopTest();
		System.assertEquals(50, [SELECT count() FROM Contact WHERE AccountId IN :lstAccountIds]);
	}
}