public class ActivitiyDAO {
	
	public static Map<Id, List<Task>> getTaskMapByWhatId(Set<Id> sObjIdSet){
		Map<Id, List<Task>> mapTasks = new Map<Id, List<Task>>();
		List<Task> taskList = getTasksByWhatId(sObjIdSet);
		
		for(Id i : sObjIdSet){
			List<Task> lst = new List<Task>();
			
			for(Task tsk : taskList){
				if(tsk.WhatId == i)
					lst.add(tsk);
			}
			
			mapTasks.put(i, lst);
		}
		
		return mapTasks;
	}
	
	public static List<Task> getTasksByWhatId(Set<Id> sObjIdSet){
        return [
            SELECT 	Id, 
		            Area_solucionadora__c, 
		            OwnerId, 
		            Status, 
		            Tarefa_Respondida__c, 
		            Data_de_Inicio__c, 
		            Subject,
		            WhatId
		            
            FROM 	Task
            WHERE 	WhatId in :sObjIdSet
            AND 	Tarefa_Respondida__c = false
        ];
	}
	
}