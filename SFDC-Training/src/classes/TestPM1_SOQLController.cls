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
private class TestPM1_SOQLController {
	
	@TestSetup
    static void initializeData() {
        List<Account> accountList = new List<Account>();
        List<Opportunity> opportunityList = new List<Opportunity>();
		        
        for(Integer i = 0; i< 250; i++ ) {
        	accountList.add(new Account(Name='Account - '+ i));
        }
        insert accountList;
        
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
        insert opportunityList;
    }
    
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
    
}