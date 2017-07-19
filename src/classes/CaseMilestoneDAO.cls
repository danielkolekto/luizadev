public class CaseMilestoneDAO {
	
	public static Map<Id, List<CaseMilestone>> getCaseMilestonesMapByCaseId(Set<Id> caseIdSet){
		Map<Id, List<CaseMilestone>> caseMilestonesMapByCaseId = new Map<Id, List<CaseMilestone>>();
		List<CaseMilestone> listCaseMilestones = getCaseMilestonesByCaseId( caseIdSet );
        
        for(Id i : caseIdSet){
            List<CaseMilestone> caseMiles = new List<CaseMilestone>();
            
            for(CaseMilestone cm : listCaseMilestones){
                if(cm.CaseId == i)
                    caseMiles.add(cm);
            }
            
            caseMilestonesMapByCaseId.put(i, caseMiles);
        }
        
        return caseMilestonesMapByCaseId;
	}
	
	public static List<CaseMilestone> getCaseMilestonesByCaseId(Set<Id> caseIdSet){
		return [
			SELECT 	CompletionDate,
					CaseId,
					MilestoneType.Name,
					StartDate,
					TargetDate,
					IsViolated
			
            FROM 	CaseMilestone
            WHERE 	CaseId in :caseIdSet
            AND 	CompletionDate = null
		];
	}
	
}