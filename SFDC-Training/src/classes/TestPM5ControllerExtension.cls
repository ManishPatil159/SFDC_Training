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
 *   v1.0     Jan-16-2018   Manish Patil  		Test class for PM5ControllerExtension 
 *
 */
@isTest
public class TestPM5ControllerExtension {
    
    @testSetup
    private static void initializeData() {
    	TestDataFactory.createAccounts(200);
    }
    
    /**
    * Test method to test functionality to get all accounts
    **/
    @isTest
    private static void testGetAllAccounts() {
    	List<Account> lstAccount = [SELECT Name, PersonEmail__c, Phone, Website FROM Account];
    	Account accountObj = lstAccount.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	controllerObj.getAllAccounts();
    	Test.stopTest();
    	
    	System.assert(lstAccount.equals(controllerObj.lstAccount));
    }
    
    /**
    * Test method to test functioanlity to test search functioanlity
    **/
    @isTest
    private static void testSearchAccounts() {
    	List<Account> lstAccount = [SELECT 
				    		  		  	Name, 
				    				  	PersonEmail__c, 
				    				  	Phone, 
				    				  	Website 
			    				  	FROM Account 
			    				  	WHERE Name LIKE '%Account - 2%'];
    	
    	Account accountObj = lstAccount.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	controllerObj.searchString = 'Account - 2';
    	controllerObj.searchAccounts();
    	Test.stopTest();
    	
    	System.assert(lstAccount.equals(controllerObj.lstAccount));
    }
    
    /**
    * test method to test the functionality to clear all filters
    **/
    @isTest
    private static void testClearSearch() {
    	Account accountObj = [SELECT Name, PersonEmail__c, Phone, Website FROM Account LIMIT 1];
    	ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	controllerObj.searchString = 'Account - 2';
    	controllerObj.clearSearch();
    	Test.stopTest();
    	
    	System.assertEquals('', controllerObj.searchString);
    }
    
    /**
    * Test method to test functionality to filter accounts by alphabet 'A'
    * i.e. fetch records which start by 'A' 
    **/
    @isTest
    private static void testAlphabeticalSearchForA() {
    	List<Account> lstAccount = [SELECT 
								    	Name, 
								    	PersonEmail__c, 
								    	Phone, 
								    	Website 
							    	FROM Account 
							    	WHERE Name LIKE 'A%'];
    	
    	Account accountObj = lstAccount.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	controllerObj.searchString = 'A';
    	controllerObj.alphabeticalSearch();
    	Test.stopTest();
    	
    	System.assert(lstAccount.equals(controllerObj.lstAccount));
    }
    
    /**
    * Test method to test functionality to filter accounts by alphabet 'T'
    * i.e. fetch records which start by 'T'
    * Negative test as no records exists which start wilt 'T' 
    **/
    @isTest
    private static void testAlphabeticalSearchForT() {
    	List<Account> lstAccount = [SELECT 
								    	Name, 
								    	PersonEmail__c, 
								    	Phone, 
								    	Website 
							    	FROM Account 
							    	WHERE Name LIKE 'T%'];
    	
    	Account accountObj = [SELECT Name, PersonEmail__c, Phone, Website FROM Account LIMIT 1];
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	controllerObj.searchString = 'T';
    	controllerObj.alphabeticalSearch();
    	Test.stopTest();
    	
    	System.assert(lstAccount.equals(controllerObj.lstAccount));
    }
    
    /**
    * Test method to test then functionality to delete accounts. 
    **/
    @isTest
    private static void testDeleteAccounts() {
    	Account accountObj = [SELECT 
								    	Name, 
								    	PersonEmail__c, 
								    	Phone, 
								    	Website 
							    	FROM Account 
							    	WHERE Name = 'Account - 2' LIMIT 1];
    	
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(accountObj);
		PM5ControllerExtension controllerObj = new PM5ControllerExtension(stdControllerObj);	
    	    	
    	Test.startTest();
    	PM5ControllerExtension.deleteAccount(accountObj.Id);
    	Test.stopTest();
    	
    	Integer deletedAccountCount = [SELECT count() FROM Account WHERE Name = 'Account - 2'];
    	System.assertEquals(0, deletedAccountCount);
    }
}