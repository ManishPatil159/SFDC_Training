/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  	Class to check if PM3TriggerLeads is not 
 * 											called recursively.
 *											Refered from:
 *											https://help.salesforce.com/articleView?id=000133752&language=en_US&type=1
 */
public with sharing class CheckTriggerRecursion {
	private static boolean run = true;
    
    /**
    * Method to make sure that trigger is executed once (i.e. does not go in recursion)
    **/
    public static boolean runOnce(){
    	if(run){
     		run = false;
     		return true;
    	} 
    	else{
	        return run;
	    }
    }
}