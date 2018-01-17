/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  			Helper class for PM3TriggerCase
 */
public with sharing class PM3TriggerCaseHelper {
	/**
	* Method to update case fields from Account and contact.
	**/
    public void updateCases(List<Case> lstNewCases) {
    	String searchString = '';
    	for(Integer i = 0; i < lstNewCases.size(); i++) {
    		searchString = searchString + lstNewCases[i].SuppliedEmail; 
    		if(i != lstNewCases.size() - 1) { 
				searchString = searchString +' OR ';
			}
    	}
    	
    	List<List<sObject>> lstAccountContactSosl = [FIND :searchString 
											    	 IN EMAIL FIELDS 
											    	 RETURNING 
											    	 	 Account(Id, Name, PersonEmail__c), 
											    		 Contact(Id, Name, Email, Phone, Fax, MobilePhone)];
		List<Account> lstFetchedAccounts = (List<Account>)lstAccountContactSosl[0];
		Map<String,Account> mapAccounts = new Map<String,Account>(); 
		for(Account accountObj : (List<Account>)lstAccountContactSosl[0]) {
			mapAccounts.put(accountObj.PersonEmail__c, accountObj);
		}
		
		List<Contact> lstFetchedContacts = (List<Contact>)lstAccountContactSosl[1];
		Map<String, Contact> mapContacts = new Map<String, Contact>();
		for(Contact contactObj : (List<Contact>)lstAccountContactSosl[1]) {
			mapContacts.put(contactObj.Email, contactObj);
		}
		
		for(Case caseObj : lstNewCases) {
			if(mapAccounts.get(caseObj.SuppliedEmail) != null) {
				caseObj.AccountId = mapAccounts.get(caseObj.SuppliedEmail).Id;
			}
			if(mapContacts.get(caseObj.SuppliedEmail) != null) {
				caseObj.ContactId = mapContacts.get(caseObj.SuppliedEmail).Id;
			}
		}
		
    }
}