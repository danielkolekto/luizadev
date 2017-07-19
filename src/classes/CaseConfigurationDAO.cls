public class CaseConfigurationDAO {
	
	private static Map<String, Case_Configuration__c> caseConfigurationMapByLevel;
	
	
	public static Case_Configuration__c getCaseConfigurationByLevel(String level_1, String level_2){
		if(caseConfigurationMapByLevel == null){
			caseConfigurationMapByLevel = new Map<String, Case_Configuration__c>();
            for(Case_Configuration__c cc : getCaseConfigurationListByLevel(level_1, level_2)) {
				caseConfigurationMapByLevel.put(cc.Level_1__c.trim() + cc.Level_2__c.trim(), cc);
			}
		}
		
		String levelTrim = level_1.trim() + level_2.trim();
		return caseConfigurationMapByLevel.containsKey(levelTrim) ? caseConfigurationMapByLevel.get(levelTrim) : null;
	}
	
	public static List<Case_Configuration__c> getCaseConfigurationListByLevel(String level_1, String level_2){
        return [
            SELECT 	Register_Type__c, 
            		Workflow__c,
            		Level_1__c,
            		Level_2__c
            		
            FROM 	Case_Configuration__c
            WHERE 	Level_1__c = : level_1.trim()
            AND 	Level_2__c = : level_2.trim()
        ];
	}
	
}