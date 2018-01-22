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
 *   v1.0     Jan-22-2018   Manish Patil  		Test class for InvoiceDocumentExtension
 */
@isTest
private class TestInvoiceDocumentExtension {
	
	static InvoiceDocumentExtension controllerObj;
	
	/**
	* Method to initialize data
	**/
	@testSetup
	static void initData() {
	   	TestDataFactory.createInvoice_Statement(200);
	}
	
	/**
	* Method to test the total amount of the invoice
	**/
	@isTest
	private static void testTotalAmount() {
		Invoice_Statement__c invoiceObj = [SELECT 
											   Id, 
											   Name, 
											   (SELECT Name,Unit_Price__c, Unit_Sold__c FROM Line_Items__r) 
										   FROM Invoice_Statement__c LIMIT 1];
										   
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(invoiceObj);
		controllerObj = new InvoiceDocumentExtension(stdControllerObj);
		
		Test.startTest();
		Decimal totalAmountRetrieved = controllerObj.totalAmount;
		Test.stopTest();
		
		Decimal amount = 0.0;		
		for(Line_Item__c lineItemObj : invoiceObj.Line_Items__r) {
    		amount += (lineItemObj.Unit_Price__c * lineItemObj.Unit_Sold__c);
    	}
		
		System.assertEquals(amount, totalAmountRetrieved);
		System.assertEquals(amount, controllerObj.totalAmount);		
	}
}