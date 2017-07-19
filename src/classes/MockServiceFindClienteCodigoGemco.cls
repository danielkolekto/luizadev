@isTest
global class  MockServiceFindClienteCodigoGemco implements WebServiceMock {
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           	
       	wsdlMagazine.findClienteSamsungByCodigoPedidoGemcoResponse respElement = 
           new wsdlMagazine.findClienteSamsungByCodigoPedidoGemcoResponse();
           
       	 respElement.return_x = CriaObjetos();
       		response.put('response_x',respElement); 
   			}
    
    private static wsdlMagazine.Endereco criaEndereco(){
     		wsdlMagazine.Endereco objEnd = new wsdlMagazine.Endereco();
        	objEnd.bairro='Bairro';
        	objEnd.CEP='999999999';
        	objEnd.cidade='Cidade';
        	objEnd.complemento='Complemento';
        	objEnd.dataAtualizacao=datetime.now();
        	objEnd.endereco='rua';
        	objEnd.estado='SP';
        	objEnd.id=10;
        	objEnd.numero='20';
        	objEnd.pais='Brazil';
        	objEnd.tipoLogradouro='RUA';
        	return objEnd;
        }
    private static wsdlMagazine.Telefone criaTelefone(){
     		wsdlMagazine.Telefone objTel = new wsdlMagazine.Telefone();
        	objTel.codigoArea='11';
        	objTel.codigoPais='55';
        	objTel.fone='9999999999';
        	objTel.ramal='99';
        	return objTel;
        }
    
    private static List<wsdlMagazine.Pedido> criaPedido(){
        List<wsdlMagazine.Pedido> arPed = new List<wsdlMagazine.Pedido>();
        wsdlMagazine.Pedido objPed = new wsdlMagazine.Pedido();
        objPed.id='10';
        objPed.notaFiscal='2020';
        objPed.tipoPedido=1;
        objPed.numeroVolumes=10;
        objPed.idPedidoPrincipal=10;
        wsdlMagazine.Cliente cliente = new wsdlMagazine.Cliente();
        /*==Cliente==================*/
        cliente.id=10;
        cliente.clienteOuro='S';
        cliente.email='teste@teste.com.br';
        cliente.origemSite=true;
        cliente.origemLojaFisica=false;
        cliente.pessoaFisica = criaPessoa();
        /*==========================*/
        objPed.Cliente= cliente;
        objPed.tipoPagamento='2';
        objPed.condicaoPagamento='A vista';
        objPed.quantidadeParcelas=1;
        objPed.data=datetime.now();
        objPed.dataEntrada=datetime.now();
        objPed.dataCancelamento=datetime.now();
        objPed.dataLiberacaoCredito=datetime.now();
        objPed.dataLiberacaoParaFaturamento=datetime.now();
        objPed.dataFaturamento=datetime.now();
        objPed.dataPrevistaEntrega=datetime.now();
        objPed.tipoEntrega='10';
        
        wsdlMagazine.ModalidadeFrete MF = new wsdlMagazine.ModalidadeFrete();
        mf.id='20';
        mf.descricao='Sem frete';
        
        objPed.modalidadeFrete=mf;
        objPed.dataEntrega=datetime.now();
        objPed.dataEntregaAgendada=datetime.now();
        objPed.turnoEntregaAgendada='Diurno';
        objPed.enderecoEntrega=criaEndereco();
        objPed.transportadora=criaTransportadora();
        
        wsdlMagazine.Rota rot = new wsdlMagazine.Rota();
        rot.id=99;
        rot.descricao='rota de saida';
        
        objPed.rota=rot;
        objPed.retiraNaLoja=false;
        objPed.valorMercadoria=100;
        objPed.valorJuros=100;
        objPed.valorEntrada=100;
        objPed.valorFrete=100;
        objPed.valorMercado=100;
        objPed.valorJurosFinanceiros=100;
        objPed.valorTotal=100;
        objPed.valorTotalIndexado=100;
        objPed.valorVendaVista=100;
        objPed.valorVendaLiquida=100;
        objPed.valorParcela=100;
        objPed.valorRebatido=100;
        objPed.percentualJuros=100;
        objPed.taxaJurosRebate=100;
        objPed.item=criaItens();
        
        wsdlMagazine.SituacaoPedido sp = new wsdlMagazine.SituacaoPedido();
        sp.id=10;
        sp.descricao='Descricao';
        
        objPed.situacao=sp;
        objPed.origem=1;
        objPed.listaCasamento=false;
        objPed.flagCancelamento=false;
        objPed.flagTroca=false;
        objPed.numeroPedidoControle=1010;
        arPed.add(objPed);
        return arPed;
        
        
    }
    
    private static List<wsdlMagazine.ItemPedido> criaItens(){
        List<wsdlMagazine.ItemPedido> arIP = new List<wsdlMagazine.ItemPedido>();
        wsdlMagazine.ItemPedido objItem = new wsdlMagazine.ItemPedido();
        objItem.id=20;
        objItem.produto=criaProduto();
        objItem.numeroSerieProduto='2010';
        objItem.precoUnitario=2000;
        objItem.precoOriginal=2000;
        objItem.quantidadeSolicitada=2000;
        objItem.quantidadeExpedida=2000;
        objItem.transportadora=criaTransportadora();
        objItem.tipoItemPedido='o5';
        objItem.paraPresente=false;
        objItem.CTF=1030;
        objItem.custoInventario=400;
        objItem.custoGerencial=400;
        objItem.custoFiscalUltimaNotaCompra=400;
        objItem.custoTecnico=400;
        objItem.tipoDeposito='TED';
        objItem.aliquotaICMS=2000;
        objItem.aliquotaICMSSubstituicaoTributaria=2000;
        objItem.aliquotaICMSReducaoBase=2000;
        objItem.valorIPI=2000;
        objItem.percentualIPI=2000;
        objItem.valorFrete=2000;
        objItem.precoUnitarioLiquido=2000;
        objItem.aliquotaInternaICMSSubstituicaoTributaria=2000;
        objItem.valorDesconto=2000;
        objItem.valorBaseCalculoICMSSubstituicaoTributaria=2000;
        objItem.valorICMS=2000;
        objItem.valorICMSRetido=2000;
        objItem.valorDespesasRateadas=2000;
        objItem.valorTotalItem=2000;
        objItem.valorOutrasDespesas=2000;
        objItem.valorTotalBaseCalculoIPI=2000;
        objItem.precoTabela=2000;
        objItem.valorRebatido=2000;
        objItem.taxaRebateItem=2000;
        objItem.percentualComissaoForaDeLinha=2000;
        objItem.valorComissaoForaDeLinha=2000;
        objItem.valorAcrescimo=2000;
        objItem.slip=criaStatusSlip();
        objItem.notaFiscalSaida=criaNotaFiscal();
        objItem.pedidoGemco=criaGemco();
        
        
        arIP.add(objItem);
        return arIP;
    }
    private static wsdlMagazine.PedidoGemco criaGemco(){
        wsdlMagazine.PedidoGemco gemco = new wsdlMagazine.PedidoGemco();
        gemco.id = '10';
        gemco.notaFiscalSaida = criaNotaFiscal();
        gemco.slip=criaStatusSlip();
        gemco.transportadora=criaTransportadora();
        return gemco;
    }
    private static wsdlMagazine.Slip criaStatusSlip(){
        wsdlMagazine.Slip objSlip = new wsdlMagazine.Slip();
        objSlip.id=10;
        wsdlMagazine.StatusSlip ss = new wsdlMagazine.StatusSlip();
        ss.descricao='Finalizado';
        ss.id='20';
        objSlip.statusSlip=ss;
        return objSlip;
    }
    private static wsdlMagazine.NotaFiscalSaida criaNotaFiscal(){
        wsdlMagazine.NotaFiscalSaida nota = new wsdlMagazine.NotaFiscalSaida();
        nota.id=10;
        nota.codPedidoGemco=1010;
        nota.chaveAcesso='102010';
        nota.tipo=2;
        nota.data=datetime.now();
        nota.filial=10;
        nota.serie='20';
        return nota;
        
    }
    private static wsdlMagazine.Produto criaProduto(){
        wsdlMagazine.Produto Prod = new wsdlMagazine.Produto();
        Prod.id='10';
        Prod.idSite='10';
        Prod.digito=15;
        Prod.descricao='desc';
        Prod.descricaoReduzida='desc';
        wsdlMagazine.Fornecedor forn = new wsdlMagazine.Fornecedor();
        forn.empresa = criaEmpresa();
        prod.fornecedor = forn;
        
        wsdlMagazine.Linha line = new wsdlMagazine.Linha();
        line.id='30';
        line.descricao='teste ';
        Prod.linha=line;

        wsdlMagazine.Familia fam = new wsdlMagazine.Familia();
        fam.id='30';
        fam.descricao='teste ';
        Prod.familia=fam;

        wsdlMagazine.Grupo grou = new wsdlMagazine.Grupo();
        grou.id='30';
        grou.descricao='teste ';
        Prod.grupo=grou;
        
        wsdlMagazine.Subgrupo subgrou = new wsdlMagazine.Subgrupo();
        subgrou.id='30';
        subgrou.descricao='teste ';
        Prod.subgrupo=subgrou;
        
        wsdlMagazine.Capacidade cap = new wsdlMagazine.Capacidade();
        cap.id='30';
        cap.descricao='teste ';
        Prod.capacidade=cap;
        
        wsdlMagazine.Modelo mod = new wsdlMagazine.Modelo();
        mod.id='30';
        mod.descricao='teste ';
        Prod.modelo=mod;
        
        wsdlMagazine.Especificacao esp = new wsdlMagazine.Especificacao();
        esp.id=30;
        esp.descricao='teste ';
        esp.descricaoReduzida='teste';
        Prod.especificacao=esp;
        
        wsdlMagazine.Cor color = new wsdlMagazine.Cor();
        color.id=30;
        color.descricao='teste ';
        color.descricaoReduzida='teste';
        Prod.cor=color;
        
        Prod.pesoBruto=criaUnidadeMedida();
        Prod.pesoLiquido=criaUnidadeMedida();
        Prod.quantidadeVolumes=10;
        Prod.passivelMontagem=false;
        return Prod;
    }
    private static wsdlMagazine.ValorUnidadeMedida criaUnidadeMedida(){
        wsdlMagazine.ValorUnidadeMedida vl = new wsdlMagazine.ValorUnidadeMedida();
        vl.unidade='20';
        return vl;
        
    }
    private static wsdlMagazine.Transportadora criaTransportadora(){
        wsdlMagazine.Transportadora transp = new wsdlMagazine.Transportadora();
        transp.id=30;
        transp.empresa=criaEmpresa();
        return transp;
        
    }
    private static wsdlMagazine.PessoaFisica criaPessoa(){
        wsdlMagazine.PessoaFisica PF = new wsdlMagazine.PessoaFisica();
        /*Cria a Pessoa*/
        
        PF.id=10;
        PF.CPF='06375160448';
        PF.nome='Teste de cadastro';
        PF.apelido='TC';
        PF.identificacaoCliente='Cliente';
        PF.rendaIndividual=10.0;
        PF.dataNascimento=datetime.now();
        PF.sexo='M';
        wsdlMagazine.EstadoCivil ec = new wsdlMagazine.EstadoCivil();
        ec.id=10;
        ec.descricao='Solteiro';
        PF.estadoCivil=ec;
        PF.naturezaProfissional='Analista';
        /*=============*/
        return PF;
    }
    private static wsdlMagazine.Empresa criaEmpresa(){
        /*Cria a empresa*/
                wsdlMagazine.Empresa emp = new wsdlMagazine.Empresa();
                Emp.id=10;
                Emp.cnpj='82668118000157';
                Emp.razaoSocial='Teste';
                Emp.nomeFantasia='wsEmpresa.nomeFantasia';
                Emp.ramoAtividade='wsEmpresa.ramoAtividade';
                Emp.apelido='wsEmpresa.apelido';
                Emp.identificacaoEmpresa='10';
                /*================*/
        return Emp;
        
    }
    
      public static wsdlMagazine.Result CriaObjetos(){
       		wsdlMagazine.Result resultado = new wsdlMagazine.Result();
    		wsdlMagazine.Cliente sarrcont = new wsdlMagazine.Cliente();
             List<wsdlMagazine.Cliente> cli = new List<wsdlMagazine.Cliente>(); 
            try{
				sarrcont.id=10;
                sarrcont.clienteOuro='S';
                sarrcont.email='teste@teste.com.br';
                sarrcont.origemSite=true;
                sarrcont.origemLojaFisica=false;
                sarrcont.empresa=criaEmpresa();
                sarrcont.pessoaFisica=criaPessoa();
                sarrcont.endereco = criaEndereco();
                wsdlMagazine.Inscricao ins = new wsdlMagazine.Inscricao();
                ins.inscricao='INSC';
                ins.tipo='INSC';
                sarrcont.inscricao=ins;
                sarrcont.telefonePrincipal = criaTelefone();
                sarrcont.telefoneComercial = criaTelefone();
                sarrcont.telefoneCelular = criaTelefone();
                sarrcont.pedido = criaPedido();
                cli.add(sarrcont);
            }
            catch(Exception ex){
        				System.debug('Erro encontrato aquiiiiiiiiii: ' + ex.getMessage());
        			}
       			
       		resultado.clientes=cli;
       		wsdlMagazine.MensagemRetorno mensagem = new wsdlMagazine.MensagemRetorno();
       		mensagem.id=0;
       		mensagem.descricao='Sucesso na comunicação';
       		mensagem.parametroExtra='0';
            resultado.result=mensagem;
       
           return resultado;
   }
}