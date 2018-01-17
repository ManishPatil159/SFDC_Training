/*
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Jan-15-2018   Manish Patil  		Trigger on Account to create a new Task when an 
 * 												account is created 
 * 												Test Class: PM3TriggerAccount
 */
trigger PM3TriggerAccount on Account (after insert) {
    (new PM3TriggerAccountHelper()).createTaskForAccount(Trigger.New);
}