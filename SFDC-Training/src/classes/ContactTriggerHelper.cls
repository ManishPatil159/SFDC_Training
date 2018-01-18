/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-17-2018   Manish Patil  			Helper class for Contact Trigger
 */
public with sharing class ContactTriggerHelper {
	/**
	* Method to update account on contacts by email's domain
	**/
    public void addAccountToContact(List<Contact> lstContact) {
    	List<String> lstEmail = new List<String>();
    	
    	for(Contact contactObj : lstContact) {
    		if(!String.isEmpty(contactObj.Email)){
    			lstEmail.add('%' + contactObj.Email.split('\\@')[1]);
    		}
    	}
    	
    	List<Account> lstAccount = [SELECT Name, PersonEmail__c 
    								FROM Account 
    								WHERE PersonEmail__c LIKE :lstEmail];
    	
    	for(Contact contactObj : lstContact) {
    		if(!String.isEmpty(contactObj.Email)){
    			for(Account accountObj : lstAccount) {
    				// lstEmail.add('%' + contactObj.Email.split('\\@')[1]);
    				if(accountObj.PersonEmail__c.contains(contactObj.Email.split('\\@')[1]))
    				{
    					contactObj.AccountId = accountObj.Id;
    				}
    			}
    		}	
    	}
    }
}