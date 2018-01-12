/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Jan-5-2018   Manish Patil  	Programmatic Model - 1 SOQL Assignment code 
*/
public with sharing class PM1_SOQLController {
	
	public PM1_SOQLController() {
    	opportunityMap = new Map<Id, Id>();
    	opportunityMapKeyNames = new Set<Id>();
    	lstAccount = new List<Account>();
    	mapAccountOpportunities = new Map<Id, List<Id>>();
    	lstAccountOpportunities = new Set<Id>();
    	lstCampaign  = new List<Campaign>();
    	lstConatctUpdatedToday =new List<Contact>(); 
    	lstAccountSosl = new List<Account>(); 
		lstContactSosl = new List<Contact>();
		lstLeadSosl = new List<Lead>();
		lstPersonalAccounts = new List<Account>(); 
    	
    	sortingOptions= new List<SelectOption>();
    	sortingOptions.add(new SelectOption('ASC', System.Label.Ascending));
    	sortingOptions.add(new SelectOption('DESC', System.Label.Descending));
    	radioSortingSelection = 'ASC';
    }
    
    public Map<Id, Id> opportunityMap { get; set;}  
    public Set<Id> opportunityMapKeyNames { get; set;}
    
    public Integer accountCount { get; set;}
    public List<Account> lstAccount { get; set;}
    public Map<Id, List<Id>> mapAccountOpportunities { get; set;}
    public Set<Id> lstAccountOpportunities { get; set;}
	public String radioSortingSelection { get; set;}
	public List<SelectOption> sortingOptions  { get; set;}
	public List<Campaign> lstCampaign  { get; set;}
	public List<Contact> lstConatctUpdatedToday { get; set;} 
       
    public String searchStringSoql { get; set;}
	public List<Account> lstAccountSosl { get; set;}
	public List<Contact> lstContactSosl { get; set;}
	public List<Lead> lstLeadSosl { get; set;}
	public List<Account> lstPersonalAccounts { get; set;}
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
    
    /**
    * Method to get Accounts wil opportunities
    **/
    public PageReference queryAccountOpportunity() {
    	for(Account accountObj : [SELECT Id, (SELECT Name FROM Opportunities) FROM Account]) {
		    for(Opportunity oppObj : accountObj.opportunities){
		        if(mapAccountOpportunities.containsKey(accountObj.Id)){
					List<Id> opportunityIdList = mapAccountOpportunities.get(accountObj.Id);
		            opportunityIdList.add(oppObj.Id);
		            mapAccountOpportunities.put(accountObj.Id, opportunityIdList);
		        }
		        else {
		            mapAccountOpportunities.put(accountObj.Id, new List<id> { oppObj.Id });
		        }
		    }
		}
		lstAccountOpportunities = mapAccountOpportunities.keySet();
		return null;
    }
    
    /**
    * Method to get 10 campaigns and sort order will be selected by the user
    **/
    public PageReference query10Campaigns() {
    	String query = System.Label.CMSelectQuery
    					+ ' ORDER BY Name '
    					+ radioSortingSelection +
    					' LIMIT 10';
    	lstCampaign = Database.query(query);
    	return null;
    }
    
    /**
    * Method to get contacts which were modified today
    **/
    public PageReference queryContactsModifiedToday() {
    	lstConatctUpdatedToday = [SELECT Name FROM Contact WHERE LastModifiedDate = Today];
    	return null;
    }
    
    /**
    * Method to get records from Account, Contact and Leads where searchstring is matched in 
    * Name/First Name/Last Name
    **/
    public PageReference querySOSL() {
    	List<List<sObject>> lstSearchResult = [FIND :searchStringSoql IN ALL FIELDS 
    										   RETURNING Account(Name), 
    										   			 Contact(FirstName, LastName),
    										   			 Lead(FirstName, LastName)];
		lstAccountSosl = ((List<Account>)lstSearchResult[0]);
		lstContactSosl= ((List<Contact>)lstSearchResult[1]);
		lstLeadSosl = ((List<Lead>)lstSearchResult[2]);
		return null;
    }
    
    /**
    * Method to get personal accounts
    **/
    public PageReference queryPersonalAccounts() {
    	lstPersonalAccounts = [SELECT Name FROM Account WHERE Is_Persoanl_Account__c = true];
    	return null;
    }
}