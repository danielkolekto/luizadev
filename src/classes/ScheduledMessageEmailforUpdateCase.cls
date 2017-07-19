/*
    @autor Lincoln Soares
    @class Classe de execucao do Job que permite atualização de campo no objeto Case
*/
global class ScheduledMessageEmailforUpdateCase implements Schedulable{
     global void execute(SchedulableContext sc) {
         EmailMessageBO.getInstance().updateFieldInCase();
     }
}