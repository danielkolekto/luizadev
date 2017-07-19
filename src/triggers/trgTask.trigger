trigger trgTask on Task (before insert,after update,before update) 
{
    /*Group idFilaProcessamento = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE '%Processamento Refaturamento Samsung%'];
    Group idFilaSuporteComercial = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE '%Suporte Comercial Samsung%'];
    Group idFilaAtendSamsungAtivo = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE '%Atendimento Samsung Ativo%'];
    Group idFilaProcessamentoSamsung = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE '%Processamento Samsung%'];
    Group idFilaCD350 = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE '%CD350 Samsung%' limit 1];*/
    Group idFilaProcessamento = new Group();
    Group idFilaSuporteComercial = new Group();
    Group idFilaAtendSamsungAtivo = new Group();
    Group idFilaProcessamentoSamsung = new Group();
    Group idFilaCD350 = new Group();
  for(Group gp : [Select ID,name from Group Where type='Queue' 
                    and name in ('Processamento Refaturamento Samsung','Suporte Comercial Samsung','Atendimento Samsung Ativo',
                                 'Processamento Samsung','CD350 Samsung')]){
         
                                     if(gp.Name=='Processamento Refaturamento Samsung'){
                                         idFilaProcessamento.id=gp.id;
                                         idFilaProcessamento.Name=gp.Name;
                                     }
                                     else if(gp.name=='Suporte Comercial Samsung'){
                                         idFilaSuporteComercial.id=gp.id;
                                         idFilaSuporteComercial.Name=gp.Name;
                                         
                                     }
                                     else if(gp.name=='Atendimento Samsung Ativo'){
                                         idFilaAtendSamsungAtivo.id=gp.id;
                                         idFilaAtendSamsungAtivo.Name=gp.Name;
                                         
                                     }
                                     else if(gp.name=='Processamento Samsung'){
                                         idFilaProcessamentoSamsung.id=gp.id;
                                         idFilaProcessamentoSamsung.Name=gp.Name;
                                         
                                     }
                                     else if(gp.name=='CD350 Samsung'){
                                         idFilaCD350.id=gp.id;
                                         idFilaCD350.Name=gp.Name;
                                         
                                     }
         }    
    
    //Case cs = [SELECT Id, Ownerid, Status, Contact.Email, ContactId,  CustomerEmail__c, RecordType.Name, owner.name FROM Case WHERE Id = :objTarefa.WhatId];    
    List<Task> objTask;
    List<String> IdCaso = new List<String>();
    List<String> IdRecord = new List<String>();
    List<Case> Caso;
    List<RecordType> RecordID;
    if(trigger.isafter && trigger.isupdate)
    {
        try{
       Set<ID> ids = Trigger.newMap.keySet(); 
        objTask = [Select id,WhatId,RecordtypeID from Task where id in :ids];
        for (task fTask : objTask){
            String IDObjeto = fTask.WhatId;
      String IDMiolo = IDObjeto.substring(0,3);
            if(IDMiolo == '500')
            {
               IdCaso.add(fTask.whatId); 
               IdRecord.add(fTask.RecordtypeID);
            }
            
        }
        if(idcaso.size()>0){
            Caso = [SELECT Id, Ownerid, Status, Contact.Email, ContactId,  CustomerEmail__c, RecordType.Name, owner.name FROM Case WHERE Id in :idcaso];    
            RecordID = [SELECT Id, Name FROM Recordtype WHERE Id in :IdRecord];
        }
            }catch(Exception ex){}
    }
  for (Task objTarefa : Trigger.new)
    {
      try
    {
      // Verifica o o what id do tipo de registro
      String IDObjeto = objTarefa.WhatId;
      String IDMiolo = IDObjeto.substring(0,3);
      System.debug('O ID Miolo é: ' + IDMiolo );
       
      if(IDMiolo == '500')
      {

                if(trigger.isupdate && trigger.isbefore){
                    if(objTarefa.Tarefa_Respondida__c==true){
                        objTarefa.Status='Concluído';
                        objTarefa.status_tarefa__c='Fechado';
                    }
                }
        
        if(trigger.isafter && trigger.isupdate)
        {
                    //RecordType IdRecord2 = [SELECT Id, Name FROM Recordtype WHERE Id = :objTarefa.RecordtypeID];
                    RecordType IdRecord2;
                    for(RecordType objRecord : RecordID ){
                        if(objRecord.id==objTarefa.RecordtypeID){
                          IdRecord2 = objRecord.clone(true,true);
                        }
                    }
                    Case cs;
                    for(Case objCase:Caso){
                        if(objCase.id==objTarefa.WhatId){
                         cs = objCase.clone(true,true);
                        }
                    }
                    Task objTaskOld = System.Trigger.oldMap.get(objTarefa.Id);
                    if((objTaskOld.Tarefa_Respondida__c==true && objTarefa.Tarefa_Respondida__c==true)){objTarefa.addError('Edição da tarefa não é permitida');}
          if(IdRecord2.Name=='Contatar Cliente'){if(objTarefa.Conseguiu_contato_com_o_cliente__c=='Sim' || objTarefa.Conseguiu_contato_com_o_cliente__c=='Não' || objTarefa.Conseguiu_contato_com_o_cliente__c=='Não | Enviar e-mail para o cliente com posição'){cs.Status='Fechado';update cs;}}
          if(IdRecord2.Name=='Contatar Cliente - Refat'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(objTarefa.Conseguiu_contato_com_o_cliente__c=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}}

          if(IdRecord2.Name=='Enviar E-mail para Cliente')
          {
            String status = objTarefa.Status;
            
            if(status=='Aberto')
            {                        
              cs.OwnerId = objTarefa.CreatedById;
              cs.Status='Em tratativa';
              System.debug('recebendo o proprietario: ' + cs.OwnerId);
              update cs;                        
            }
            else if(objTarefa.Status=='Concluído')
            {
              cs.Status='Fechado';
              update cs;                       
            }
          }
          
          if(IdRecord2.Name=='Confirmar Dados Cliente'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}}
        
          if(IdRecord2.Name=='Verificar Dados Divergentes Rot T' || IdRecord2.Name=='Verificar Dados Divergentes Ecom'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamento.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}}
                    
          if(IdRecord2.Name=='Contatar Cliente - Entrega com Nota Fiscal'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}}
          
          if(IdRecord2.Name=='Posicionar Cliente Produto Similar')
          {
            if(objTarefa.Status=='Concluído' && (objTarefa.Cliente_aceitou_sug_de_produto_similar__c=='Sim' || objTarefa.Cliente_aceitou_sug_de_produto_similar__c=='Deseja trocar ou cancelar'))
            {
              cs.OwnerId = idFilaProcessamento.Id;
              cs.Status='Em fila';
              update cs;
            }
            else if (objTarefa.Status=='Concluído' && (objTarefa.Cliente_aceitou_sug_de_produto_similar__c=='Escolheu outro produto similar' || objTarefa.Cliente_aceitou_sug_de_produto_similar__c=='Deseja esperar o mesmo produto'))
            {
              cs.OwnerId = idFilaSuporteComercial.Id;
              cs.Status='Em fila';
              update cs;
            }
          }
          
          if(IdRecord2.Name=='Contatar Cliente - Análise de Produto')
          {
            String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
            conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Cliente_aceita_solucao__c=='Não' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaSuporteComercial.Id;
              cs.Status='Em fila';
              update cs;
            }
            if(objTarefa.Conseguiu_contato_com_o_cliente__c=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}
          
            if(conseguiu=='Sim' && objTarefa.Cliente_aceita_solucao__c=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}
          }

          if(IdRecord2.Name=='Contatar Cliente - Validar solução')
          {
            String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
            conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = objTarefa.CreatedById;cs.Status='Em tratativa';update cs;}else if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}
          }

          if(IdRecord2.Name=='Contatar Cliente - Cancelamento'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.NecessarioRetornarParaProcessamento__c=='Sim' && objTarefa.Status=='Concluído'){System.debug('Entrou no Else IF de Sim');cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.NecessarioRetornarParaProcessamento__c=='Não' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}}
          
          if(IdRecord2.Name=='Contatar Cliente - Troca'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Posicionamento final' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}else if(conseguiu=='Sim' && objTarefa.acao__c=='Enviar para comercial validar similar escolhido pelo cliente' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaSuporteComercial.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.acao__c=='Enviar para processamento gerar a troca' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;   }else if(conseguiu=='Sim' && objTarefa.acao__c=='Cliente decidiu cancelar' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}}
          
          if(IdRecord2.Name=='Contatar Cliente - Ação'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(objTarefa.Conseguiu_contato_com_o_cliente__c=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Posicionamento final | Fechar fluxo' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Cliente decidiu cancelar' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Enviar para processamento gerar a troca' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Enviar para comercial validar similar escolhido pelo cliente' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaSuporteComercial.Id;cs.Status='Em fila';update cs; }}     
          
          if(IdRecord2.Name=='Contatar Cliente - Ação - Problemas com trocas ou vendas'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Acao__c=='Posicionamento final | Fechar fluxo' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}else if(conseguiu=='Sim' && objTarefa.acao__c=='Cliente decidiu cancelar' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.acao__c=='Enviar para processamento gerar a troca' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.acao__c=='Enviar para comercial validar similar escolhido pelo cliente' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaSuporteComercial.Id;cs.Status='Em fila';update cs;}}
        
          if(IdRecord2.Name=='Posicionar Cliente - Divergência CD'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Cliente_desejaDivCD__c=='Verificar outra opção de similar ou enviar para validação da escolha do cliente' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaSuporteComercial.Id;cs.Status='Em fila';update cs;}     else if(conseguiu=='Sim' && (objTarefa.Cliente_desejaDivCD__c=='Cancelar' || objTarefa.Cliente_desejaDivCD__c=='Trocar com dados do novo produto | Gerar troca simbólica') && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}}
        
          if(IdRecord2.Name=='Contatar Cliente - Divergência CD'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.NecessarioRetornarParaProcessamento__c=='Não' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}     else if(conseguiu=='Sim' && objTarefa.NecessarioRetornarParaProcessamento__c=='Sim' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaProcessamentoSamsung.Id;cs.Status='Em fila';update cs;}}         

          if(IdRecord2.Name=='Contatar Cliente - Coleta e Devolução'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}     } 

          if(IdRecord2.Name=='Posicionar Cliente - Produto Devovido'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.O_que_ficou_resolvido__c=='Cliente decidiu cancelar pedido | Foi aberta OC | Solicitar SIM e encerrar fluxo' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}else if (conseguiu=='Sim' && objTarefa.O_que_ficou_resolvido__c=='Reenviar produto' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.O_que_ficou_resolvido__c=='Fechar fluxo | Cliente confirmou recebimento do produto' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}} 

          if(IdRecord2.Name=='Posicionar Cliente - Final - Produto Devolvido'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Sim' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}} 
         
          if(IdRecord2.Name=='Posicionar Cliente - Pendência de entrega'){String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;conseguiu = conseguiu.substring(0,3);if(conseguiu=='Não' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaAtendSamsungAtivo.Id;cs.Status='Em fila';update cs;}else if(conseguiu=='Sim' && objTarefa.Como_ficou_resolvida_a_pendencia__c=='Enviar para CD350 solucionar a pendência' && objTarefa.Status=='Concluído'){cs.OwnerId = idFilaCD350.Id;cs.Status='Em fila';update cs;}     else if(conseguiu=='Sim' && objTarefa.Como_ficou_resolvida_a_pendencia__c=='Fechar fluxo | Cliente confirmou recebimento do pedido' && objTarefa.Status=='Concluído'){cs.Status='Fechado';update cs;}}
          
          if(IdRecord2.Name=='Posicionar Cliente - Final - Pendência de entrega'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.Status='Fechado';
              update cs;
            }
          }
         
          if(IdRecord2.Name=='Posicionar Cliente Atraso Fornecedor'){
            if(objTarefa.Status=='Concluído' && (objTarefa.Cliente_deseja__c=='Trocar | Ativo gerar troca ML Admin e enviar para processar venda' || objTarefa.Cliente_deseja__c=='Cancelar com pagamento via boleto/débito on | Enviar dados para restituição'))
            {
              cs.OwnerId = idFilaProcessamentoSamsung.Id;
              cs.Status='Em fila';
              update cs;
            }     
            else if(objTarefa.Status=='Concluído' && objTarefa.Cliente_deseja__c=='Cancelar com pagamento via cartão | Ativo gerar cancelamento ML Admin | Fechar fluxo')
            {
              cs.Status='Fechado';
              update cs;
            }
          }
          
          if(IdRecord2.Name=='Verificar Dados Divergentes Troca'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaProcessamentoSamsung.Id;
              cs.Status='Em fila';
              update cs;
            }
            else if(conseguiu=='Não' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaAtendSamsungAtivo.Id;
              cs.Status='Em fila';
              update cs;
            }     
          }
          
          if(IdRecord2.Name=='Contatar Cliente - Contato do Processamento'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.Status='Fechado';
              update cs;
            }
          }
          
                    if(IdRecord2.Name=='Enviar E-mail para Cliente - Contato do Processamento')
          {
            String status = objTarefa.Status;
            if(status=='Aberto')
            {                        
              cs.OwnerId = objTarefa.CreatedById;
              cs.Status='Em tratativa';
              System.debug('recebendo o proprietario: ' + cs.OwnerId);
              update cs;                        
            }
            else if(objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaProcessamentoSamsung.Id;
              cs.Status='Em fila';
              update cs;                       
            }
          }
                    
          if(IdRecord2.Name=='Contatar Cliente - Garantia Estendida'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.Status='Fechado';
              update cs;
            }
          }
          
          if(IdRecord2.Name=='Confirmar Dados Cliente - Suporte Comercial'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Não' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaAtendSamsungAtivo.Id;
              cs.Status='Em fila';
              update cs;
            }
            else if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaProcessamentoSamsung.Id;
              cs.Status='Em fila';
              update cs;
            }
          }
                    
          if(IdRecord2.Name=='Contatar Cliente - Nota Fiscal'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.Status='Fechado';
              update cs;
            }
          }
          
          if(IdRecord2.Name=='Verificar Dados Divergentes - Nota Fiscal'){
                        String conseguiu = objTarefa.Conseguiu_contato_com_o_cliente__c;
                        conseguiu = conseguiu.substring(0,3);
            if(conseguiu=='Não' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaAtendSamsungAtivo.Id;
              cs.Status='Em fila';
              update cs;
            }
            else if(conseguiu=='Sim' && objTarefa.Status=='Concluído')
            {
              cs.OwnerId = idFilaProcessamento.Id;
              cs.Status='Em fila';
              update cs;
            }
          }
          
          System.debug('Entrou no if do 500 ');    
          System.debug('O valor do before: ' + trigger.isbefore + ' O valor do Insert: ' + trigger.isinsert);
        }
                
                if( trigger.isbefore && trigger.isinsert){Case cs = [SELECT Id, Ownerid, Status, Contact.Email, ContactId,  CustomerEmail__c, RecordType.Name, owner.name FROM Case WHERE Id = :objTarefa.WhatId];Datetime dt = System.Datetime.now();dt = dt.addHours(+8);objTarefa.ActivityDate=Date.valueof(dt);objTarefa.WhoId=cs.ContactId;objTarefa.Status_Tarefa__c='Em fila';/*objTarefa.ownerid='005j000000C0QIy';*/}
      }
        } catch(exception ex) {}
    }
}