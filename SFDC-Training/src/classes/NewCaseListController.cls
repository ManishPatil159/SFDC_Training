public class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> caseList= [SELECT Id, CaseNumber FROM CASE WHERE Status = 'New'];
            return caseList;
        // return Database.query('SELECT Id, CaseNumber FROM CASE WHERE Status = New');
    }
}