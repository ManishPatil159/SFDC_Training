trigger AccountAddressTrigger on Account (before insert) {
		for(Account accountObj : Trigger.New) {
			if(accountObj.Match_Billing_Address__c) {
				accountObj.ShippingPostalCode = accountObj.BillingPostalCode;
				System.debug(accountObj);
			}
		}
}