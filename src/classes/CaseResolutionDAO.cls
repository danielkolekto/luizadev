public class CaseResolutionDAO {
	
	public static Map<Id, List<CaseResolution__c>> getCaseResolutionsMapByCaseId(Set<Id> caseIdSet){
		Map<Id, List<CaseResolution__c>> mapResolutions = new Map<Id, List<CaseResolution__c>>();
		List<CaseResolution__c> caseResolutionList = getCaseResolutionsByCaseId(caseIdSet);
		
		for(Id i : caseIdSet){
			List<CaseResolution__c> caseResList = new List<CaseResolution__c>();
			
			for(CaseResolution__c res : caseResolutionList){
				if(res.Caso__c == i)
					caseResList.add(res);
			}
			
			mapResolutions.put(i, caseResList);
		}
		
		return mapResolutions;
	}
	
	public static List<CaseResolution__c> getCaseResolutionsByCaseId(Set<Id> caseIdSet){
		return [
            SELECT 	Id,
		            Area_solucionadora__c,
		            OwnerId,
		            Status_Resolucao__c,
		            Formulario_Preenchido__c,
		            Data_de_Inicio__c,
		            Caso__c
		            
            FROM 	CaseResolution__c
            WHERE 	Caso__c in :caseIdSet
            AND 	Formulario_Preenchido__c = false
        ];
	}
	
}