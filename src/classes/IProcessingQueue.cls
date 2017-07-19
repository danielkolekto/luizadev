/**
	*@author Diego Moreira
	*@interface interface responsavel pelo processamento da fila
*/
public interface IProcessingQueue {
	void executeQueue( String queueId, String eventName, String payload );
}