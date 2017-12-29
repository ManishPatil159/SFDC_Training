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
 *   v1.0     Dec-26-2017   Manish Patil  	Test class for CampaignLandingPageController
 *
 */
@isTest
private class TestCampaignLandingPageController {

	/**
	*  method to initialize 50 records in Campaign object
	**/
	@TestSetup
    static void initializeData() {
        // TO DO: implement unit test
        List<Campaign> listOfCampaigns=new List<Campaign>();
        
        for(Integer index=0;index<50; index++){
        	if(index==2 || index == 5){
        		listOfCampaigns.add(new Campaign(Name='Test '+index, IsActive=true));
        	}
        	else{
				listOfCampaigns.add(new Campaign(Name='Test '+index));
        	}
		}
        insert listOfCampaigns;
    }
    
    /**
    * method to check the initial state of application
    * i.e. when Recent Modified is selected
    **/
    @isTest
    private static void testInitialCampaignView(){
    	List<Campaign> listOfCampaigns = [SELECT Id, 
    											 Name, 
    											 Status, 
    											 StartDate 
    								      FROM Campaign 
    								      ORDER BY LastModifiedDate DESC 
    								      LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		Test.startTest();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Integer pageNumber = controllerObj.getPageNumber();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
		System.assertEquals(1, pageNumber);
    }
    
    /*
    * method to test functionality when all campaigns is selected.
    */
    @isTest
    private static void testAllCampaignsView(){
    	List<Campaign> listOfCampaigns = [SELECT Id, 
    									  		 Name, 
    									  		 Status, 
    									  		 StartDate 
    									  FROM Campaign 
    									  ORDER BY StartDate DESC 
    									  LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		controllerObj.strFilterId='AllCampaigns';
		
		Test.startTest();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
    }


	/*
	* method to test functionality when "All Active Campaigns" is selected.
	*/    
    @isTest
    private static void testAllActiveCampaignsView(){
    	List<Campaign> listOfCampaigns = [SELECT Id, 
    											 Name, 
    											 Status, 
    											 StartDate 
								    	  FROM Campaign  
								    	  WHERE IsActive = true 
								    	  ORDER BY StartDate DESC 
								    	  LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		controllerObj.strFilterId = 'AllActiveCampaigns';
		
		Test.startTest();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
		
    }
    
    /*
    * method to test functionality when "All Inactive Campaigns" is selected.
    */
    @isTest
    private static void testAllInActiveCampaignsView(){
    	List<Campaign> listOfCampaigns = [SELECT Id, Name, Status, StartDate 
										  FROM Campaign
										  WHERE IsActive = false 
										  ORDER BY StartDate DESC 
										  LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		controllerObj.strFilterId = 'InactiveCampaigns';
		
		Test.startTest();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
		
    }
    
    /*
    * method to test Next page functionality
    */
    @isTest
    private static void testNextPageFunctionality(){
		List<Campaign> listOfCampaigns = [SELECT Id, 
												 Name, 
												 Status, 
												 StartDate 
										  FROM Campaign 
										  ORDER BY LastModifiedDate DESC 
										  LIMIT 20 OFFSET 20];
		//Campaign campaignObj=;
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(listOfCampaigns.get(0));
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		Test.startTest();
		controllerObj.Next();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
    	
    }
    
    /*
    * method to test Previous page functionality
    */
    @isTest
    private static void testPreviousPageFunctionality(){
		List<Campaign> listOfCampaigns = [SELECT Id, 
												 Name, 
												 Status, 
												 StartDate 
										  FROM Campaign 
										  ORDER BY LastModifiedDate DESC 
										  LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		Test.startTest();
		controllerObj.Next();
		controllerObj.Previous();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
    	
    }
    
    /*
    * method to test functionality to go to last page
    */
    @isTest
    private static void testLastPageFunctionality(){
		List<Campaign> listOfCampaigns = [SELECT Id, 
												 Name, 
												 Status, 
												 StartDate 
										  FROM Campaign 
										  ORDER BY LastModifiedDate DESC 
										  LIMIT 20 OFFSET 40];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		Test.startTest();
		List<Campaign> listOffirstPageCampaigns = controllerObj.getCampaigns();
		controllerObj.End();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Boolean isNextDisabled=controllerObj.getDisableNext();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
    	System.assertEquals(true, isNextDisabled);
    }
    
    /*
    * method to test functionality to go to the first page
    */
    @isTest
    private static void testFirstPageFunctionality(){
		List<Campaign> listOfCampaigns = [SELECT Id, 
												 Name, 
												 Status, 
												 StartDate 
									      FROM Campaign 
									      ORDER BY LastModifiedDate DESC 
									      LIMIT 20 OFFSET 0];
		Campaign campaignObj=listOfCampaigns.get(0);
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(campaignObj);
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		Test.startTest();
		controllerObj.Next();
		List<Campaign> listOfCampaignsReturnedForPage1 = controllerObj.getCampaigns();
		controllerObj.Beginning();
		List<Campaign> listOfCampaignsReturned = controllerObj.getCampaigns();
		Boolean isPreviousDisabled=controllerObj.getDisablePrevious();
		Test.stopTest();
		
		System.assertEquals(listOfCampaigns.size(), listOfCampaignsReturned.size());
		for(Integer i = 0; i < listOfCampaigns.size(); i++){
			System.assertEquals(listOfCampaigns.get(i).Id, listOfCampaignsReturned.get(i).Id);
		}
		System.assertEquals(true,isPreviousDisabled);
    	
    }
    
    /*
    * method to test the filter dropdown values 
    */
    @isTest
    private static void testListOfFilterOptions() {
    	List<Campaign> listOfCampaigns = [SELECT Id, 
										 	 Name, 
											 Status, 
											 StartDate 
									      FROM Campaign 
									      ORDER BY LastModifiedDate DESC 
									      LIMIT 1];
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(listOfCampaigns.get(0));
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);	
		
		List<SelectOption> listOfExpectedFilterOptions= new List<SelectOption>();
        listOfExpectedFilterOptions.add(new SelectOption('RecentlyModified', System.Label.RecentlyModified));    
        listOfExpectedFilterOptions.add(new SelectOption('AllCampaigns', System.Label.AllCampaigns));
        listOfExpectedFilterOptions.add(new SelectOption('AllActiveCampaigns', System.Label.AllActiveCampaigns));
        listOfExpectedFilterOptions.add(new SelectOption('InactiveCampaigns', System.Label.InactiveCampaigns));
		
		//Test.startTest();
		
		//Test.stopTest();
		System.assertEquals(listOfExpectedFilterOptions.size(), controllerObj.listOfFilterOptions.size());
		System.assertEquals(listOfExpectedFilterOptions.get(0), new SelectOption('RecentlyModified', System.Label.RecentlyModified));
		System.assertEquals(listOfExpectedFilterOptions.get(1), new SelectOption('AllCampaigns', System.Label.AllCampaigns));
		System.assertEquals(listOfExpectedFilterOptions.get(2), new SelectOption('AllActiveCampaigns', System.Label.AllActiveCampaigns));
		System.assertEquals(listOfExpectedFilterOptions.get(3), new SelectOption('InactiveCampaigns', System.Label.InactiveCampaigns));
    }
    
    /*
    * test get total pages method
    */
    @isTest
    private static void testGetTotalPages() {
    	List<Campaign> listOfCampaigns = [SELECT Id
									      FROM Campaign];
									      
		ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(listOfCampaigns.get(0));
		CampaignLandingPageController controllerObj = new CampaignLandingPageController(stdControllerObj);
		Test.startTest();
		List<Campaign> listOfCampaignsReturnedInitially = controllerObj.getCampaigns();
		Integer totalPages = controllerObj.getTotalPages();
		Test.stopTest();
		System.assertEquals(math.mod(listOfCampaigns.size(), 20)>0 ? 
					        		(listOfCampaigns.size()/20) + 1 :
					        		(listOfCampaigns.size()/ 20), 
					        totalPages);
    }
}