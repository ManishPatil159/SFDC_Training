/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-16-2018   Manish Patil  		Extension class for programmatic model 5 assignment 
 *
 */
global with sharing class PM5ControllerExtension {
	
	// private Account accountObj;
    public PM5ControllerExtension(ApexPages.StandardController controller) {
    	// accountObj = (Account)controller.getRecord();
    	
    	lstAccount = new List<Account>();
    	
    	getAllAccounts();
    }
    
    public List<Account> lstAccount { get; set;}
    public String searchString { get; set;}
    
    /**
    * Method to get all accounts
    **/
    public PageReference getAllAccounts() {
    	lstAccount = getAccountsSOQL();
    	return null;
    }

	/**
	* Method to return accounts filtered by search criteria (searchString)
	**/    
    public PageReference searchAccounts() {
    	lstAccount = getAccountsSOQL();
    	return null;
    }
    
    /**
    * Method to clear search criteria.
    * i.e. to reset searchString
    **/
    public PageReference clearSearch() {
    	searchString = '';
    	lstAccount = getAccountsSOQL();
    	return null;
    }
    
    /**
    * Method to filter accounts by selected alphabet
    **/
    public PageReference alphabeticalSearch() {
    	searchString = searchString + '%';
    	lstAccount = [SELECT Name, PersonEmail__c, Phone, Website FROM Account WHERE Name LIKE :searchString];
    	return null;
    }
    
    /**
    * Remote method to delete an account
    **/
    @RemoteAction
    global static Boolean deleteAccount(Id accountId) {
    	try{
	    	Account accountObj = [SELECT Id, Name FROM Account WHERE Id = :accountId];
	    	delete accountObj;
	    	return true;
    	}
    	catch(Exception e){
    		return false;
    	}
    }
    
    /**
    * Method woth SOQL query to return accounts as per the filter criteria
    **/
    private List<Account> getAccountsSOQL() {
    	if(String.isEmpty(searchString)){
    		return [SELECT Name, PersonEmail__c, Phone, Website FROM Account];
    	}
    	else {
    		searchString = '%' + searchString + '%';
    		return [SELECT 
    		  		  	  Name, 
    				  	  PersonEmail__c, 
    				  	  Phone, 
    				  	  Website 
    				  	  FROM Account 
    				  	  WHERE Name LIKE :searchString];
    	}
    }
}