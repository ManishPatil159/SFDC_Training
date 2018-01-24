global class AP1_closedWonOpportunitySchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
    	List<Account> lstAccount = [SELECT 
    								Id,
    								Name,
    								Contact__r.email,
									(SELECT 
									 	Id, 
									 	Name, 
									 	Amount 
									 FROM Opportunities 
									 WHERE StageName = 'Closed Won' AND closedate = Today) 
									FROM Account 
									WHERE Id in (SELECT
												 AccountId 
												 FROM Opportunity 
												 WHERE StageName = 'Closed Won'
												  	   AND closedate = Today)];
		list<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		String emailBody='';
		Double totalAmount=0.0;
		for(Account accountObj : lstAccount) {
			if(accountObj.Contact__r.email != '' && accountObj.Contact__r.email != null){
				emailBody = 'Hi, <br /> Following opportunities set as closed won: <br />'
							+ '<table>'
								+ '<tr>'
									+ '<th>Opportunity Name</th>'
									+ '<th>Amount</th>'
								+ '</tr>';
				for(Opportunity opportunityObj : accountObj.Opportunities) {
					emailBody += '<tr>'
								 + '<td>'+ opportunityObj.Name +'</td>'
								 + '<td>'+ opportunityObj.Amount +'</td>'
							   + '</tr>';
					totalAmount += opportunityObj.Amount;
				}
				emailBody += '<tr>'
								+ '<td><b>Total</b></td>'
								+ '<td><b>'+ totalAmount +'</b></td>'
							+ '</tr>'
							+ '</table>';
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				string body = emailBody;
				mail.setSubject('Test Subject');
				//mail.setTargetObjectId(accountObj.Id);
				mail.setToAddresses(new List<String> { accountObj.Contact__r.email }); 
				mail.setSaveAsActivity(false);
				mail.setHtmlBody(body); mails.add(mail);
			}
			
		}
		Messaging.sendEmail(mails);
    }
}