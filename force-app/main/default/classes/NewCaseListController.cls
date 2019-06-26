public class NewCaseListController {
 
    public List<Case> getNewCases() {
    List<Case> results = new List<Case>();
       results=[SELECT ID,CaseNumber,status FROM Case  where status='NEW'];
       return results;
	}
 }