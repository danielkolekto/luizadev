@isTest(seealldata=true)
public with sharing class clsTestMetodosUteis {

	static testMethod void testaMetodos()
	{
		clsMetodosUteis metUteis = new clsMetodosUteis();
        metUteis.RetornaEstado('TO');
        String cpf = metUteis.formataCPFCNPJ('14725836900');
        String cnpj = metUteis.formataCPFCNPJ('14251436000111');
        metUteis.ValidarEmail('filipe.marino.teste.com.br');
        metUteis.ValidarEmail('filipe.marino@teste.com.br');
        metUteis.ajustaTelefone('01121414005');
        metUteis.ajustaTelefone('1121414005');
        metUteis.ajustaTelefone('121414005');
        metUteis.ajustaTelefone('21414005');
        metUteis.ajustaTelefone('1414005');
        metUteis.validaCpfCnpj('678.463.461-64');
        metUteis.validaCpfCnpj('678.463.666-64');
        metUteis.validaCpfCnpj('86.728.632/0001-91');
        metUteis.validaCpfCnpj('86.728.999/0001-91');
        metUteis.formataCPFCNPJ('86.728.999/0001-91');
        String dt=clsMetodosUteis.RetornaDiaUtil(1);
        String acento = metUteis.RemoverAcentos('País');
        String dtUtil = clsMetodosUteis.RetornaDiaUtil(2,System.now());
        List<CaseResolution__c> CR = [Select id,area_solucionadora__c,ownerid,Status_Resolucao__c,Formulario_Preenchido__c,data_de_inicio__c from CaseResolution__c where Formulario_Preenchido__c=false and Caso__c != null limit 2];
        clsMetodosUteis.AtualizaProprietariosCaseResolution(CR,'005j000000C0QIy',String.valueof(cr[0].ownerid),'Em tratativa');
        List<Task> objTarefa = [Select id,area_solucionadora__c,ownerid,status,Tarefa_Respondida__c,data_de_inicio__c,Subject from Task where Tarefa_Respondida__c=false and subject like '%Contatar%' limit 2];
        clsMetodosUteis.AtualizaProprietariosTask(objTarefa, '005j000000C0QIy', String.valueof(cr[0].ownerid), 'Em tratativa');
	} 
}