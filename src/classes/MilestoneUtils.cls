/**
*	@author Diego Moreira
*	@class Classe de negocio para o objeto de Caso
*/
public class MilestoneUtils {
	/**
	*
	*	@param
	*	@param
	*	@param
	*/
	public static void completeMilestone( String caseId, String milestoneName, DateTime complDate ) {  
	    List<CaseMilestone> cmsToUpdate = [SELECT Id, CompletionDate
								            FROM CaseMilestone 
									        WHERE CaseId = :caseId 
									        AND MilestoneType.Name=:milestoneName 
								            AND CompletionDate = null Limit 1];
		System.debug( '>>> ' + cmsToUpdate );								            
	    if (cmsToUpdate.isEmpty() == false){
	        for (CaseMilestone cm : cmsToUpdate){
	            cm.CompletionDate = complDate;
	        }
	        update cmsToUpdate;
	    }
    }

    /**
	*
	*	@param
	*	@param
	*	@param
	*/
	public static void completeMilestone( String caseId, DateTime complDate ) {  
	    List<CaseMilestone> cmsToUpdate = [SELECT Id, CompletionDate
								            FROM CaseMilestone 
									        WHERE CaseId = :caseId
								            AND CompletionDate = null];							            
	    if (cmsToUpdate.isEmpty() == false){
	        for (CaseMilestone cm : cmsToUpdate){
	            cm.CompletionDate = complDate;
	        }
	        update cmsToUpdate;
	    }
    }
}