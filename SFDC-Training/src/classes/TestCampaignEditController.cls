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
 *   v1.0     Dec-26-2017   Manish Patil  	Test class for CampaignEditController
 */
@isTest
private class TestCampaignEditController {
	
	static CampaignEditController controllerObj;
	
	/**
	*  method to initialize 50 records in Campaign object
	**/
	@TestSetup
	static void getControllerInstance()
	{
		Campaign campaignObj=new Campaign(Name='Test');
		insert campaignObj;
		/*
		PageReference pageReferenceObj = Page.CM_Campaign_Edit;
        Test.setCurrentPage(pageReferenceObj);
        pageReferenceObj.getParameters().put('Id', String.valueOf(campaignObj.Id));
        */
	}

	/**
	*  method to test edit campaign functionality
	**/
	@isTest
	private static void testCampaignEditFunctionality(){
		
		Campaign campaignObj = [SELECT Name 
								FROM Campaign 
								WHERE Name='Test' 
								LIMIT 1]; 
        campaignObj.Name = 'Test Updated';
		
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		controllerObj = new CampaignEditController(stdControllerObj);		
		
		Test.startTest();
		PageReference returnedPageReference = controllerObj.saveAndRedirect();
		Test.stopTest();
		
		System.assertEquals(returnedPageReference.getUrl(), 
							System.Label.CM_Campaign_Detail_URL + campaignObj.Id);
		System.assertEquals(1, [SELECT count() 
								FROM Campaign 
								WHERE Name='Test Updated']);
	}

	/**
	*  method to test delete campaign functionality
	**/
	@isTest
	private static void testCampaignDeleteFunctionality(){
		Campaign campaignObj = [SELECT Name 
								FROM Campaign 
								WHERE Name='Test' LIMIT 1]; 
        
        ApexPages.StandardController stdControllerObj=new ApexPages.StandardController(campaignObj);
		controllerObj=new CampaignEditController(stdControllerObj);		
        
        Test.startTest();
		PageReference returnedPageReference = controllerObj.deleteCampaign();
		Test.stopTest();
		
		System.assertEquals(returnedPageReference.getUrl(),System.Label.CMCampaignLandingPage);
		System.assertEquals(0, [SELECT count() 
								FROM Campaign 
								WHERE Name='Test']);
        
	}
}