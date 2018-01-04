public with sharing class PM1_SOQLController {
	
	public PM1_SOQLController() {
    	opportunityMap = new Map<Id, Id>();
    	opportunityMapKeyNames = new Set<Id>();
    	lstAccount = new List<Account>();
    }
    
    public Map<Id, Id> opportunityMap { get; set;}  
    public Set<Id> opportunityMapKeyNames { get; set;}
    
    public Integer accountCount { get; set;}
    public List<Account> lstAccount { get; set;}
    
    /**
    * Method to fetch opportunities whose stage is closed and account is not null
    **/
    public PageReference queryOpportunities() {
    	for(Opportunity opportunityObj : [ SELECT  Id,  AccountId
									   FROM Opportunity 
									   WHERE 
									   	AccountId != NULL
										AND (StageName='Closed Won' 
										OR StageName='Closed Lost')]){
			opportunityMap.put(opportunityObj.Id, opportunityObj.AccountId);
    	}
    	opportunityMapKeyNames = opportunityMap.keySet();
    	return null;
    }
    
    /**
    * Method to query accounts whose names start with 'a' and update their name
    **/
    public PageReference queryAccounts() {
    	accountCount = [SELECT count() FROM Account WHERE Name LIKE 'a%'];
    	lstAccount = [SELECT Id, Name FROM Account WHERE Name LIKE 'a%'];
    	
    	for(Account accountObj : lstAccount){
    		accountObj.Name = 'Updated via update DML operation '+ accountObj.Name;
    	}
    	Database.update(lstAccount);
    	return null;
    }
}