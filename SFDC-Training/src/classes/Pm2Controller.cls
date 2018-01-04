/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Dec-29-2017   Manish Patil  	Programmatic Model - 1 Assignment code 
*/
public with sharing class Pm2Controller {
	public Pm2Controller(){
		arrRemoveOccurrenceString=new List<String>();
	}
    
    public Integer value { get; set; }
    public String strPalindrome { get; set; }
    public String[] arrRemoveOccurrenceString { get; set; } 
    public String strRemoveOccurrence { get; set; }
    public String strReplacement { get; set; }
    /**
    * Method to accept Integer as parameter and determine & print the number is prime or not prime
    **/
    public PageReference isPrime() {
    	pagereference pageReferenceObj = apexpages.Currentpage();
        //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Total Number of reloads: ' + (myInt++));
        //apexpages.addmessage(msg);
        Boolean isPrime = true;
    	for(Integer i = 2; i < value; i++) {
    		if(math.mod(value,i) == 0) {
    			isPrime = false;
    		}
    	}
    	if(isPrime) {
    		ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,'Number is a prime number'));
    	}
    	else {
    		ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.FATAL,'Number is not a prime number'));
    	}
    	return null;
    }
    
    /**
    * Method to accept string as a parameter and print whether it is palindrome or not
    **/
    public PageReference isPalindrome(){
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	if(strPalindrome.equalsIgnoreCase(strPalindrome.reverse())){
    		ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,'String is palindrome.'));
    	}
    	else {
    		ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.FATAL,'String is not palindrome.'));
    	}
    	return null;
    } 
    
    /**
    * Mehotd to replace occurrence of characters in an array of string. 
    **/
    public PageReference replaceOccurrences(){
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	for(Integer index=0; index < arrRemoveOccurrenceString.size(); index++) {
    		arrRemoveOccurrenceString[index] = arrRemoveOccurrenceString[index].replace('a', strReplacement);
    	}
    	return null;
    }
    
    /**
    * Mehotd to add string in array (arrRemoveOccurrenceString)  
    **/
    public PageReference addInRemoveOccurrenceString(){
    	arrRemoveOccurrenceString.add(strRemoveOccurrence);
    	return null;
    }
}