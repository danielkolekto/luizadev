trigger trgResolucao on CaseResolution__c (before update,after update,before insert) {


    for (CaseResolution__c objCR: Trigger.new){
        Recordtype IdRecord = [Select id,Name from Recordtype where id=:objCR.RecordtypeID];
        System.debug(objCR);
        Case cs = [Select Id,OwnerID,Owner.Name, Status,prazo_de_resolucao__c,level_1__c,level_2__c from Case where id=:objCR.Caso__c];
        //clsMetodosUteis cl = new clsMetodosUteis();
        if(trigger.isbefore && trigger.isinsert){
            //verifica o tipo de registro e popula o SLA:
            if(idRecord.Name=='Análise e Solicitação Restituição' || 
               idRecord.name=='Liberar Saldo - Exceção | Retirar do lote' ||
               idrecord.name=='Análise Erro de Anúncio' ||
               idRecord.name=='Análise Erro de Cadastro' ||
               idRecord.name=='Acompanhar Posição Erro de Cadastro' ||
               idRecord.name=='Análise e Processamento da Venda' ||
               idRecord.name=='Verificar Similar | Previsão' ||
               idRecord.name=='Retirar do Lote e Gerar Saldo' ||
               idrecord.name=='Resposta Final de Entrega' ||
               idRecord.name=='Análise Entrega Acareação' ||
               idRecord.name=='Análise de Fraude' ||
               idRecord.name=='Análise Erro na Venda' ||
               idRecord.name=='Análise do Atraso na Emissão da NF' ||
               idRecord.name=='Gerar Saldo / Empenho Virtual e Desbloquear Pedido' ||
               idRecord.name=='Acompanhar Entrega (Dados Divergentes)' ||
               idRecord.name=='Acompanhar Devolução' ||
               idRecord.name=='Acompanhar Entrega' ||
               idRecord.name=='Autorizar Refaturamento' ||
               idRecord.name=='Processar Venda Rot T - Novo Produto' ||
               idRecord.name=='Processar Venda Rot T' ||
               idRecord.name=='Processar Venda Ecom' ||
               idRecord.name=='Processar Venda Novo Produto' ||
               idRecord.name=='Verificar Produto Similar' ||
               idRecord.name=='Validar Produto Escolhido' ||
               idRecord.name=='Atraso na devolução' ||
               idRecord.name=='Análise Coleta e Devolução' ||
               idRecord.name=='Análise Fraude - Coleta e Devolução' ||
               idRecord.name=='Solicitar Restituição' ||
               idRecord.name=='Processar Troca' ||
			   idRecord.name=='Análise Produto Devolvido' ||
               idRecord.name=='Verificar Similar | Previsão - Suporte Comercial' ||
               idRecord.name=='Verificar Similar | Previsão Sup Com' ||
               idRecord.name=='Gerar Troca ou Cancelamento Simbólico' ||
               idRecord.name=='Processar Troca ou Cancelamento' ||
               idRecord.name=='Colocar o SIM na OC' ||
               idRecord.name=='Solucionar Pendência' ||
               idRecord.name=='Verificar Similar | Previsão - Problemas com Trocas ou Vendas' ||
               idRecord.name=='Análise - Erro Garantia' ||
               idRecord.name=='Aguardar Solução - Erro Garantia' ||
               idRecord.name=='Análise e Processamento da Venda - Problemas com Trocas ou Vendas' ||
               idRecord.name=='Gerar Declaração de Venda' ||
               idRecord.name=='Processar Troca Rot T - 1' ||
               idRecord.name=='Gerar Saldo Troca Rot T' ||
               idRecord.name=='Processar Troca Rot T - 2' ||
               idRecord.name=='Desbloquear Pedido e Colocar SIM na OC'
               
               
              ){
                   String dt = clsMetodosUteis.RetornaDiaUtil(1,System.Datetime.now());
                   objCR.prazo_de_resolucao__c=Datetime.valueOf(dt);
                   objCR.ownerid=cs.ownerid;
                   cs.prazo_de_resolucao__c=Datetime.valueOf(dt);
                  if(cs.level_2__c=='Recontato após protocolo anterior fechado e promessa de entrega não cumprida'){
                    Datetime dt2 = System.Datetime.now();
                    dt2 = dt2.addHours(+4);
                   	objCR.prazo_de_resolucao__c=Datetime.valueOf(dt2);
                   	cs.prazo_de_resolucao__c=Datetime.valueOf(dt2);  
                  }
                  update cs;
               }
            if(	idRecord.Name=='Acompanhar Posição Erro de Anúncio'||
              	idRecord.Name=='Retorno Acareação' ||
                idRecord.Name=='Barrar - Fraude' ||
                idRecord.Name=='Confirmar Pedido Barrado' ||
                cs.level_2__c=='Recontato após protocolo anterior fechado e promessa de coleta não cumprida'
              ){
                   Datetime dt = System.Datetime.now();
                  objCR.ownerid=cs.ownerid;
                   dt = dt.addHours(+4);
                   objCR.prazo_de_resolucao__c=Datetime.valueOf(dt);
                   cs.prazo_de_resolucao__c=Datetime.valueOf(dt);
                   update cs;
               }
            //objCR.Area_solucionadora__c=cs.Owner.Name;
            objCR.Status_Resolucao__c='Em fila';
            
        }
        if(trigger.isbefore && trigger.isupdate){
            if(objCR.Formulario_Preenchido__c==true){
                 objCR.Status_Resolucao__c='Fechado';
            }
                
        }
        
        if(trigger.isafter && trigger.isupdate){
        CaseResolution__c objOldCR = System.Trigger.oldMap.get(objCR.Id);
                if(objOldCR.Formulario_Preenchido__c==true && objCR.Formulario_Preenchido__c==true && objOldCR.Status_Resolucao__c != 'Fechado'){
                    objCR.addError('Edição de resolução não é permitida');
                }
        
            /*String idCaso = objCR.Caso__c;
        	
        	//Verifica o campo de ação
        		
        	system.debug('Id Record: ' + IdRecord.Name);
        	if((objCR.Action__c=='Enviar para ativo posicionar cliente' || 
                objCR.Action__c == 'Acompanhar solução') &&
               (IdRecord.Name == 'Produto Devolvido' || 
                IdRecord.Name == 'Pendencia Entrega' ||
                IdRecord.Name=='Análise do Produto' || 
                IdRecord.Name=='Erro de Cadastro' || 
                idRecord.Name=='Garantia Estendida'
               	)){
            	//Verifica o tipo de registro para realizar o vinculo correto da propriedade do caso e resolução;
                if(IdRecord.Name=='Análise do Produto' || IdRecord.Name=='Erro de Cadastro' || 
                   idRecord.Name=='Garantia Estendida' )
                { 
                    if (IdRecord.Name == 'Garantia Estendida' || IdRecord.Name == 'Erro de Cadastro')
                    {
                        if (objCR.Action__c == 'Enviar para ativo posicionar cliente')
                        {
                        	//Captura o id da Fila
                            Group idFila = [Select id 
                                                from 	Group 
                                                where 	Type = 'Queue' 
                                                and name like '%Atendimento Samsung ativo%'];
                            cs.OwnerId=idFila.Id;
                            cs.status='Em fila';
                            update cs;
                            
                            Task tarefa = new Task();
                            tarefa.WhatId = objCR.Id;
                            tarefa.Priority = 'Medium';
                            tarefa.Status = 'Open';
                            tarefa.Subject = 'Contatar cliente';
                            insert tarefa;
                        }
                        else if (objCR.Action__c == 'Acompanhar solução' && (objCR.PosicionamentoFinalSobreErro__c != null &&
                                                                             objCR.PosicionamentoFinalSobreErro__c != '') ||
                                											(objCR.FinalConsiderations__c != null &&
                                                                            objCR.FinalConsiderations__c != ''))
                        {
                            //Captura o id da Fila
                            Group idFila = [Select id 
                                                from 	Group 
                                                where 	Type = 'Queue' 
                                                and name like '%Atendimento Samsung ativo%'];
                            cs.OwnerId=idFila.Id;
                            cs.status='Em fila';
                            update cs;
                            
                            Task tarefa = new Task();
                            tarefa.WhatId = objCR.Id;
                            tarefa.Priority = 'Medium';
                            tarefa.Status = 'Open';
                            tarefa.Subject = 'Contatar cliente';
                            insert tarefa;
                        }
                    }
                    else
                    {
                        //Captura o id da Fila
                        Group idFila = [Select id 
                                            from 	Group 
                                            where 	Type = 'Queue' 
                                            and name like '%Atendimento Samsung ativo%'];
                        cs.OwnerId=idFila.Id;
                        cs.status='Em fila';
                        update cs; 
                    }
                    
                }
                else if(IdRecord.Name == 'Produto Devolvido' || IdRecord.Name == 'Pendencia Entrega')
                {
                    system.debug('Entrei!!!');
                    system.debug('What Resolved: ' + objCR.WhatResolved__c);
                    if(objCR.WhatResolved__c == 'Reenviar produto' || 
                       objCR.WhatResolved__c == 'Cliente decidiu cancelar pedido | Foi aberta OC | Solicitar SIM e encerrar fluxo' ||
                       objCR.WhatResolved__c == 'Enviar para CD350 solucionar a pendência' ||
                       objCR.WhatResolved__c == 'Fechar fluxo | Cliente confirmou recebimento do produto' ||
                       objCR.ResolvedDispute__c == 'Fechar fluxo | Cliente confirmou recebimento do produto')
                    {
                        Group idFila = [SELECT Id 
                                        FROM 	Group 
                                        WHERE 	Type = 'Queue' 
                                        AND Name LIKE '%CD350 Samsung%'];
                        
                        // Captura o caso para atualizar
                        //Case cs = [SELECT Id, Ownerid FROM Case WHERE Id = :cr.Caso__c];
                        
                        if (objCR.WhatResolved__c == 'Cliente decidiu cancelar pedido | Foi aberta OC | Solicitar SIM e encerrar fluxo' ||
                            objCR.WhatResolved__c == 'Fechar fluxo | Cliente confirmou recebimento do produto' ||
                           	objCR.ResolvedDispute__c == 'Fechar fluxo | Cliente confirmou recebimento do produto')
                        {
                            cs.Status = 'Fechado';
                        }
                        else
                        {
                            Task tarefa = new Task();
                            tarefa.WhatId = objCR.Id;
                            tarefa.Priority = 'Medium';
                            tarefa.Status = 'Open';
                            tarefa.Subject = 'Contatar cliente';
                            insert tarefa;   
                        }
                        cs.OwnerId = idfila.Id;
                        update cs;
                    }
                }
        	}*/
        }
}
}