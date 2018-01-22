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
 *   v1.0     Jan-16-2018   Manish Patil  		Class to create test data for unit tests 
 *
 */
@isTest
public class TestDataFactory {
	/**
	* Method to create accounts.
	* @param: 
	* 	accountCount: number of accounts to create
	**/
	public static List<Account> createAccounts(Integer accountCount) {
    	List<Account> lstAccount = new List<Account>();
    	for(Integer i = 0; i < accountCount; i++ ) {
    		lstAccount.add(
    			new Account(
    				Name = 'Account - '+ i,
    				PersonEmail__c = 'email' + i + '@test' + i + '.com',
    				Website = 'https://website'+i+'.com'
    			)
    		);
    	}
    	return lstAccount;    	
    }
    
    /**
	* Method to create contacts.
	* @param: 
	* 	contactCount: number of contacts to create
	**/
    public static List<Contact> createContacts(Integer contactCount) {
    	List<Contact> lstContact = new List<contact>();
    	for(Integer i =0; i < contactCount; i++) {
    		lstContact.add(
    			new Contact(
    				LastName = 'LastName' + i, 
    				Email = 'contactEmail' + i + '@test' + i + '.com'
    			)
    		);
    	}
    	return lstContact;
    }
    
    /**
    * Method to create accounts with contacts
    **/
    public static void createAccountWithContacts(Integer accountCount) {
    	List<Account> lstAccount = new List<Account>();
    	for(Integer i = 0; i < accountCount; i++ ) {
    		lstAccount.add(
    			new Account(
    				Name = 'Account - '+ i,
    				PersonEmail__c = 'email' + i + '@test' + i + '.com',
    				Website = 'https://website'+i+'.com'
    			)
    		);
    	}
    	insert lstAccount;
    	
    	List<Contact> lstContact = new List<contact>();
    	for(Integer i =0; i < accountCount; i++) {
    		lstContact.add(
    			new Contact(
    				LastName = 'LastName' + i, 
    				Email = 'contactEmail' + i + '@test' + i + '.com',
    				AccountId = lstAccount[i].Id
    			)
    		);
    	}
    	lstContact.add(
    			new Contact(
    				LastName = 'LastName_new', 
    				Email = 'contactEmail_new@test9999.com',
    				AccountId = lstAccount[2].Id
    			)
    	);
    	insert lstContact;
    }
    
    /**
    * Method to create leads
    **/
    public static void createLeads(Integer leadCount) {
    	List<Lead> lstLead = new List<Lead>(); 
    	for(Integer i = 0; i < leadCount; i++) {
    		lstLead.add(
    			new Lead(
    				LastName = 'LastName' + i, 
    				Company = 'Company-' + i, 
    				Status = 'Open - Not Contacted'));
    	}
    	insert lstLead;
    }

	/**
	* Method to generate Invoice Statements
	**/
	public static void createInvoice_Statement(Integer invoiceCount) {
		List<Account> lstAccounts = TestDataFactory.createAccounts(50);
		insert lstAccounts;
		
		List<Invoice_Statement__c> lstInvoices = new List<Invoice_Statement__c>();
		for(Integer i = 0; i<invoiceCount; i++) {
			lstInvoices.add(new Invoice_Statement__c(Account__c = lstAccounts[0].Id));
		}
		insert lstInvoices;
		
		List<Merchandise__c> lstMerchants = new List<Merchandise__c>();
		for(Integer i = 0; i<invoiceCount; i++) {
			lstMerchants.add(
				new Merchandise__c(
					Name='Merchandice' + i, 
					Description__c = 'Test Description' + i,
					Price__c = (100 * i),
					Total_Inventory__c = i
				)
			);
		}
		insert lstMerchants;
		 
		List<Line_Item__c> lstLineItem = new List<Line_Item__c>();
		for(Integer i = 0; i< invoiceCount; i++) {
			lstLineItem.add(
				new Line_Item__c(
					Name='LineItem-' + i, 
					Invoice_Statement__c = lstInvoices[i].Id, 
					Merchandise_Name__c = lstMerchants[i].Id, 
					Unit_Price__c = (100 * i), 
					Unit_Sold__c = i
				)
			);
		}
		insert lstLineItem;
	}
}