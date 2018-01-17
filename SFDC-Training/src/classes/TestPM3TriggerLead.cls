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
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  	Test class for Pm3TriggerLead
 * 											(Programatic model 3 assignment)
 */
@isTest
private class TestPM3TriggerLead {

	/**
	* Method to test if lead record is being cloned on creation
	**/
    @isTest
    private static void TestCloneLeadsFunctionality() {
    	List<Lead> lstLead = new List<Lead>();
    	for(Integer i = 0; i<200; i++) {
    		lstLead.add(
    			new Lead(
    				LastName = 'TestLastName' + i, 
    				Company = 'Test Company'+i, 
    				Status = 'Open - Not Contacted' )
    		);
    	}
    	
    	Test.startTest();
    	insert lstLead;
    	Test.stopTest();
    	
    	System.assertEquals(400, [SELECT count() FROM Lead]);
    	System.assertEquals(2, [SELECT count() FROM Lead WHERE LastName = 'TestLastName1']);
    }
}