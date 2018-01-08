public class AccountHandler {
    public static Account insertNewAccount(String accountName){
        try{
        	Account accountObj=new Account(Name = accountName);
        	insert accountObj;
        	return accountObj;
        }
        catch(DmlException ex){
            return null;
        }
    }
}