@isTest(SeeAllData=true)
public class clsTestTrgTask 
{
    static testMethod void testaTrigger2()
    {
        RecordType recTypeCase = [SELECT Id FROM RecordType WHERE Name = 'Cadastro e seu espaço'];
        
        Case csTest = new Case();
        csTest.RecordTypeId = recTypeCase.Id;
        csTest.PhoneNumber_1__c = '1126251414';
        csTest.PhoneNumber_2__c = '11986521400';
        csTest.CustomerEmail__c = 'filipe.marino@makeitsimple.com.br';
        csTest.ProblemTypeRegistration__c = 'Cliente não consegue modificar o e-mail';
        csTest.Level_1__c = 'Cadastro e seu espaço';
        csTest.Level_2__c = 'Produto diferente do que constava no site';
        csTest.Description = 'Teste';
        csTest.NewEmailAlteration__c='rafael.souza@teste.com.br';
        
        insert csTest;
        
        Set<String> tiposReg = new Set<String>();
        
        List<RecordType> recType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Task'];
        
        //Cria as tarefas
        Task objTaskContCliente                 = new Task();
        Task objTaskContClienteValidarSolucao   = new Task();
        Task objTaskContClienteRefat            = new Task();
        Task objTaskverDadosDivergenteRotT      = new Task();
        Task objTaskverDadosDivergenteECOM      = new Task();
		Task objTaskEmail                       = new Task();
        Task objTaskConfDadosCliente            = new Task();
        Task objContatarClienteAnaliseProduto   = new Task();
        for(RecordType rec : recType)
        {
            if (rec.Name == 'Contatar Cliente')
            {
                //idContatarCliente = rec.Id;
                objTaskContCliente.Subject='Contatar Cliente';
                objTaskContCliente.WhatId=csTest.id;
                objTaskContCliente.RecordTypeId= rec.Id;
                insert objTaskContCliente;
            }
            
            if(rec.name=='Confirmar Dados Cliente'){
                 //idContatarCliente = rec.Id;
                objTaskConfDadosCliente.Subject='Confirmar Dados Cliente';
                objTaskConfDadosCliente.WhatId=csTest.id;
                objTaskConfDadosCliente.RecordTypeId= rec.Id;
                
                insert objTaskConfDadosCliente;
            }
            if(rec.name=='Contatar Cliente - Análise de Produto'){
                
                objContatarClienteAnaliseProduto.Subject='Contatar Cliente - Análise de Produto';
                objContatarClienteAnaliseProduto.WhatId=csTest.id;
                objContatarClienteAnaliseProduto.RecordTypeId= rec.Id;
                objContatarClienteAnaliseProduto.Conseguiu_contato_com_o_cliente__c='Sim';
                objContatarClienteAnaliseProduto.Cliente_aceita_solucao__c='Não';
                insert objContatarClienteAnaliseProduto;
                
            }
            if(rec.name=='Enviar E-mail para Cliente'){
               //idContatarCliente = rec.Id;
                objTaskEmail.Subject='Enviar E-mail para Cliente';
                objTaskEmail.WhatId=csTest.id;
                objTaskEmail.RecordTypeId= rec.Id;
                insert objtaskEmail; 
            }
            if (rec.Name == 'Contatar Cliente - Refat')
            {
                //idContatarClienteRefat = rec.Id;
                
                objTaskContClienteRefat.Subject='Contatar Cliente - Refat';
                objTaskContClienteRefat.WhatId=csTest.id;
                objTaskContClienteRefat.RecordTypeId=rec.Id;
                objTaskContClienteRefat.Conseguiu_contato_com_o_cliente__c='Não';
                insert objTaskContClienteRefat;
            }      

            if (rec.Name == 'Verificar Dados Divergentes Rot T')
            {
                //idverDadosDivergentesRotT = rec.Id;
                objTaskverDadosDivergenteRotT.Subject='Verificar Dados Divergentes Rot T';
                objTaskverDadosDivergenteRotT.WhatId=csTest.id;
                objTaskverDadosDivergenteRotT.RecordTypeId= rec.Id;
                insert objTaskverDadosDivergenteRotT;
            }      

            if (rec.Name == 'Verificar Dados Divergentes Ecom')
            {
                //idVerDadosDivergenteECOM = rec.Id;
                
                objTaskverDadosDivergenteECOM.Subject='Verificar Dados Divergentes Ecom';
                objTaskverDadosDivergenteECOM.WhatId=csTest.id;
                objTaskverDadosDivergenteECOM.RecordTypeId=rec.Id;
                insert objTaskverDadosDivergenteECOM;
            }     
            
            
            if (rec.Name == 'Contatar Cliente - Validar solução')
            {
                //idContClienteValidSolucao = rec.Id;
                
                objTaskContClienteValidarSolucao.Subject='Contatar Cliente - Validar solução';
                objTaskContClienteValidarSolucao.WhatId=csTest.id;
                objTaskContClienteValidarSolucao.RecordTypeId=rec.Id;
                insert objTaskContClienteValidarSolucao;
            }  
            
        }
        
        
         //try{
        
        objtaskEmail.Status='Concluído';
       	objTaskEmail.Tarefa_Respondida__c=false;
        update objtaskEmail;
        objTaskEmail.Status='Aberto';
       	objTaskEmail.Tarefa_Respondida__c=false;
        update objtaskEmail;
        
        objTaskConfDadosCliente.Conseguiu_contato_com_o_cliente__c='Sim';
        objTaskConfDadosCliente.Tarefa_Respondida__c=false;
        //update objTaskConfDadosCliente;
        
        //objTaskContCliente.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContCliente.Tarefa_Respondida__c=false;
        //objTaskContCliente.Status='Concluído';
        //update objTaskContCliente;
        
       objTaskContClienteValidarSolucao.Conseguiu_contato_com_o_cliente__c='Não';
       objTaskContClienteValidarSolucao.Tarefa_Respondida__c=false;
       objTaskContClienteValidarSolucao.Status='Concluído';
       update objTaskContClienteValidarSolucao;

        //objContatarClienteAnaliseProduto.Status='Concluído';
        //objContatarClienteAnaliseProduto.Tarefa_Respondida__c=false;
        //update objContatarClienteAnaliseProduto;

        //objTaskContClienteRefat.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteRefat.Tarefa_Respondida__c=false;
        //objtaskContClienteRefat.Status='Concluído';
        //update objTaskContClienteRefat;
        
        //objTaskverDadosDivergenteRotT.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskverDadosDivergenteRotT.Tarefa_Respondida__c=false;
        //objTaskverDadosDivergenteRotT.Status='Concluído';
        //update objTaskverDadosDivergenteRotT;
        
             
        //objContatarClienteAnaliseProduto.Status='Concluído';
        //objContatarClienteAnaliseProduto.Conseguiu_contato_com_o_cliente__c='Não';
        //objContatarClienteAnaliseProduto.Cliente_aceita_solucao__c='Não';
        //objContatarClienteAnaliseProduto.Tarefa_Respondida__c=false;
        //update objContatarClienteAnaliseProduto;	

        //}
        //catch (Exception ex){}
        try{
			objContatarClienteAnaliseProduto.Conseguiu_contato_com_o_cliente__c='Sim';
        	//objTaskverDadosDivergenteRotT.Tarefa_Respondida__c=false;
        	objContatarClienteAnaliseProduto.Status='Concluído';
        	update objContatarClienteAnaliseProduto;            
        }
        catch(Exception ex){
            
        }
        
    }
    static testMethod void testaTrigger()
    { 
        RecordType recTypeCase = [SELECT Id FROM RecordType WHERE Name = 'Cadastro e seu espaço'];
        
        Case csTest = new Case();
        csTest.RecordTypeId = recTypeCase.Id;
        csTest.PhoneNumber_1__c = '1126251414';
        csTest.PhoneNumber_2__c = '11986521400';
        csTest.CustomerEmail__c = 'filipe.marino@makeitsimple.com.br';
        csTest.ProblemTypeRegistration__c = 'Cliente não consegue modificar o e-mail';
        csTest.Level_1__c = 'Cadastro e seu espaço';
        csTest.Level_2__c = 'Produto diferente do que constava no site';
        csTest.Description = 'Teste';
        csTest.NewEmailAlteration__c='rafael.souza@teste.com.br';
        
        insert csTest;
        
        Set<String> tiposReg = new Set<String>();
        
        List<RecordType> recType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Task'];
        
        //Cria as tarefas
        Task objTaskPosClienteProdutoSimilar    = new Task();
        Task objTaskValidSolucao                = new Task();
        Task objTaskContClienteCancelamento     = new Task();
        Task objTaskContClienteTroca            = new Task();
        Task objTaskContClienteAcao             = new Task();
        
        for(RecordType rec : recType)
        {
              
            
            if (rec.Name == 'Posicionar Cliente Produto Similar')
            {
                //idPosClienteProdutoSimilar = rec.Id;
                
                objTaskPosClienteProdutoSimilar.Subject='Posicionar Cliente Produto Similar';
                objTaskPosClienteProdutoSimilar.WhatId=csTest.id;
                objTaskPosClienteProdutoSimilar.RecordTypeId=rec.Id;
                insert objTaskPosClienteProdutoSimilar;
            }  
            
            if (rec.Name == 'Contatar Cliente - Validar solução')
            {
                //idContClienteValidSolucao = rec.Id;
                
                objTaskValidSolucao.Subject='Contatar Cliente - Validar solução';
                objTaskValidSolucao.WhatId=csTest.id;
                objTaskValidSolucao.RecordTypeId=rec.Id;
                insert objTaskValidSolucao;
            }  
            
            if (rec.Name == 'Contatar Cliente - Cancelamento')
            {
                //idContCliCancelamento = rec.Id;
                
                objTaskContClienteCancelamento.Subject='Contatar Cliente - Cancelamento';
                objTaskContClienteCancelamento.WhatId=csTest.id;
                objTaskContClienteCancelamento.RecordTypeId=rec.Id;
                insert objTaskContClienteCancelamento;
            }  
            
            if (rec.Name == 'Contatar Cliente - Troca')
            {
                //idContCliTroca = rec.Id;
                
                objTaskContClienteTroca.Subject='Contatar Cliente - Troca';
                objTaskContClienteTroca.WhatId=csTest.id;
                objTaskContClienteTroca.RecordTypeId=rec.Id;
                insert objTaskContClienteTroca;
            } 
            
            if (rec.Name == 'Contatar Cliente - Ação')
            {
                //idContCliAcao = rec.Id;
                
                objTaskContClienteAcao.Subject='Contatar Cliente - Ação';
                objTaskContClienteAcao.WhatId=csTest.id;
                objTaskContClienteAcao.RecordTypeId=rec.Id;
                insert objTaskContClienteAcao;
            } 
            
        }
        //try{
       
        
        //objTaskPosClienteProdutoSimilar.Cliente_aceitou_sug_de_produto_similar__c='Sim';
        //objTaskPosClienteProdutoSimilar.Tarefa_Respondida__c=false;
        //objTaskPosClienteProdutoSimilar.Status='Concluído';
        //update objTaskPosClienteProdutoSimilar;
        
        //objTaskPosClienteProdutoSimilar.Cliente_aceitou_sug_de_produto_similar__c='Escolheu outro produto similar';
        //objTaskPosClienteProdutoSimilar.Tarefa_Respondida__c=false;
        //objTaskPosClienteProdutoSimilar.Status='Concluído';
        //update objTaskPosClienteProdutoSimilar;
        
        objTaskValidSolucao.Cliente_aceita_solucao__c='Não';
        objTaskValidSolucao.Status='Concluído';
        objTaskValidSolucao.Tarefa_Respondida__c=false;
        update objTaskPosClienteProdutoSimilar;
        
        //objTaskValidSolucao.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskValidSolucao.Cliente_aceita_solucao__c='Sim';
        //objTaskValidSolucao.Status='Concluído';
        //objTaskValidSolucao.Tarefa_Respondida__c=false;
        //update objTaskPosClienteProdutoSimilar;
        
        //objTaskValidSolucao.Conseguiu_contato_com_o_cliente__c='Não';
        //objTaskValidSolucao.Cliente_aceita_solucao__c='';
        //objTaskValidSolucao.Status='Concluído';
        //objTaskValidSolucao.Tarefa_Respondida__c=false;
        //update objTaskPosClienteProdutoSimilar;
        
        objTaskContClienteCancelamento.Conseguiu_contato_com_o_cliente__c='Não';
        objTaskContClienteCancelamento.Tarefa_Respondida__c=false;
        objTaskContClienteCancelamento.Status='Concluído';
        update objTaskContClienteCancelamento;
        
        objTaskContClienteCancelamento.Conseguiu_contato_com_o_cliente__c='Sim';
        objTaskContClienteCancelamento.NecessarioRetornarParaProcessamento__c='Não';
        objTaskContClienteCancelamento.Tarefa_Respondida__c=false;
        update objTaskContClienteCancelamento;
        
        objTaskContClienteTroca.Conseguiu_contato_com_o_cliente__c='Sim';
        objTaskContClienteTroca.Acao__c='Posicionamento final';
        objTaskContClienteTroca.Tarefa_Respondida__c=false;
        objTaskContClienteTroca.Status='Concluído';
        update objTaskContClienteTroca;
        
        objTaskContClienteTroca.Conseguiu_contato_com_o_cliente__c='Sim';
        objTaskContClienteTroca.Acao__c='Enviar para comercial validar similar escolhido pelo cliente';
        objTaskContClienteTroca.Tarefa_Respondida__c=false;
        update objTaskContClienteTroca;
        
        //objTaskContClienteTroca.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteTroca.Acao__c='Enviar para processamento gerar a troca';
        //objTaskContClienteTroca.Tarefa_Respondida__c=false;
        //update objTaskContClienteTroca;
        
        //objTaskContClienteTroca.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteTroca.Acao__c='Cliente decidiu cancelar';
        //objTaskContClienteTroca.Tarefa_Respondida__c=false;
        //update objTaskContClienteTroca;
        
        //objTaskContClienteAcao.Conseguiu_contato_com_o_cliente__c='Não';
        //objTaskContClienteAcao.Tarefa_Respondida__c=false;
        //objTaskContClienteAcao.Status='Concluído';
        //update objTaskContClienteAcao;
        
        //objTaskContClienteAcao.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteAcao.Acao__c='Posicionamento final | Fechar fluxo';
        //objTaskContClienteAcao.Tarefa_Respondida__c=false;
        //update objTaskContClienteAcao;
        
        //objTaskContClienteAcao.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteAcao.Acao__c='Cliente decidiu cancelar';
        //objTaskContClienteAcao.Tarefa_Respondida__c=false;
        //update objTaskContClienteAcao;
        
        //objTaskContClienteAcao.Conseguiu_contato_com_o_cliente__c='Sim';
        //objTaskContClienteAcao.Acao__c='Enviar para processamento gerar troca';
        //objTaskContClienteAcao.Tarefa_Respondida__c=false;
        //update objTaskContClienteAcao;
        //}
        //catch (Exception ex){}
    }
}