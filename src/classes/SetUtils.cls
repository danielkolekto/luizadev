public class SetUtils {
	
	// CASE COMMENT
    
    public static Set<Id> getCaseCommentCaseIdSet(List<CaseComment__c> caseCommentList){
        Set<Id> caseIdSet = new Set<Id>();
        
        for(CaseComment__c cc : caseCommentList){
            if(cc.Caso__c != null)
                caseIdSet.add(cc.Caso__c);
        }
        
        return caseIdSet;
    }
	
}