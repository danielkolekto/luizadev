/**
*	@author Diego Moreira
*	@class Classe de negocio para o objeto de Caso
*/
public with sharing class CaseBO {
    /*
        Singleton
    */
    private static final CaseBO instance = new CaseBO();
    private CaseBO() {}
    
    public static CaseBO getInstance() {
        return instance;
    }
    
    
    public static void caseTreatmentOnBeforeUpdate(List<Case> triggerNew, Map<Id, Case> oldMap){
        Map<Id, List<CaseResolution__c>> caseResolutionMapByCaseId = CaseResolutionDAO.getCaseResolutionsMapByCaseId( oldMap.keySet() );
        Map<Id, List<Task>> taskMapByCaseId = ActivitiyDAO.getTaskMapByWhatId( oldMap.keySet() );
        
        for(Case caseNew : triggerNew){
            if(!isCaseMarketplace(caseNew) && !ProcessControl.ignoredByTrigger) {
                Case caseOld = oldMap.get(caseNew.Id);
                
                caseNew.SLA_8_1_Fase__c = !(caseNew.Level_1__c != caseOld.Level_1__c || caseNew.Level_2__c != caseOld.Level_2__c);
                Datetime dtSLA;
                String fila = caseOld.OwnerId;
                fila = fila.substring(0, 3);
                String filaAtual = caseNew.OwnerId;
                filaAtual = filaAtual.substring(0, 3);
                Group caseQueue = (fila == '00G' ? Utils.getQueueById(caseOld.OwnerId) : null);
                Boolean changedOwner = caseOld.OwnerId != caseNew.OwnerId;
                
                
                if (caseNew.Status != 'Fechado') {
                    Boolean Trocou_Area = false;
                    List<CaseResolution__c> caseResolutions = caseResolutionMapByCaseId.get(caseNew.Id);
                    List<Task> objTarefa = taskMapByCaseId.get(caseNew.Id);
                    
                    System.debug('caseOld.OwnerId: ' + caseOld.OwnerId);
                    System.debug('caseNew.OwnerId: ' + caseNew.OwnerId);
                    
                    if(!changedOwner) {
                        caseNew.Area_solucionadora__c = caseOld.Area_solucionadora__c;
                        Trocou_Area = true;
                        
                    } else if(changedOwner && fila != '005') {
                        caseNew.Area_solucionadora__c = (changedOwner && fila == '00G' && filaAtual == '005' ? caseQueue.Name : '');
                        Trocou_Area = true;
                        
                    } else if(changedOwner && filaAtual == '00G') {
                        System.debug('caseOld.OwnerId2: ' + caseOld.OwnerId);
                        System.debug('caseNew.OwnerId2: ' + caseNew.OwnerId);
                        caseNew.Area_solucionadora__c = (changedOwner && fila == '00G' ? caseQueue.Name : '');
                        Trocou_Area = true;
                    }
                    
                    caseNew.Status = (changedOwner && fila == '00G' && filaAtual == '005' ? 'Em tratativa' : caseNew.Status);
                    System.debug('O valor da area do caso é: ' + caseNew.Area_solucionadora__c);
                    System.debug('O valor do Status do caso é: ' + caseNew.Status);
                    if(Trocou_Area == true && fila == '00G' && filaAtual == '005') {
                        clsMetodosUteis.AtualizaProprietariosCaseResolution(caseResolutions, caseNew.OwnerId, caseNew.Area_solucionadora__c, caseNew.Status);
                        clsMetodosUteis.AtualizaProprietariosTask(objTarefa, caseNew.OwnerId, caseNew.Area_solucionadora__c, caseNew.Status);
                    }
                    if(filaAtual == '00G') {
                        clsMetodosUteis.AtualizaProprietariosCaseResolution(caseResolutions, caseNew.OwnerId, '', 'Em Fila');
                    }
                }
                
                if(caseNew.origin == 'E-Mail (S/Tratativa)') {
                    System.debug('O valor de level_1: ' + caseNew.Level_1__c);
                    System.debug('O valor de level_2: ' + caseNew.Level_2__c);
                    
                    if(String.isNotEmpty(caseNew.Level_1__c)) {
                        Case_Configuration__c cf = CaseConfigurationDAO.getCaseConfigurationByLevel(caseNew.Level_1__c, caseNew.Level_2__c);
                        
                        if(cf != null) {
                            caseNew.RecordtypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(cf.Register_Type__c).getRecordTypeId();
                            caseNew.Origin = 'E-mail';
                            caseNew.SLA_8_1_Fase__c = false;
                        }
                    }
                }
            }
        }
    }
    
    public static void caseTreatmentOnAfterInsertUpdate(List<Case> triggerNew) {
        for(Case caseNew : triggerNew) {
            
            // Realiza as validações
            if(!isCaseMarketplace(caseNew) && !ProcessControl.ignoredByTrigger) {
                
                if( caseNew.PaymentForm__c == 'Boleto (PREENCHER O Bloco 2 - Boleto)' && (caseNew.Value__c == 0 || caseNew.NumberBanck__c == '' || caseNew.Agency__c == '' || caseNew.NumberAccountBank__c == '' || caseNew.DigitAccountBank__c == '' || caseNew.TypeAccountBank__c == null) ) caseNew.addError('Informe os campos relativo a Boleto');
                
                if( (caseNew.AreaCausingException__c == 'Transportes (PREENCHER O "Bloco 3" - Transportes)' || caseNew.AreaCausingException__c == 'Transportes (PREENCHER "Bloco 2")') && (caseNew.AuthorizationProtocolDelivery__c == '' || caseNew.CollectionProtocolNumberLateReturns__c == '' || caseNew.CollectionProtocolNumberReestablishment__c == '' || caseNew.Carrier__c == null) ) caseNew.addError('Informe os campos relativo a Transportadora');
                
                if( caseNew.ReasonException__c == 'Embalagem interna com dados de outro cliente (PREENCHER "Bloco 3")' && (caseNew.NumberOrderGemcoCustomer__c == '' || caseNew.NameCustomer__c == '' || caseNew.ProductCode__c == '' || caseNew.ProductcValue__c == null || caseNew.NumberOrderGemcoCustomer__c == null || caseNew.NameCustomer__c == null || caseNew.ProductCode__c == null) ) caseNew.addError('Informe os campos relativo a Embalagem');
                
                if( (caseNew.ReasonException__c == 'Coleta - Devolução atrasada com comprovante ("Bloco 3" - Transportes: PREENCHER 2. E 4.)' || caseNew.ReasonException__c == 'Coleta - Devolução atrasada sem comprovante / transportadora alega não ter coletado ("Bloco 3" - Transportes: PREENCHER 2. E 4.)' || caseNew.ReasonException__c == 'Coleta - Devolução atrasada sem comprovante / transportadora não confirmou a coleta ("Bloco 3" - Transportes: PREENCHER 2. E 4.)' || caseNew.ReasonException__c == 'Coleta - Devolução atrasada sem comprovante / transportadora alega não ter coletado ("Bloco 2" - Transportes: PREENCHER 2. E 4.)' || caseNew.ReasonException__c == 'Coleta - Devolução atrasada com comprovante ("Bloco 2" - Transportes: PREENCHER 2. E 4.)' || caseNew.ReasonException__c == 'Coleta - Devolução atrasada sem comprovante / transportadora não confirmou a coleta ("Bloco 2" - Transportes: PREENCHER 2. E 4.)') && (caseNew.CollectionProtocolNumberLateReturns__c == '' || caseNew.Carrier__c == null) ) caseNew.addError('Informe os campos 2 E 4 de Transportes');
                
                if( caseNew.ReasonException__c == 'Coleta - Recontato ("Bloco 3" - Transportes: PREENCHER 3. E 4.)' && (caseNew.CollectionProtocolNumberReestablishment__c == '' || caseNew.Carrier__c == null) ) caseNew.addError('Informe os campos 3 E 4 de Transportes');
                
                if( caseNew.ReasonException__c == 'Embalagem interna com dados de outro cliente (PREENCHER "Bloco 4")' && (caseNew.NumberOrderGemcoCustomer__c == '' || caseNew.NameCustomer__c == '' || caseNew.ProductCode__c == '' || caseNew.ProductcValue__c == 0) ) caseNew.addError('Preencha o Bloco 4');
                
                if( caseNew.ProblemTypeRegistration__c != 'Cliente não consegue modificar a senha (NÃO PREENCHER NOVO E-MAIL)' && String.isNotEmpty(caseNew.ProblemTypeRegistration__c) && (caseNew.NewEmailAlteration__c == '' || caseNew.NewEmailAlteration__c == null) ) caseNew.addError('Preencher o campo novo E-mail');
                
                if( caseNew.TypeDelevery__c == 'Agendada (PREENCHER DATA DO AGENDAMENTO - próxima pergunta)' && (caseNew.DateRequestDelevery__c == null) ) caseNew.addError('Preencher a data do agendamento');
                
                if( caseNew.CustomerWinsBrandModel__c == 'Sim (PREENCHER PREFERÊNCIA DO CLIENTE - próxima pergunta)' && (caseNew.CustomerPrefer__c == '' || caseNew.CustomerPrefer__c == null) ) caseNew.addError('Preencher preferência do cliente');
                
                if( caseNew.ThereDifferenceCharged__c == 'Sim (PREENCHER VALOR DA DIFERENÇA - próxima pergunta)' && (caseNew.ValueDiference__c <= 0 || caseNew.ValueDiference__c == null) ) caseNew.addError('Preencher o valor da diferença');
                
                if( caseNew.ProposedSolutionCommercialSupport__c == 'Efetue a troca para o cliente pelo produto correto ("Bloco 2": PREENCHER A PERGUNTA 1)' && caseNew.CorrectItemCode__c == '' ) caseNew.addError('Preencher a Pergunta 1');
                
                if( caseNew.ProposedSolutionCommercialSupport__c == 'Previsão de recebimento do item ("Bloco 2": PREENCHER AS PERGUNTAS 2., 3. E 4.)' && (caseNew.InformDateReceipt__c == null || caseNew.DifferenceChargedCustomerSimilar1__c <= 0) ) caseNew.addError('Preencher as Perguntas 2,3,4');
                
                if( caseNew.ProposedSolutionCommercialSupport__c == 'Indisponível no fornecedor/ Fora de linha ("Bloco 2": PREENCHER AS PERGUNTAS DE 3. A 8.)' && (caseNew.DifferenceChargedCustomerSimilar1__c <= 0 || caseNew.DifferenceChargedCustomerSimilar2__c <= 0 || caseNew.DifferenceChargedCustomerSimilar3__c <= 0) ) caseNew.addError('Preencher as Perguntas 3 a 8');
                
                if( caseNew.StopShippingProduct__c == 'Não (PREENCHER ENDEREÇO - próxima pergunta)' && (caseNew.AddressDeliveryNewSale__c == '' || caseNew.AddressDeliveryNewSale__c == null) ) caseNew.addError('Preencher o Endereço para entrega da nova venda');
                
                if( caseNew.TypeNFRecharged__c == 'Coleta (PREENCHER Número NF Coleta)' && (caseNew.NumberNFCollect__c == '' || caseNew.NumberNFCollect__c == null) ) caseNew.addError('Preencher o Número NF Coleta');
                
                System.debug('Codigo ID: ' + caseNew.CodigoIdentificador__c);
                List<ItemCaso__c> listaItensCaso = [SELECT Id FROM ItemCaso__c WHERE CodigoIdentificador__c = : caseNew.CodigoIdentificador__c AND CodigoIdentificador__c != null limit 100];
                for (ItemCaso__c item: listaItensCaso) {
                    item.Caso__c = caseNew.Id;
                }
                
                update listaItensCaso;
            }
        }
    }
    
    /**
    *   Atualiza o marco do caso
    *   @param triggerNew Lista com os casos para verificação
    */
    public static void addEntitlementToCase(List<Case> triggerNew, Set<Id> triggerNewIdSet) {
        Map<Id, List<CaseComment__c>> commentsMapByCase = CaseCommentDAO.getCaseCommentsMapByCaseId(triggerNewIdSet);
        
        for(Case caseNew : triggerNew){
            List<CaseComment__c> caseCommentList = commentsMapByCase.containsKey(caseNew.Id) ? commentsMapByCase.get(caseNew.Id) : new List<CaseComment__c>();
            
            String entitlementIdSeller = Label.EntitlementAtendimentoSeller;
            String entitlementIdCustomer = Label.EntitlementAtendimentoCustomer;
            String entitlementIdMagazine = Label.EntitlementAtendimentoMagazine;
            
            System.debug('@@@ entitlementIdSeller: ' + entitlementIdSeller);
            System.debug('@@@ entitlementIdCustomer: ' + entitlementIdCustomer);
            System.debug('@@@ entitlementIdMagazine: ' + entitlementIdMagazine);
            
            if(!isCaseMarketplace(caseNew) || caseCommentList.isEmpty()) continue;
            
            if('Aguardando resposta do Lojista'.equalsIgnoreCase(caseNew.Status)) {
                caseNew.EntitlementId = entitlementIdSeller;
                
            } else if('Aguardando resposta do Cliente'.equalsIgnoreCase(caseNew.Status)) {
                caseNew.EntitlementId = entitlementIdCustomer;
                
            } else if('Aguardando resposta do Magazine Luiza'.equalsIgnoreCase(caseNew.Status)) {
                caseNew.EntitlementId = entitlementIdMagazine;
                
            } else {
                caseNew.EntitlementId = null;
            }
            
        }
    }

    /**
    *   Atualiza o marco do caso
    *   @param triggerNew Lista com os casos para verificação
    *   @param oldMap Lista com os valores anteriores do caso
    */
    public void atualizaMarco(List<Case> triggerNew, Map<Id, Case> oldMap) {
        Set<Id> caseIds = new Set<Id>();
        
        for(Case caseNew : triggerNew){
            Case caseOld = oldMap.get(caseNew.Id);
            
            if( isCaseMarketplace(caseNew) && caseNew.Status != caseOld.Status ) {
                caseIds.add(caseNew.Id);
            }
        }
        
        if(caseIds.isEmpty()) return;
        
        
        Map<Id, List<CaseMilestone>> mapMilestonesByCase = CaseMilestoneDAO.getCaseMilestonesMapByCaseId(caseIds);
        Map<String, MilestoneManager__mdt> milestoneManagerMap = CustomMetadataDAO.getMilestonesManagerMap();
        
        
        List<CaseMilestone> milestonesUpdateList = new List<CaseMilestone>();
        
        for(Case caseNew : CaseDAO.getCaseById(caseIds)){
            Case caseOld = oldMap.get(caseNew.Id);
            
            if( milestoneManagerMap.containsKey((caseOld.Status + caseNew.RecordType.Name).trim()) ) {
                List<CaseMilestone> caseMilestonesList = mapMilestonesByCase.containsKey(caseNew.Id) ? mapMilestonesByCase.get(caseNew.Id) : new List<CaseMilestone>();
                MilestoneManager__mdt milestoneInfo = milestoneManagerMap.get((caseOld.Status + caseNew.RecordType.Name).trim());
                
                for(CaseMilestone cm : caseMilestonesList){
                    if(milestoneInfo.Milestone__c.equalsIgnoreCase(cm.MilestoneType.Name) || caseNew.IsClosed){
                        cm.CompletionDate = Datetime.now();
                        milestonesUpdateList.add(cm);
                    }
                }
            }
        }
        
        if(!milestonesUpdateList.isEmpty())
            Database.update(milestonesUpdateList);
    }
    
    /**
    *   Atualiza a media da avaliação do cliente para o seller
    *   @param newCases Lista de dados de casos fechados e suas avaliações
    */
    public void atualizaAvaliacaoSeller( List<Case> newCases, Map<Id, Case> oldMapCases ) {
        List<String> casesId = new List<String>();
        Map<Id, Account> sellerToUpdateMap = new Map<Id, Account>();
        
        for(Case caseNew : newCases) {
            Case caseOld = oldMapCases.get( caseNew.Id );
            
            if(isCaseMarketplace(caseNew) && caseNew.IsClosed != caseOld.IsClosed && caseNew.IsClosed && caseNew.ServiceRating__c >= 0) {
                casesId.add( caseNew.LuizaCode__c );
            }               
        }

        for( Case caseResult : CaseDAO.getInstance().getCaseByIntegrationId( casesId ) ) {
            if(caseResult.Seller__c != null) {
                Account sellerAccount;
                
                if(sellerToUpdateMap.containsKey(caseResult.Seller__c)){
                    sellerAccount = sellerToUpdateMap.get(caseResult.Seller__c);
                    sellerAccount.TotalCases__c += 1;
                    sellerAccount.SellerRating__c += caseResult.ServiceRating__c;
                } else {
                    sellerAccount = new Account(
                        Id = caseResult.Seller__c,
                        TotalCases__c = caseResult.Seller__r.TotalCases__c + 1,
                        SellerRating__c = caseResult.ServiceRating__c + caseResult.Seller__r.SellerRating__c
                    );
                }
                
                sellerToUpdateMap.put(sellerAccount.Id, sellerAccount);
            }
            
            ProcessControl.ignoredByTrigger = true;
        }

        CaseDAO.getInstance().updateData( sellerToUpdateMap.values() ); 
    }

    /**
    *   Cria integração de fechamento automatico
    *   @param newCases Lista de novos casos adicionados
    */
    public void criaFilaIntegracao( List<Case> newCases ) {
        List<String> casesId = new List<String>();
        List<String> jsonList = new List<String>();
        List<Queue__c> queueListInsert = new List<Queue__c>();
        
        for( Case caseNew : newCases ) {
            if( isCaseMarketplace(caseNew) && caseNew.Status.equals( 'Fechado Automático' ) ) {
                casesId.add( caseNew.LuizaCode__c );
            }
        }
        
        for( Case caseResult : CaseDAO.getInstance().getCaseByIntegrationId( casesId ) ) {
            jsonList.add( MktPlace_CaseOutboundIntegrationBO.getJsonClose( caseResult ) );
        }
        
        for( String jsonResult : jsonList ) {
            queueListInsert.add( QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_CLOSE_SALESFORCE_TO_GIBA.name(), jsonResult, false ) );
        }
        
        Database.insert(queueListInsert);
    }
    
    
    public static Boolean isCaseMarketplace(Case caseObj){
        return caseObj.RecordTypeId == Utils.getRecordTypeId('Case', 'MktPlace_CancelamentoPedido') ||
            caseObj.RecordTypeId == Utils.getRecordTypeId('Case', 'MktPlace_DuvidasProdutos') ||
            caseObj.RecordTypeId == Utils.getRecordTypeId('Case', 'MktPlace_PosicaoEntrega');
    }
    
}