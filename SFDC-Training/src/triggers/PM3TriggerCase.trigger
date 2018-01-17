/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Trigger on Case to update case records based on 
 *												emailId. i.e. get data from Account and Contact 
 *												based on emailId provided in web to case form
 */
trigger PM3TriggerCase on Case (before insert) {
   PM3TriggerCaseHelper helperObj = new PM3TriggerCaseHelper();
   helperObj.updateCases(Trigger.New);
}