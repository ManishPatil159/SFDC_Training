public class ContactSearch {
    public static List<Contact> searchForContacts(String name, String postalCode){
        // String query = 'SELECT Id, Name from Contact where LastName = ' + name + ' AND MailingPostalCode = '+ postalCode;
        List<Contact> lstContacts = [SELECT Id, Name from Contact where LastName = :name AND MailingPostalCode = :postalCode];
        //List<Contact> lstContacts = Database.query(query);
        return lstContacts;
    }
}