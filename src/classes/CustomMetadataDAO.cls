public without sharing class CustomMetadataDAO {
	
	public static Map<String, Boolean> getTriggerActiveMapByName(){
		List<TriggerActive__mdt> listTriggerActive = [
			SELECT 	DeveloperName, 
					IsActive__c
					
			FROM 	TriggerActive__mdt
		];
		
		Map<String, Boolean> mapTriggerActive = new Map<String, Boolean>();
		
		for(TriggerActive__mdt trgAct : listTriggerActive){
			mapTriggerActive.put(trgAct.DeveloperName, trgAct.IsActive__c);
		}
		
		return mapTriggerActive;
	}
	
	public static Boolean isTriggerActive(String triggerName){
		List<TriggerActive__mdt> listTriggerActive = [
			SELECT DeveloperName, IsActive__c
			FROM TriggerActive__mdt
			WHERE DeveloperName = :triggerName
		];
		
		return !listTriggerActive.isEmpty() ? listTriggerActive[0].IsActive__c : true;
	}
	
	
	public static Map<String, MilestoneManager__mdt> getMilestonesManagerMap(){
        Map<String, MilestoneManager__mdt> milestoneManagerMap = new Map<String, MilestoneManager__mdt>();
        
        for(MilestoneManager__mdt milesMan : CustomMetadataDAO.getAllMilestonesManager()){
            milestoneManagerMap.put((milesMan.Status__c + milesMan.TipoRegistro__c).trim(), milesMan);
        }
        
        return milestoneManagerMap;
	}
	
	public static List<MilestoneManager__mdt> getAllMilestonesManager(){
        return [
            SELECT 	DeveloperName,
		            Milestone__c,
		            Status__c,
		            TipoRegistro__c
		            
            FROM 	MilestoneManager__mdt
        ];
	}
	
}