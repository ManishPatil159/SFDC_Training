/**
*  ================================================================================================
*   Version    Date          Author                        Comment
*  ================================================================================================
*   v1.0     Dec-29-2017   Manish Patil  	Programmatic Model - 1 Assignment code 
*/
public with sharing class Pm1Controller {
	
	//called before constructor
    public static Integer staticNumber {
    	get {
    		if(staticNumber == null) {
    			staticNumber = 2;
    		}
    		return staticNumber;
    	} 
    	set;
    }
	
	public Pm1Controller(){
		arrRemoveOccurrenceString = new List<String>();
		setOfUniqueNumbers = new Set<Integer>();
		arrOfNumbersInput = new List<Integer>();
		numberForClasses = staticNumber;
	}
        
    public Integer value { get; set; }
    public String strPalindrome { get; set; }
    public String[] arrRemoveOccurrenceString { get; set; } 
    public String strRemoveOccurrence { get; set; }
    public String strReplacement { get; set; }
    public String strFindLength { get; set; }
    public Integer lengthOfString { get; set; }
    public Integer[] arrOfNumbersInput { get; set; }
    public Set<Integer> setOfUniqueNumbers { get; set; }
    public Integer numberInputForArray { get; set; }
    public Integer numberForClasses  { get; set; }
    /**
    * Method to accept Integer as parameter and determine & print the number is prime or not prime
    **/
    public PageReference isPrime() {
    	pagereference pageReferenceObj = apexpages.Currentpage();
        Boolean isPrime = true;
    	for(Integer i = 2; i < value; i++) {
    		if(math.mod(value,i) == 0) {
    			isPrime = false;
    		}
    	}
    	if(isPrime) {
    		ApexPages.AddMessage(
    			new Apexpages.Message(ApexPages.Severity.CONFIRM, System.Label.Is_Prime_Number)
    		);
    	}
    	else {
    		ApexPages.AddMessage(
    			new Apexpages.Message(ApexPages.Severity.FATAL, System.Label.Is_Not_Prime_Number)
    		);
    	}
    	return null;
    }
    
    /**
    * Method to accept string as a parameter and print whether it is palindrome or not
    **/
    public PageReference isPalindrome(){
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	if(strPalindrome.equalsIgnoreCase(strPalindrome.reverse())){
    		ApexPages.AddMessage(
    			new Apexpages.Message(ApexPages.Severity.CONFIRM, System.Label.IsPallindromeString)
    		);
    	}
    	else {
    		ApexPages.AddMessage(
    			new Apexpages.Message(ApexPages.Severity.FATAL, System.Label.IsNotPallindrome)
    		);
    	}
    	return null;
    } 
    
    /**
    * Mehotd to replace occurrence of characters in an array of string. 
    **/
    public PageReference replaceOccurrences(){
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	for(Integer i = 0; i < arrRemoveOccurrenceString.size(); i++) {
    		arrRemoveOccurrenceString[i] = arrRemoveOccurrenceString[i].replace('a', strReplacement);
    	}
    	return null;
    }
    
    /**
    * Mehotd to add string in array (arrRemoveOccurrenceString)  
    **/
    public PageReference addInRemoveOccurrenceString(){
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	arrRemoveOccurrenceString.add(strRemoveOccurrence);
    	ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, System.Label.StringAdded));
    	return null;
    }
    
    /**
    * Mehothod to count the length of string
    **/
    public PageReference getStringLength(){
    	Integer[] charArrayOfString = strFindLength.getChars();
    	lengthOfString = charArrayOfString.size();
    	return null;
    }
    
    /**
    * Method to find unique numbers in array
    **/
    public PageReference getUniqueNumbers(){
    	setOfUniqueNumbers.addAll(arrOfNumbersInput);
    	return null;
    }
    
    /**
    * Method to insert integer in array
    **/
    public PageReference addInArrOfNumbersInput() {
    	pagereference pageReferenceObj = apexpages.Currentpage();
    	arrOfNumbersInput.add(numberInputForArray);
    	ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, System.Label.NumberAdded));
    	return null;
    }
    
    /**
    * Method to get number from derived class
    **/
    public PageReference initializeDerived() {
    	Pm1_DerivedClass derivedObj = new Pm1_DerivedClass(numberForClasses);
    	ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,
    		'Number is: ' + derivedObj.getNumber()));
    	ApexPages.AddMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,
    		'Static Number is: ' + derivedObj.squared()));
    	return null;
    }
}