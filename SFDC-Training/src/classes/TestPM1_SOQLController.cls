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
 *   v1.0     Jan-08-2018   Manish Patil  	Test class for Pm1SOQLController
 * 											(Programatic model 1 assignment)
 */
@isTest
private class TestPM1_SOQLController {
	/*
	* Method to initialize the test data
	*/
	@TestSetup
    static void initializeData() {
        List<Account> accountList = new List<Account>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        List<Campaign> campaignList = new List<Campaign>();
        List<Contact> contactList = new List<Contact>();
        List<Lead> leadList = new List<Lead>();
		        
		// Create Accounts
        for(Integer i = 0; i< 250; i++ ) {
        	accountList.add(new Account(Name='Account - '+ i));
        }
        insert accountList;
        
        // Create Opportunities
        opportunityList = createOpportunities(accountList);
        insert opportunityList;
        
        //create campaigns
        campaignList = createCampaigns();
        insert campaignList;
        
        //create Contacts
        contactList = createContacts(accountList);
        insert contactList;
        
        //create Leads
        leadList = createLeads();
        insert leadList;
    }
    
    /**
    * Method to test queryOpportunities function in PM1_SOQLController
    **/
    @isTest
    private static void TestQueryOpportunities() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	Map<Id,Id> expectedOpportunityMap = new Map<Id,Id>(); 
		for(Opportunity opportunityObj : [ SELECT  Id,  AccountId
									   		 FROM Opportunity 
									   		 WHERE 
									   		 	AccountId != NULL
												AND (StageName='Closed Won' 
												OR StageName='Closed Lost')]){
			expectedOpportunityMap.put(opportunityObj.Id, opportunityObj.AccountId);
    	}
		
		
		Test.startTest();
		controllerObj.queryOpportunities();
		Test.stopTest();
    	
    	System.Assert(expectedOpportunityMap.equals(controllerObj.opportunityMap), 'Check generated map');
    }
    
    /**
    * Method to test queryAccounts function in PM1_SOQLController
    **/
    @isTest
    private static void TestQueryAccounts() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	
    	Integer expectedAccountCount = [SELECT count() 
    									FROM Account 
    									WHERE Name LIKE 'a%'];
    	List<Account> expectedLstAccount = [SELECT Id, Name 
    										FROM Account 
    										WHERE Name LIKE 'a%'];
    	
    	Test.startTest();
    	controllerObj.queryAccounts();
    	Test.stopTest();
    	
    	List<Account> updatedListAccount = [SELECT Name 
    										FROM Account 
    										WHERE Name LIKE 'Updated via update DML operation%'];
    										
		Integer countAfterUpdate = [SELECT count() 
    									FROM Account 
    									WHERE Name LIKE 'a%'];
    				
    	System.assertEquals(expectedAccountCount, controllerObj.accountCount);
    	
    	for(Integer i=0; i<expectedAccountCount; i++ ){
    		// System.assert(expectedLstAccount.equals(controllerObj.lstAccount));
    		System.assertEquals(expectedLstAccount[i].Id, controllerObj.lstAccount[i].Id);
    	}	
    	
    	
    	System.assertEquals(updatedListAccount.size(), controllerObj.accountCount);
    	System.assertEquals(0, countAfterUpdate);
    }
    
    /**
    * Method to test queryPersonalAccounts function in PM1_SOQLController
    **/
    @isTest
    private static void TestQueryPersonalAccounts() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	List<Account> expectedLstPersonalAccounts = [SELECT Name FROM Account WHERE Is_Persoanl_Account__c = true];
    	Test.startTest();
    	controllerObj.queryPersonalAccounts();
    	Test.stopTest();
    	
    	for(Integer i = 0; i< expectedLstPersonalAccounts.size(); i++ ) {
    		System.assertEquals(expectedLstPersonalAccounts[i].Id, controllerObj.lstPersonalAccounts[0].Id);
    	}
    }
    
    /**
    * Method to test queryAccountOpportunity function in PM1_SOQLController
    **/
    @isTest
    private static void TestQueryAccountOpportunity() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	List<Account> expectedLstAccount = [SELECT Id, (SELECT Name FROM Opportunities) FROM Account];
    	
    	Test.startTest();
    	controllerObj.queryAccountOpportunity();
    	
    	for(Account accountObj : expectedLstAccount) {
    		System.assert(controllerObj.mapAccountOpportunities.containsKey(accountObj.Id), 'Account Id exists in keys');
    		List<Id> opportunityIdList = controllerObj.mapAccountOpportunities.get(accountObj.Id);
    		opportunityIdList.equals(accountObj.opportunities);
    	}  
    	Test.stopTest();
    	
    }
    
    /**
    * Method to test query10Campaigns function in PM1_SOQLController (Ascending order)
    **/
    @isTest
    private static void TestQuery10CampaignsAsc() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	String query = System.Label.CMSelectQuery + ' ORDER BY Name ASC LIMIT 10';
    	List<Campaign> expectedLstCampaign = Database.query(query);
    	
    	Test.startTest();
    	controllerObj.query10Campaigns();
    	Test.stopTest();
    	
    	System.assert(expectedLstCampaign.equals(controllerObj.lstCampaign), '10 campaigns queried in ASC');
    }
    
    /**
    * Method to test query10Campaigns function in PM1_SOQLController (Descending Order)
    **/
    @isTest
    private static void TestQuery10CampaignsDesc() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	String query = System.Label.CMSelectQuery + ' ORDER BY Name DESC LIMIT 10';
    	List<Campaign> expectedLstCampaign = Database.query(query);
    	
    	Test.startTest();
    	controllerObj.radioSortingSelection = 'DESC';
    	controllerObj.query10Campaigns();
    	Test.stopTest();
    	
    	System.assert(expectedLstCampaign.equals(controllerObj.lstCampaign), '10 campaigns queried in ASC');
    }
    
    /**
    * Method to test ueryContactsModifiedToday function in PM1_SOQLController
    **/
    @isTest
    private static void TestQueryContactsModifiedToday() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	List<Contact> expectedContactLst = [SELECT Name FROM Contact  WHERE LastModifiedDate = Today];
    	
    	Test.startTest();
    	controllerObj.queryContactsModifiedToday();
    	Test.stopTest();
    	
    	System.assertEquals(expectedContactLst.size(), controllerObj.lstConatctUpdatedToday.size(), 'one record is modified today');
    	System.assert(expectedContactLst.equals(controllerObj.lstConatctUpdatedToday), 'Same object is retrieved');
    }
    
    /**
    * Method to test querySOSL function in PM1_SOQLController
    **/
    @isTest
    private static void TestQuerySOSL() {
    	PM1_SOQLController controllerObj = new PM1_SOQLController();
    	String searchString = 'Account - 2';
    	List<List<sObject>> lstSearchResult = [FIND :searchString IN ALL FIELDS 
    										   RETURNING Account(Name), 
    										   			 Contact(FirstName, LastName),
    										   			 Lead(FirstName, LastName)];
		Test.startTest();
		controllerObj.searchStringSoql = searchString;
		controllerObj.querySOSL();
		Test.stopTest();
		System.assert(((List<Account>)lstSearchResult[0]).equals(controllerObj.lstAccountSosl),'compare accounts');
		System.assert(((List<Contact>)lstSearchResult[1]).equals(controllerObj.lstContactSosl),'compare accounts');
		System.assert(((List<Lead>)lstSearchResult[2]).equals(controllerObj.lstLeadSosl),'compare accounts');
    }
    
    
    /*
    * Create Opportunities for test data
    */
    private static List<Opportunity> createOpportunities(List<Account> accountList) {
    	List<Opportunity> opportunityList = new List<Opportunity>();
    	for(Integer i = 0; i< 250; i++ ) {
        	if(math.mod(i,2)==0) {
        		opportunityList.add(new Opportunity(
        								Name='Opportunity - '+ i, 
        								CloseDate = Date.newInstance(2018, 12, 17), 
        								StageName = 'Closed Won',
        								AccountId = accountList[i].Id
        							));
        	}
        	else if(math.mod(i,3)==0) {
        		System.debug(accountList[i].Id);
        		opportunityList.add(new Opportunity(
        								Name='Opportunity - '+ i, 
        								CloseDate = Date.newInstance(2018, 12, 17), 
        								StageName = 'Closed Lost',
        								AccountId = accountList[i].Id
        							));
        	}
        	else {
        		opportunityList.add(new Opportunity(
        								Name='Opportunity - '+ i, 
        								CloseDate = Date.newInstance(2018, 12, 17), 
        								StageName = 'Prospecting',
        								AccountId = accountList[i].Id
        							));
        	}
        }
        opportunityList.add(new Opportunity(
        								Name='Opportunity - Redundant', 
        								CloseDate = Date.newInstance(2018, 12, 17), 
        								StageName = 'Prospecting',
        								AccountId = accountList[0].Id
        							));
		return opportunityList;
    }
    
    private static List<Campaign> createCampaigns() {
    	List<Campaign> lstCampaignsCreated = new List<Campaign>();
    	for(Integer i = 0; i < 50; i++) {
    		lstCampaignsCreated.add(new Campaign(Name = 'Campaign - ' + i));
    	}
    	return lstCampaignsCreated;
    }
    
    private static List<Contact> createContacts(List<Account> accountList) {
    	List<Contact> lstContactsCreated = new List<Contact>();
    	for(Integer i = 0; i < 50; i++) {
    		lstContactsCreated.add(new Contact(LastName = 'Contact - ' + i, AccountId = accountList[i].Id));
    	}
    	return lstContactsCreated;
    }
    
    private static List<Lead> createLeads() {
    	List<Lead> lstLeadsCreated = new List<Lead>();
    	for(Integer i = 0; i < 50; i++) {
    		lstLeadsCreated.add(new Lead(
    								LastName = 'Lead - ' + i, 
    								Company = 'ESPL', 
    								Status = 'Open - Not Contacted')
    		);
    	}
    	return lstLeadsCreated;
    }
    
}