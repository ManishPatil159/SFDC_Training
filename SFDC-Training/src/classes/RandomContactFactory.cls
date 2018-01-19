public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer count, String LastName) {
    	List<Contact> lstContact = new List<Contact>();
    	for(Integer i = 0; i<count; i++) {
    		lstContact.add(new Contact(FirstName = 'Test ' + i ,LastName = LastName));
    	}
    	return lstContact;
    }
}