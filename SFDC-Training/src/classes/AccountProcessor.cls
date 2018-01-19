public with sharing class AccountProcessor {
	@future
	public static void countContacts(List<Id> accountIds) {
		Map<Id, Integer> mapContactCount = new Map<Id, Integer>();
		for(Contact contactObj : [SELECT AccountId, Name 
								  FROM Contact 
								  WHERE AccountId 
								  IN :accountIds]) {
			if(mapContactCount.containsKey(contactObj.AccountId)) {
				Integer conatctCount = mapContactCount.get(contactObj.AccountId);
				conatctCount++;
				mapContactCount.put(contactObj.AccountId, conatctCount);
			}
			else {
				mapContactCount.put(contactObj.AccountId, 1);
			}
		}
		
		List<Account> lstAccount = new List<Account>();
		for(Account accountObj : [SELECT Number_of_Contacts__c 
								  FROM Account 
								  WHERE Id IN :accountIds]) {
			accountObj.Number_of_Contacts__c = mapContactCount.get(accountObj.Id);
			lstAccount.add(accountObj);
		}
		update lstAccount;
	}
}