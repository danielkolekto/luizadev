/**
    *@author Diego Moreira
    *@class Classe de negocio para o objeto queue
*/
public class QueueBO {
    /*
        Singleton
    */
    private static final QueueBO instance = new QueueBO();    
    private QueueBO(){}
    
    public static QueueBO getInstance() {
        return instance;
    }

    /**
        *@enum para representação dos status da fila
    */
    public enum QueueStatus {
        CREATED,
        SUCCESS,
        ERROR
    }
    
    /* 
        Mapa de eventos e classe de execução
    */
    private static map<String, IProcessingQueue> mapToExecute;     
    static {
        mapToExecute = new map<String, IProcessingQueue>();
        mapToExecute.put( QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name(),     new MktPlace_CaseIntegrationBO() );
        mapToExecute.put( QueueEventNames.MKTPLACE_CASE_COMMENT_TO_SALESFORCE.name(),       new MktPlace_CaseIntegrationBO() );
        mapToExecute.put( QueueEventNames.MKTPLACE_CASE_COMMENT_SALESFORCE_TO_GIBA.name(),  new MktPlace_CaseOutboundIntegrationBO() );
        mapToExecute.put( QueueEventNames.MKTPLACE_CASE_CLOSE_GIBA_TO_SALESFORCE.name(),    new MktPlace_CaseIntegrationBO() );
        mapToExecute.put( QueueEventNames.MKTPLACE_CASE_CLOSE_SALESFORCE_TO_GIBA.name(),    new MktPlace_CaseOutboundIntegrationBO() );
    }
 
    /**
        *Cria fila de processamento
        *@param eventName string com o nome do evento a ser processado
        *@param payload string com os JSON do objeto a ser processado
        *@param ignoredByTrigger boolean para avisar se a fila vai ser executada pela trigger ou outro processo
    */ 
    public Queue__c createQueue( String eventName, String payLoad, Boolean ignoredByTrigger ) {
        return new Queue__c(
            EventName__c = eventName,
            Payload__c = payLoad,
            Status__c = QueueStatus.CREATED.name(),
            IgnoredByTrigger__c = ignoredByTrigger
        );
    }
    
    /**
        *Atualiza fila de processamento
        *@param queueId string com o id da fila para atualização
        *@param dmlExceptionStackTrace string com possivel erro de processamento da fila
    */
    public void updateQueue( String queueId, String dmlExceptionStackTrace ) {
        Queue__c queue                  = new Queue__c();
        queue.Id                        = queueId;
        queue.Status__c                 = dmlExceptionStackTrace.equals('') ? QueueStatus.SUCCESS.name() : QueueStatus.ERROR.name();
        queue.ExceptionStackTrace__c    = dmlExceptionStackTrace;       
        
        QueueDAO.getInstance().updateData( queue );
    }
    
    /*
        Repocessa os dados da fila
    */ 
    public void reprocessQueue() {
        List<Queue__c> queuesResult = QueueDAO.getInstance().getQueueByStatus( new List<String>{ QueueStatus.CREATED.name() } );
        executeProcessingQueue( queuesResult );
    }    
    
    /**
        *Executa o processamento da fila
        *@param queueToProcessing filas para processamento
    */
    public void executeProcessingQueue( List<Queue__c> queueToProcessing ) {
        if( Test.isRunningTest() ) return;
        
        for( Queue__c queue : queueToProcessing ) {
            if( queue.IgnoredByTrigger__c ) continue;
            mapToExecute.get( queue.EventName__c ).executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );  
        }
    }
}