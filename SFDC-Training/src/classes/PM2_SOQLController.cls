 /**
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-11-2018   Manish Patil  		Controller for PM2 Assignment 
 *	 											(Programatic model 2 assignment)
 **/
public with sharing class PM2_SOQLController {
	
	/**
	* controller
	**/
	public PM2_SOQLController() {
		lstAllContacts = new List<Contact>();
		// mapAllUsers  = new Map<Id, User>();
		mapAccountsById = new Map<Id, String>();
		mapAccountsByName = new Map<String, Id>();
		lstAccountByEnrollmentYear = new List<Account>();
		lstAccountByAddress = new List<Account>();
		lstOpportunity = new List<Opportunity>();
		lstEnrollMentYearSelected = new List<String>();
		mapOpportunitiesAggregate = new Map<Integer,Decimal>(); 
		mapLeadsByLeadSource = new Map<String, Integer>();
		mapLeadsbyLeadSourceDetail = new Map<String,  Map<String, Integer>>();
		
		lstEnrollMentYearUnSelected = new List<SelectOption>(); 
		lstEnrollMentYearUnSelected.add(new SelectOption('2010', '2010'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2011', '2011'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2012', '2012'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2013', '2013'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2014', '2014'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2015', '2015'));
		lstEnrollMentYearUnSelected.add(new SelectOption('2016', '2016'));
	}
	
	/**
	* properties
	**/
    public List<Contact> lstAllContacts { get; set;}
    public Map<Id, User> mapAllUsers { get; set;}
	public Map<Id, String> mapAccountsById { get; set;}     
	public Map<String, Id> mapAccountsByName { get; set;}
	public List<Account> lstAccountByEnrollmentYear { get; set;} 
	public List<Account> lstAccountByAddress { get; set;}
    public List<Opportunity> lstOpportunity { get; set;}
    public List<SelectOption> lstEnrollMentYearUnSelected { get; set;}
    public Map<Integer,Decimal> mapOpportunitiesAggregate { get; set;}
    public Map<String, Integer> mapLeadsByLeadSource { get; set;}
    public Map<String,  Map<String, Integer>> mapLeadsbyLeadSourceDetail { get; set;}
    
    public List<String> lstEnrollMentYearSelected  { get; set;}
    public Integer leadSourceCount { get; set;}
    /**
    * Method to get all contacts
    **/
    public PageReference getAllContacts() {
    	lstAllContacts = [SELECT Name FROM Contact LIMIT 5000];
    	return null;
    }
    
    /**
    * Method to get all users
    **/
    public PageReference getAllUsers() {
    	mapAllUsers = new Map<Id, User>([SELECT  Id, Name FROM User LIMIT 5000]);
    	return null;
    }
    
    /**
    * Method to return a map <Id, AccountId>
    **/ 
    public PageReference getAccountsGroupedById() {
    	for(Account accountObj : [SELECT Id, Name FROM Account LIMIT 5000]) {
    		mapAccountsById.put(accountObj.Id, accountObj.Name);
    	}
    	return null;
    }
    
    /**
    * Method to return a map <AccountName, Id>
    **/ 
    public PageReference getAccountsGroupedByName() {
    	for(Account accountObj : [SELECT Id, Name FROM Account LIMIT 5000]) {
    		mapAccountsByName.put(accountObj.Name, accountObj.Id);
    	}
    	return null;
    }
    
    /**
    * Method to fetch accounts by enrollment year
    **/
    public PageReference getAccountsByEnrollmentYear() {
    	String query = 'SELECT Name, Enrollment_year__c FROM Account WHERE '; 
		if(!lstEnrollMentYearSelected.isempty()) {
			for(Integer i = 0; i < lstEnrollMentYearSelected.size(); i++) {
				query = query + 'Enrollment_year__c INCLUDES(\'' +  lstEnrollMentYearSelected[i] + '\')';
				if(i != lstEnrollMentYearSelected.size() - 1) {
					query += ' AND ';
				}
				
			}
		}
    	lstAccountByEnrollmentYear = Database.query(query);
    	// SELECT Name, Enrollment_year__c 
    	// FROM Account 
    	// WHERE Enrollment_year__c INCLUDES('2013') AND Enrollment_year__c INCLUDES('2012')
    	return null;
    }
    
    /**
    * Method to get account whose Billing address is not Maharashtra/Kerela
    **/
    public PageReference getAccountsbyAddress() {
    	lstAccountByAddress = [SELECT Name, 
    								  BillingState 
    						   FROM Account 
    						   WHERE BillingState not in ('Maharashtra','Kerela') 
    						   ORDER BY BillingState DESC
    						   NULLS LAST
    						   LIMIT 1000];
		return null;
    }
    
    /**
    * Method to get opportunities
    **/
    public PageReference getOpportunities() {
    	
    	/*
    	SELECT Name, 
    		   Amount  
    	FROM Opportunity 
    	WHERE Amount > 10000
    	ORDER BY CreatedDate DESC
    	OFFSET 50
    	LIMIT 100 ALL ROWS
    	*/
    	
    	lstOpportunity = [SELECT Name, 
    							 Amount  
    					  FROM Opportunity 
    					  WHERE Amount > 10000
    					  ORDER BY CreatedDate DESC
    					  LIMIT 100 ALL ROWS];
		return null;
    }
    
    /**
    * Get number of Opportunity per year
    **/
    public PageReference getOpportunitiyCount() {
    	AggregateResult[] aggregateOpportunities = [SELECT 
														CALENDAR_YEAR(closedate), 
														SUM(Amount) 
											    	FROM OPPORTUNITY 
											    	// WHERE CloseDate = LAST_FISCAL_YEAR 
											    	WHERE CloseDate = THIS_FISCAL_YEAR
											    	GROUP BY closedate];
		for (AggregateResult ar : aggregateOpportunities)  {
			mapOpportunitiesAggregate.put(
				Integer.valueOf(ar.get('expr0')), 
				Decimal.valueOf(String.valueOf(ar.get('expr1')))
			); 
		}
		return null;
    }
    
    /**
    * Method to get Leads By LeadSource where LeadSource has more than 10 Leads
    **/
    public PageReference getLeadsByLeadSourceCount() {
    	mapLeadsByLeadSource.clear();
    	AggregateResult[] aggregateLeads = [SELECT 
    											LeadSource, 
    											count(Name) 
    										FROM Lead 
    										GROUP BY LeadSource 
    										HAVING COUNT(LeadSource) > :leadSourceCount];
		for(AggregateResult ar : aggregateLeads) {
			mapLeadsByLeadSource.put(String.valueOf(ar.get('LeadSource')), Integer.valueOf(ar.get('expr0')));
		}
		
		return null;		
    }
    
    /**
    * Method to write a SOQL query to find total number of Lead records by status Source. 
	* Store this information in map information in map information in map and display the same.
    **/
    public PageReference getLeadsByLeadSourceDetail() {
    	mapLeadsbyLeadSourceDetail.clear();
    	AggregateResult[] aggregateLeads = [SELECT 
    											status, 
    											LeadSource, 
    											count(name) 
    										FROM Lead 
    										GROUP BY LeadSource, status];
    	Map<String, Integer> lstLEadSrc = new Map<String, Integer>();
		for(AggregateResult ar : aggregateLeads) {
			
			if(mapLeadsbyLeadSourceDetail.containsKey(String.valueOf(ar.get('Status')))) {
				lstLEadSrc = mapLeadsbyLeadSourceDetail.get(String.valueOf(ar.get('Status')));
				lstLEadSrc.put(String.valueOf(ar.get('LeadSource')), Integer.valueOf(ar.get('expr0')));
				
				mapLeadsbyLeadSourceDetail.put(
					String.valueOf(ar.get('Status')),
					lstLEadSrc
						 
				);			
			}
			else{
				mapLeadsbyLeadSourceDetail.put(
					String.valueOf(ar.get('Status')),
					new Map<String, Integer> {
						String.valueOf(ar.get('LeadSource')) =>
						Integer.valueOf(ar.get('expr0'))
					}
				);
			}
		}
		
		return null;		
    }
}