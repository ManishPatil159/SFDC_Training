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
 */
@isTest
private class PM3TriggerAccount {

    @isTest
    private static void TestAccountCreation() {
    	
    	List<Account> lstAccount = new List<Account>();
    	for(Integer i = 0; i< 100; i++){
    		lstAccount.add(new Account(Name='Test Method Account ' + i));
    	}
    	Test.startTest();
    	insert lstAccount;
    	Test.stopTest();
    	
    	List<Account> lstSavedAccount = [SELECT Id, Name FROM Account];
    	List<Id> lstAccountId = new List<Id>(); 
    	for(Account accObj : lstAccount) {
    		lstAccountId.add(accObj.Id);
    	}
    	List<Task> lstTask = [SELECT Subject, WhatId FROM Task WHERE AccountId IN :lstAccountId];
    	System.assertEquals(100, lstSavedAccount.size());
    	System.assertEquals(100, lstTask.size());
    	for(Integer i = 0; i< 100; i++) {
    		System.assertEquals('Meeting With Test Method Account ' + i, lstTask[i].Subject);
    	}
    }
}