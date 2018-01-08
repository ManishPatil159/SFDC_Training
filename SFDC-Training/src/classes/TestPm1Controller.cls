/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-08-2018   Manish Patil  	Test class for Pm1Controller 
 * 											(Programatic model 1 assignment)
 */
@isTest
private class TestPm1Controller {

    static testMethod void TestPm1Controller() {
       
    }

	@TestSetup
	static void initializeTest() {
	
	}
	
	@isTest
	private static void TestIsPrimeFunctionality() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Boolean isPrimeMessage = false; 
		Test.startTest();
		pm1ControllerObj.value = 2;
		pm1ControllerObj.isPrime();
		Test.stopTest();
		
		List<ApexPages.Message> lstApexMessage = ApexPages.getMessages();
				
		system.debug(lstApexMessage);
		for(apexpages.Message messageObj : lstApexMessage)
        {
        	if(ApexPages.Severity.CONFIRM == messageObj.getSeverity() 
        		&& System.Label.Is_Prime_Number == messageObj.getSummary()) {
        		isPrimeMessage = true; 
        	}
        }
        System.assert(isPrimeMessage, 'Message not present');
		
		
	}
	
	@isTest
	private static void TestIsNotPrimeFunctionality() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Boolean isNotPrimeMessage = false;
		Test.startTest();
		pm1ControllerObj.value = 4;
		pm1ControllerObj.isPrime();
		Test.stopTest();
		
		List<ApexPages.Message> lstApexMessage = ApexPages.getMessages();
				
		for(apexpages.Message messageObj : lstApexMessage)
        {
        	if(ApexPages.Severity.FATAL == messageObj.getSeverity() 
        		&& System.Label.Is_Not_Prime_Number == messageObj.getSummary()) {
        		isNotPrimeMessage = true; 
        	}
        }
        System.assert(isNotPrimeMessage, 'Message not present');
	}
	
	@isTest
	private static void TestIsPalindrome() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Boolean isPalindromeMessage = false;
		
		Test.startTest();
		pm1ControllerObj.strPalindrome='123454321';
		pm1ControllerObj.isPalindrome();
		Test.stopTest();
		
		List<ApexPages.Message> lstApexMessage = ApexPages.getMessages();
		for(apexpages.Message messageObj : lstApexMessage)
        {
        	if(ApexPages.Severity.CONFIRM == messageObj.getSeverity() 
        		&& System.Label.IsPallindromeString == messageObj.getSummary()) {
        		isPalindromeMessage = true;
        	}
        }
        System.assert(isPalindromeMessage, 'Message not present');
	}
	
	@isTest
	private static void TestIsNotPalindrome() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Boolean isPalindromeMessage = false;
		
		Test.startTest();
		pm1ControllerObj.strPalindrome='12345';
		pm1ControllerObj.isPalindrome();
		Test.stopTest();
		
		List<ApexPages.Message> lstApexMessage = ApexPages.getMessages();
		for(apexpages.Message messageObj : lstApexMessage)
        {
        	if(ApexPages.Severity.FATAL == messageObj.getSeverity() 
        		&& System.Label.IsNotPallindrome == messageObj.getSummary()) {
        		isPalindromeMessage = true;
        	}
        }
        System.assert(isPalindromeMessage, 'Message not present');
	}
	
	@isTest
	private static void TestReplaceOccurrences() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		
		Test.startTest();
		pm1ControllerObj.strRemoveOccurrence = 'Bar';
		pm1ControllerObj.addInRemoveOccurrenceString();
		pm1ControllerObj.strRemoveOccurrence = 'Bat';
		pm1ControllerObj.addInRemoveOccurrenceString();
		pm1ControllerObj.strRemoveOccurrence = 'Ultra';
		pm1ControllerObj.addInRemoveOccurrenceString();
		pm1ControllerObj.strRemoveOccurrence = 'Tax';
		pm1ControllerObj.addInRemoveOccurrenceString();
		pm1ControllerObj.strReplacement = 'z';
		pm1ControllerObj.replaceOccurrences();
		Test.stopTest();
		System.debug(pm1ControllerObj.arrRemoveOccurrenceString);
		for(String strItem : pm1ControllerObj.arrRemoveOccurrenceString) {
			System.assert(strItem.indexOf('a') == -1, 
				'Character "a" should not be present in string array');
		}
	}
	
	@isTest
	private static void TestGetStringLength() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		String stringToFindLength= 'Test String';
		
		Test.startTest();
		pm1ControllerObj.strFindLength = stringToFindLength;
		pm1ControllerObj.getStringLength();
		Test.stopTest();
		System.assertEquals(stringToFindLength.length(), pm1ControllerObj.lengthOfString, 'Check if length is same');
	}
	
	@isTest
	private static void TestGetUniqueNumbers() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Set<Integer> uniqueNumbers = new Set<Integer>();
		uniqueNumbers.add(1);
		uniqueNumbers.add(2);
		uniqueNumbers.add(3);
		
		Test.startTest();
		pm1ControllerObj.numberInputForArray = 1;
		pm1ControllerObj.addInArrOfNumbersInput();
		pm1ControllerObj.numberInputForArray = 2;
		pm1ControllerObj.addInArrOfNumbersInput();
		pm1ControllerObj.numberInputForArray = 3;
		pm1ControllerObj.addInArrOfNumbersInput();
		pm1ControllerObj.numberInputForArray = 2;
		pm1ControllerObj.addInArrOfNumbersInput();
		pm1ControllerObj.numberInputForArray = 1;
		pm1ControllerObj.addInArrOfNumbersInput();
		pm1ControllerObj.getUniqueNumbers();
		Test.stopTest();
		
		System.assert(uniqueNumbers.equals(pm1ControllerObj.setOfUniqueNumbers), 
			'Check if items are unique');
	}
	
	@isTest
	private static void TestInitializeDerived() {
		Pm1Controller pm1ControllerObj = new Pm1Controller();
		Test.startTest();
		pm1ControllerObj.initializeDerived();
		Test.stopTest();
				
		Boolean isMsgCorrect = false;
		List<ApexPages.Message> lstApexMessage = ApexPages.getMessages();
		for(apexpages.Message messageObj : lstApexMessage)
        {
        	if((ApexPages.Severity.CONFIRM == messageObj.getSeverity() 
        		&& 'Number is: '+ (pm1ControllerObj.numberForClasses * 2) == messageObj.getSummary())
        		|| (ApexPages.Severity.CONFIRM == messageObj.getSeverity() 
        		&& 'Static Number is: '+ pm1ControllerObj.numberForClasses * pm1ControllerObj.numberForClasses == messageObj.getSummary())) {
        		isMsgCorrect = true;
        	}
        }
        System.assert(isMsgCorrect, 'Message not present');
	}
    
}