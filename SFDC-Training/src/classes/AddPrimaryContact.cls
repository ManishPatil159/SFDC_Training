public with sharing class AddPrimaryContact implements Queueable {
    
    private Contact contactObj;
    private String stateValue;
    
    public AddPrimaryContact(Contact contactInitObj, String stateAbbr) {
    	contactObj = contactInitObj;
    	stateValue = stateAbbr;
    }
    
    public void execute(QueueableContext context) {
    	
    	List<Account> lstAccount = [SELECT Name FROM Account WHERE BillingState = :stateValue LIMIT 200];
    	List<Contact> lstContact = new List<Contact>();
    	for(Account accountObj : lstAccount) {
    		Contact contactAccountObj = contactObj.clone(false, false, false, false);
    		contactAccountObj.AccountId = accountObj.Id;
    		lstContact.add(contactAccountObj);
    	}
    	insert lstContact;
    }
}