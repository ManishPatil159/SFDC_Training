public with sharing class InvoiceDocumentExtension {
	public InvoiceDocumentExtension(ApexPages.StandardController controller) {
		invoiceStatement = (Invoice_Statement__c)controller.getRecord();
		lineItemsCount = invoiceStatement.Line_Items__r.size();
		totalAmount = 0.0;
    }
    
    public Invoice_Statement__c invoiceStatement { get; set;}
    public Integer lineItemsCount  { get; set;}
    
    public Decimal totalAmount { get {
    		if(totalAmount == 0.0) {
    			totalAmount = getTotal();
    		}
    		return totalAmount;
    	} set; }
    
    public Decimal getTotal() {
    	Decimal amount = 0;
    	for(Line_Item__c lineItemObj : invoiceStatement.Line_Items__r) {
    		amount += (lineItemObj.Unit_Price__c * lineItemObj.Unit_Sold__c);
    	}
    	return amount;
    }
    
}