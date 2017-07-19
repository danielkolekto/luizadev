public class clsSincronizarMagazine {
	/*
	1 = CPF
	2 = Email
	3 = Número do Pedido ADM Site
	4 = Número do Pedido ADM GEMCO
	*/ 
    //public class clsSincronizarMagazine{}
    public clsSincronizarMagazine(){}
	public  Cliente RetornoCliente (String tipoChave,String ValorChave){
		wsdlMagazine.ClienteConsultaFacadeImplPortBindingQSPort Conectar = new  wsdlMagazine.ClienteConsultaFacadeImplPortBindingQSPort();
		wsdlMagazine.Result Resultado = new wsdlMagazine.Result();
       clsSincronizarMagazine.Cliente ResultadoFinal = new clsSincronizarMagazine.Cliente();
         Map<String,String> Chamada = new Map<String,String>();
            chamada.put('Authorization', 'Bearer kv5CxwrbL7OpVcT5MmbryqY1sUEk');
            //chamada.put('Authorization', 'Bearer lALLKvFUVZQggKQV3rgUOJnBeKmn');
            conectar.inputHttpHeaders_x=chamada;
           //conectar.endpoint_x='http://magazineluiza-test.apigee.net/v1/vendasclienteconsulta';
       	
		if(tipoChave=='1'){
            valorChave=valorChave.replace('.','');
            valorChave=valorChave.replace('-','');
            valorChave=valorChave.replace('/','');
			Resultado = Conectar.findClienteSamsungByCpfCnpj(valorChave);
		}
		else if(tipoChave=='2'){
			Resultado = Conectar.findClienteSamsungByEmail(ValorChave);
		}		else if (tipoChave=='3'){
            //wsdlMagazine.findClienteSamsungByCodigoPedidoSite
            // conectar.endpoint_x='https://api.apiluiza.com.br/v1/vendasclienteconsulta';
			//Resultado =  Conectar.findClienteSamsungByCodigoPedidoSite(valorchave);
			Resultado = Conectar.findClienteSamsungByCodigoPedidoSite(valorchave);
            //Resultado = wsdlMagazine.findClienteSamsungByCodigoPedidoSite(valorchave);
           
		}
		else if (tipoChave=='4'){
			Resultado = Conectar.findClienteSamsungByCodigoPedidoGemco(ValorChave);
		}
        
        if(Resultado != null){
            //Varre o resultado retornado;
            if(Resultado.clientes!=null	){
                for (wsdlMagazine.Cliente Cli : Resultado.clientes){
                	if (cli.pessoaFisica == null && cli.Empresa == null){
                		ResultadoFinal.CodRetorno='45';
			            ResultadoFinal.Mensagem='Cadastro não localizado';
			            return ResultadoFinal;
                	}
                	else{
		            	ResultadoFinal = TrataRetorno(cli);
                	}
                }
            }
            else{
                ResultadoFinal.CodRetorno='45';
                ResultadoFinal.Mensagem='Cadastro não localizado';
                return ResultadoFinal;
                
            }
            ResultadoFinal.CodRetorno=String.valueof(Resultado.result.id);
            ResultadoFinal.Mensagem=Resultado.result.descricao;
            
            
        }
        //System.debug('O valor de Resultado Final id é: ' + String.valueof(ResultadoFinal.CodRetorno));
		return ResultadoFinal;
	}
    
    private Cliente TrataRetorno(wsdlMagazine.Cliente cli){
        Cliente ResultadoFinal = new Cliente();
        
                //Captura as informações de pessoa;
                wsdlMagazine.PessoaFisica PessoaF = new wsdlMagazine.PessoaFisica();
                PessoaF = Cli.pessoaFisica;
                
                //Captura a situação civil
                wsdlMagazine.EstadoCivil EstadoPessoa = new wsdlMagazine.EstadoCivil();
                if(PessoaF!=null){
                	EstadoPessoa = PessoaF.estadoCivil;
                	ResultadoFinal.CPF = PessoaF.CPF;
	                ResultadoFinal.nome = PessoaF.nome;
	                ResultadoFinal.apelido = PessoaF.apelido;
	                ResultadoFinal.identificacaoCliente = PessoaF.identificacaoCliente;
	                ResultadoFinal.rendaIndividual = PessoaF.rendaIndividual;
	                ResultadoFinal.dataNascimento = PessoaF.dataNascimento;
	                ResultadoFinal.sexo = PessoaF.sexo;	
	                if(EstadoPessoa!=null){
	                	ResultadoFinal.estadocivil = EstadoPessoa.descricao;
	                }
	                ResultadoFinal.naturezaProfissional = PessoaF.naturezaProfissional;
                }
                //Captura as informações de Endereco
                
                 wsdlMagazine.Endereco EnderecoPessoa = new wsdlMagazine.Endereco();
                 
                EnderecoPessoa = cli.endereco;
                //Captura as informações do cliente
                ResultadoFinal.id = cli.id;
        		if(cli.Empresa!=null){
                	ResultadoFinal.empresaTrab  =  CriaEmpresa(cli.Empresa);
            	}
                
                ResultadoFinal.clienteOuro = cli.clienteOuro;
                ResultadoFinal.tipoLogradouro=EnderecoPessoa.tipoLogradouro;
                ResultadoFinal.endereco=EnderecoPessoa.endereco;
                ResultadoFinal.numero=EnderecoPessoa.numero;
                ResultadoFinal.complemento=EnderecoPessoa.complemento;
                ResultadoFinal.bairro=EnderecoPessoa.bairro;
                ResultadoFinal.cidade=EnderecoPessoa.cidade;
                ResultadoFinal.estado=EnderecoPessoa.estado;
                ResultadoFinal.pais=EnderecoPessoa.pais;
                ResultadoFinal.CEP=EnderecoPessoa.CEP;
                ResultadoFinal.dataAtualizacaoEndereco = EnderecoPessoa.dataAtualizacao;
                
                if (cli.telefonePrincipal != null){
                	ResultadoFinal.telefonePrincipal = CriaTelefone(cli.telefonePrincipal);
                }
        		if(cli.telefoneCelular!=null){
					ResultadoFinal.telefoneCelular= CriaTelefone(cli.telefoneCelular);
            	}
        		if(cli.telefoneComercial!=null){
					ResultadoFinal.telefoneComercial= CriaTelefone(cli.telefoneComercial);
            	}
        		resultadoFinal.origemSite = cli.origemSite;
        		//resultadoFinal.origemSite = cli.origemLojaFisica;
        if(cli.pedido!=null){
        		resultadoFinal.pedido = RetornaPedidos(cli.pedido);
            }
        
        return ResultadoFinal;
    }
    private String RetornaCPF(wsdlMagazine.Cliente cli){
		String CPF = cli.pessoaFisica.CPF;
		return CPF;
	}
	
	private String RetornaVendedor(wsdlMagazine.Vendedor vend){
		String numeroPDV = vend.numeroPDV;
		return numeroPDV;
	}
	
	private String RetornaCNPJFilial(wsdlMagazine.Filial fili){
		wsdlMagazine.Empresa emp= fili.Empresa;
		String CNPJ = emp.cnpj;
		return CNPJ;
	}
	
    private List<Pedido>  RetornaPedidos(wsdlMagazine.Pedido[] wsPedidos){
        List<Pedido> arPedido = new List<Pedido>();
        for(wsdlMagazine.Pedido fPedido : wsPedidos){
            Pedido ped = new Pedido();
			ped.id = fPedido.id;
			ped.notaFiscal= fPedido.notaFiscal;
			ped.tipoPedido= fPedido.tipoPedido;
			ped.numeroVolumes= fPedido.numeroVolumes;
			ped.idPedidoPrincipal= fPedido.idPedidoPrincipal;
            if(fPedido.cliente!=null){
				ped.ClienteCPF= RetornaCPF(fPedido.cliente);
            }
            /*if(fPedido.clientePresenteado != null){
				ped.clientePresenteadoCPF= RetornaCPF(fPedido.clientePresenteado);
            }
            if(fPedido.Vendedor!=null){
				ped.vendedorNumeroPDV= RetornaVendedor(fPedido.Vendedor);
            }
            if(fPedido.filialVenda!=null){
				ped.filialVendaCNPJ= RetornaCNPJFilial(fPedido.filialVenda);
            }
            if(fPedido.filialSaida!=null){
				ped.filialSaidaCNPJ= RetornaCNPJFilial(fPedido.filialSaida);
            }*/
			ped.tipoPagamento= fPedido.tipoPagamento;
			ped.condicaoPagamento= fPedido.condicaoPagamento;
			ped.quantidadeParcelas= fPedido.quantidadeParcelas;
			ped.data = fPedido.data;
			ped.dataEntrada= fPedido.dataEntrada;
			ped.dataCancelamento= fPedido.dataCancelamento;
			ped.dataLiberacaoCredito= fPedido.dataLiberacaoCredito;
			ped.dataLiberacaoParaFaturamento= fPedido.dataLiberacaoParaFaturamento;
			ped.dataFaturamento= fPedido.dataFaturamento;
			ped.dataPrevistaEntrega= fPedido.dataPrevistaEntrega;
			ped.tipoEntrega= fPedido.tipoEntrega;
            if(fPedido.modalidadefrete!=null){
				ped.modalidadeFrete= fPedido.modalidadefrete.descricao;
            }
			ped.dataEntrega= fPedido.dataEntrega;
			ped.dataEntregaAgendada= fPedido.dataEntregaAgendada;
			ped.turnoEntregaAgendada= fPedido.turnoEntregaAgendada;
			ped.tipoLogradouroEnderecoEntrega= fPedido.enderecoEntrega.tipoLogradouro;
			ped.EnderecoEntrega= fPedido.enderecoEntrega.Endereco;
			ped.numeroEnderecoEntrega= fPedido.enderecoEntrega.numero;
			ped.complementoEnderecoEntrega= fPedido.enderecoEntrega.complemento;
			ped.bairroEnderecoEntrega= fPedido.enderecoEntrega.bairro;
			ped.cidadeEnderecoEntrega= fPedido.enderecoEntrega.cidade;
			ped.estadoEnderecoEntrega= fPedido.enderecoEntrega.estado;
			ped.paisEnderecoEntrega= fPedido.enderecoEntrega.pais;
			ped.CEPEnderecoEntrega= fPedido.enderecoEntrega.CEP;
			/*
            if(fPedido.enderecoEntregaPresente!=null){
                ped.tipoLogradouroEntregaPresente= fPedido.enderecoEntregaPresente.tipoLogradouro;
                ped.enderecoEntregaPresente= fPedido.enderecoEntregaPresente.endereco;
                ped.numeroEntregaPresente= fPedido.enderecoEntregaPresente.numero;
                ped.complementoEntregaPresente= fPedido.enderecoEntregaPresente.complemento;
                ped.bairroEntregaPresente= fPedido.enderecoEntregaPresente.bairro;
                ped.cidadeEntregaPresente= fPedido.enderecoEntregaPresente.cidade;
                ped.estadoEntregaPresente= fPedido.enderecoEntregaPresente.estado;
                ped.paisEntregaPresente= fPedido.enderecoEntregaPresente.pais;
                ped.CEPEntregaPresente= fPedido.enderecoEntregaPresente.CEP;
            }*/
            if(fPedido.transportadora!=null){
				ped.transportadoraPedido= fPedido.transportadora.Empresa.cnpj;
            }
            if(fPedido.rota!=null){
				ped.rota= fPedido.rota.descricao;
            }
			ped.retiraNaLoja= fPedido.retiraNaLoja;
			ped.valorMercadoria= fPedido.valorMercadoria;
			ped.valorJuros= fPedido.valorJuros;
			ped.valorEntrada= fPedido.valorEntrada;
			ped.valorFrete= fPedido.valorFrete;
			ped.valorMercado= fPedido.valorMercado;
			ped.valorJurosFinanceiros= fPedido.valorJurosFinanceiros;
			ped.valorTotal= fPedido.valorTotal;
			ped.valorTotalIndexado= fPedido.valorTotalIndexado;
			ped.valorVendaVista= fPedido.valorVendaVista;
			ped.valorVendaLiquida= fPedido.valorVendaLiquida;
			ped.valorParcela= fPedido.valorParcela;
			ped.valorRebatido= fPedido.valorRebatido;
			ped.percentualJuros= fPedido.percentualJuros;
			ped.taxaJurosRebate= fPedido.taxaJurosRebate;
			ped.SituacaoPedidoId= fPedido.situacao.id;
			ped.SituacaoPedido= fPedido.situacao.descricao;
			ped.origem= fPedido.origem;
			ped.listaCasamento= fPedido.listaCasamento;
			ped.flagCancelamento= fPedido.flagCancelamento;
			ped.flagTroca= fPedido.flagTroca;
			ped.numeroPedidoControle= fPedido.numeroPedidoControle;
            ped.itens = RetornaItempedido(fpedido.Item);
            
            for (clsSincronizarMagazine.ItemPedido itemPed : ped.itens){
            	if (itemPed.pedidoGemcoItem != null && itemPed.pedidoGemcoItem.id == null && fPedido.pedidosGeradosGemco != null && fPedido.pedidosGeradosGemco.size() > 0){
            		itemPed.pedidoGemcoItem.id = String.valueOf(fPedido.pedidosGeradosGemco[0]);
                    system.debug('itemPed.pedidoGemcoItem.id: ' + itemPed.pedidoGemcoItem.id);
            	}
            }
            
			arPedido.add(ped);
        }
        return arPedido;
    }
   private List<ItemPedido> RetornaItemPedido(List<wsdlMagazine.ItemPedido> wsItemPedido){
	   List<ItemPedido> arItemPedido = new List<ItemPedido>();
	   for(wsdlMagazine.ItemPedido item : wsItemPedido){
		   ItemPedido itemP = new ItemPedido();
		   itemP.id=item.id;
		itemP.numeroSerieProduto = item.numeroSerieProduto ;
		itemP.precoUnitario= item.precoUnitario;
		itemP.precoOriginal= item.precoOriginal;
		itemP.quantidadeSolicitada= item.quantidadeSolicitada;
		itemP.quantidadeExpedida= item.quantidadeExpedida;
           if(item.transportadora!=null){
				itemP.transportadoraItemCNPJ= item.transportadora.Empresa.CNPJ;
             }
		itemP.tipoItemPedido= item.tipoItemPedido;
		itemP.paraPresente= item.paraPresente;
		itemP.CTF= item.CTF;
		itemP.custoInventario= item.custoInventario;
		itemP.custoGerencial= item.custoGerencial;
		itemP.custoFiscalUltimaNotaCompra= item.custoFiscalUltimaNotaCompra;
		itemP.custoTecnico= item.custoTecnico;
		itemP.tipoDeposito= item.tipoDeposito;
		itemP.aliquotaICMS= item.aliquotaICMS;
		itemP.aliquotaICMSSubstituicaoTributaria= item.aliquotaICMSSubstituicaoTributaria;
		itemP.aliquotaICMSReducaoBase= item.aliquotaICMSReducaoBase;
		itemP.valorIPI= item.valorIPI;
		itemP.percentualIPI= item.percentualIPI;
		itemP.valorFrete= item.valorFrete;
		itemP.precoUnitarioLiquido= item.precoUnitarioLiquido;
		itemP.aliquotaInternaICMSSubstituicaoTributaria= item.aliquotaInternaICMSSubstituicaoTributaria;
		itemP.valorDesconto= item.valorDesconto;
		itemP.valorBaseCalculoICMSSubstituicaoTributaria= item.valorBaseCalculoICMSSubstituicaoTributaria;
		itemP.valorICMS= item.valorICMS;
		itemP.valorICMSRetido= item.valorICMSRetido;
		itemP.valorDespesasRateadas= item.valorDespesasRateadas;
		itemP.valorTotalItem= item.valorTotalItem;
		itemP.valorOutrasDespesas= item.valorOutrasDespesas;
		itemP.valorTotalBaseCalculoIPI= item.valorTotalBaseCalculoIPI;
		itemP.precoTabela= item.precoTabela;
		itemP.valorRebatido= item.valorRebatido;
		itemP.taxaRebateItem= item.taxaRebateItem;
		itemP.percentualComissaoForaDeLinha= item.percentualComissaoForaDeLinha;
		itemP.valorComissaoForaDeLinha= item.valorComissaoForaDeLinha;
		itemP.valorAcrescimo= item.valorAcrescimo;
		itemP.IdSlip= item.slip.id;
        if(item.slip.statusSlip !=null){   
			itemP.StatusSlip= item.slip.statusSlip.descricao;
		}
           if(item.notafiscalsaida!=null){
        itemp.notaFiscalSaida=CriaNotaFiscal(item.notafiscalsaida);
               }
           if(item.pedidogemco!=null){
		itemp.pedidoGemcoItem=CriaPedidoGemo(item.pedidogemco);
               }
		itemp.Itemproduto=criaProduto(item.Produto);
		arItemPedido.add(itemp);
	   }
	   
	   return arItemPedido;
	   
   }
   
   
    private Produto criaProduto(wsdlMagazine.Produto wsProduto){
        Produto prod = new Produto();
		prod.id=wsProduto.id;
		prod.idSite=wsProduto.idSite;
		prod.digito=wsProduto.digito;
		prod.descricao=wsProduto.descricao;
		prod.descricaoReduzida=wsProduto.descricaoReduzida;
		prod.linha=wsProduto.linha.descricao;
		prod.Familia=wsProduto.Familia.descricao;
        if(wsProduto.Grupo!=null){
		prod.Grupo=wsProduto.Grupo.descricao;
            }
        if(wsProduto.Subgrupo!=null){
		prod.Subgrupo=wsProduto.Subgrupo.descricao;
            }
        if(wsProduto.capacidade!=null){
		prod.capacidade=wsProduto.capacidade.descricao;
        }
            if(wsProduto.modelo!=null){
		prod.modelo=wsProduto.modelo.descricao;
            }
                if(wsProduto.especificacao!=null){
		prod.especificacao=wsProduto.especificacao.descricao;
                }
                    if(wsProduto.cor!=null){
		prod.cor=wsProduto.cor.descricao;
                    }
        if(wsProduto.fornecedor.Empresa.CNPJ!=null){
			prod.CNPJFornecedor=wsProduto.fornecedor.Empresa.CNPJ;
        }
        if(wsProduto.Subgrupo!=null){
		prod.pesoBruto=wsProduto.pesoBruto.Unidade;
        }
        if(wsProduto.pesoLiquido!=null){
		prod.pesoLiquido=wsProduto.pesoLiquido.unidade;
        }
        if(wsProduto.quantidadeVolumes!=null){
		prod.quantidadeVolumes=wsProduto.quantidadeVolumes;
        }
            if(wsProduto.passivelMontagem!=null){
		prod.passivelMontagem=wsProduto.passivelMontagem;
            }
                if(wsProduto.tipoProduto!=null){
		prod.tipoProduto=wsProduto.tipoProduto.descricao;
                }
        return prod;
    }
   
   
   private PedidoGemco CriaPedidoGemo(wsdlMagazine.PedidoGemco wsPedidoGemco){
        PedidoGemco gemco = new PedidoGemco();
       	system.debug('Pedido Gemco: ' + wsPedidoGemco.id);
		gemco.id=wsPedidoGemco.id;
		gemco.IdSlip=wsPedidoGemco.Slip.id;
       if(wsPedidoGemco.slip.StatusSlip!=null){
		gemco.StatusSlip=wsPedidoGemco.slip.StatusSlip.descricao;
           }
       if(wsPedidoGemco.NotaFiscalSaida!=null){
			gemco.notaFiscalSaida=crianotafiscal(wsPedidoGemco.NotaFiscalSaida);
        }
        return gemco;
    }
   
   
   private NotaFiscal CriaNotaFiscal(wsdlMagazine.NotaFiscalSaida wsNotaFiscalSaida){
        NotaFiscal nota = new NotaFiscal();
       nota.id = (wsNotaFiscalSaida.id != null ? wsNotaFiscalSaida.id : 0);
		nota.codPedidoGemco = (wsNotaFiscalSaida.codPedidoGemco != null ? wsNotaFiscalSaida.codPedidoGemco : 0);
		nota.chaveAcesso = (wsNotaFiscalSaida.chaveAcesso != null ? wsNotaFiscalSaida.chaveAcesso : '');
		nota.tipo = (wsNotaFiscalSaida.tipo != null ? wsNotaFiscalSaida.tipo : 0);
		nota.data = (wsNotaFiscalSaida.data != null ? wsNotaFiscalSaida.data : null);
		nota.filial = (wsNotaFiscalSaida.filial != null ? wsNotaFiscalSaida.filial : 0);
		nota.serie = (wsNotaFiscalSaida.serie != null ? wsNotaFiscalSaida.serie : '');
        return nota;
    }
   
    private Empresa CriaEmpresa(wsdlMagazine.Empresa wsEmpresa){
        Empresa Emp = new Empresa();
        Emp.id=wsEmpresa.id;
		Emp.cnpj=wsEmpresa.cnpj;
		Emp.razaoSocial=wsEmpresa.razaoSocial;
		Emp.nomeFantasia=wsEmpresa.nomeFantasia;
		Emp.ramoAtividade=wsEmpresa.ramoAtividade;
		Emp.apelido=wsEmpresa.apelido;
		Emp.identificacaoEmpresa=wsEmpresa.identificacaoEmpresa;
        return Emp;
    }
    
    private Telefone CriaTelefone(wsdlMagazine.Telefone wsTelefone){
        Telefone tel = new Telefone();
		tel.codigoPais = wsTelefone.codigoPais;
		tel.codigoArea= wsTelefone.codigoArea;
		tel.fone= wsTelefone.fone;
		tel.ramal= wsTelefone.ramal;
        return tel;
    }
	/*
	Classes para tratamento de sincronização
	*/
	public class Cliente{
        public String Mensagem{get;set;}
        public String CodRetorno{get;set;}
        public Integer id{get;set;}
		public Empresa empresaTrab{get;set;}
		public String CPF{get;set;}
		public String nome{get;set;}
		public String apelido{get;set;}
		public String identificacaoCliente{get;set;}
		public Decimal rendaIndividual{get;set;}
		public DateTime dataNascimento{get;set;}
		public String sexo{get;set;}
		public String EstadoCivil{get;set;}
		public String naturezaProfissional{get;set;}
		public String clienteOuro{get;set;}
		public String tipoLogradouro{get;set;}
		public String endereco{get;set;}
		public String numero{get;set;}
		public String complemento{get;set;}
		public String bairro{get;set;}
		public String cidade{get;set;}
		public String estado{get;set;}
		public String pais{get;set;}
		public String CEP{get;set;}
		public DateTime dataAtualizacaoEndereco{get;set;}
		public Telefone telefonePrincipal{get;set;}
		public Telefone telefoneCelular{get;set;}
		public Telefone telefoneComercial{get;set;}
		public String email{get;set;}
		public Boolean origemSite{get;set;}
		public Boolean origemLojaFisica{get;set;}
        public List<Pedido> pedido{get;set;}
	}
	public class Empresa{
		public Integer id{get;set;}
		public String cnpj{get;set;}
		public String razaoSocial{get;set;}
		public String nomeFantasia{get;set;}
		public String ramoAtividade{get;set;}
		public String apelido{get;set;}
		public String identificacaoEmpresa{get;set;}
	}
	public class Telefone {
		public String codigoPais{get;set;}
		public String codigoArea{get;set;}
		public String fone{get;set;}
		public String ramal{get;set;}
	}
	public class Transportadora {
		public Integer id{get;set;}
		public Empresa empresaTrans{get;set;}
	}
	public class Produto {
		public String id{get;set;}
		public String idSite{get;set;}
		public Integer digito{get;set;}
		public String descricao{get;set;}
		public String descricaoReduzida{get;set;}
		public String linha{get;set;}
		public String Familia{get;set;}
		public String Grupo{get;set;}
		public String Subgrupo{get;set;}
		public String capacidade{get;set;}
		public String modelo{get;set;}
		public String especificacao{get;set;}
		public String cor{get;set;}
		public String CNPJFornecedor{get;set;}
		public String pesoBruto{get;set;}
		public String pesoLiquido{get;set;}
		public Integer quantidadeVolumes{get;set;}
		public Boolean passivelMontagem{get;set;}
		public String tipoProduto{get;set;}
        public Boolean Selected {get;set;}
	}
	public class Embalagem {
		public String id{get;set;}
		public Integer quantidadeUnidades{get;set;}
		public String unidade{get;set;}
		public Boolean preferencial{get;set;}
		public String altura{get;set;}
		public String largura{get;set;}
		public String comprimento{get;set;}
		public String codigoBarra{get;set;}
	}
	public class NotaFiscal {
		public Integer id{get;set;}
		public Integer codPedidoGemco{get;set;}
		public String chaveAcesso{get;set;}
		public Integer tipo{get;set;}
		public DateTime data{get;set;}
		public Integer filial{get;set;}
		public String serie{get;set;}
	}
	public class PedidoGemco {
		public String id{get;set;}
		public Integer IdSlip{get;set;}
		public String StatusSlip{get;set;}
		public NotaFiscal notaFiscalSaida{get;set;}
        public Boolean Selected {get;set;}
	}
	public class ItemPedido {
		public Integer id{get;set;}
		public String numeroSerieProduto{get;set;}
		public Decimal precoUnitario{get;set;}
		public Decimal precoOriginal{get;set;}
		public Decimal quantidadeSolicitada{get;set;}
		public Decimal quantidadeExpedida{get;set;}
		public String transportadoraItemCNPJ{get;set;}
		public String tipoItemPedido{get;set;}
		public Boolean paraPresente{get;set;}
		public Integer CTF{get;set;}
		public Decimal custoInventario{get;set;}
		public Decimal custoGerencial{get;set;}
		public Decimal custoFiscalUltimaNotaCompra{get;set;}
		public Decimal custoTecnico{get;set;}
		public String tipoDeposito{get;set;}
		public Decimal aliquotaICMS{get;set;}
		public Decimal aliquotaICMSSubstituicaoTributaria{get;set;}
		public Decimal aliquotaICMSReducaoBase{get;set;}
		public Decimal valorIPI{get;set;}
		public Decimal percentualIPI{get;set;}
		public Decimal valorFrete{get;set;}
		public Decimal precoUnitarioLiquido{get;set;}
		public Decimal aliquotaInternaICMSSubstituicaoTributaria{get;set;}
		public Decimal valorDesconto{get;set;}
		public Decimal valorBaseCalculoICMSSubstituicaoTributaria{get;set;}
		public Decimal valorICMS{get;set;}
		public Decimal valorICMSRetido{get;set;}
		public Decimal valorDespesasRateadas{get;set;}
		public Decimal valorTotalItem{get;set;}
		public Decimal valorOutrasDespesas{get;set;}
		public Decimal valorTotalBaseCalculoIPI{get;set;}
		public Decimal precoTabela{get;set;}
		public Decimal valorRebatido{get;set;}
		public Decimal taxaRebateItem{get;set;}
		public Decimal percentualComissaoForaDeLinha{get;set;}
		public Decimal valorComissaoForaDeLinha{get;set;}
		public Decimal valorAcrescimo{get;set;}
		public Integer IdSlip{get;set;}
		public String StatusSlip{get;set;}
		public NotaFiscal notaFiscalSaida{get;set;}
		public PedidoGemco pedidoGemcoItem{get;set;}
		public Produto Itemproduto{get;set;}
        public Boolean Selected {get;set;}
	}
	public class pedido {
		public String id{get;set;}
		public String notaFiscal{get;set;}
		public Integer tipoPedido{get;set;}
		public Integer numeroVolumes{get;set;}
		public Integer idPedidoPrincipal{get;set;}
		public String ClienteCPF{get;set;}
		public String clientePresenteadoCPF{get;set;}
		public String vendedorNumeroPDV{get;set;}
		public String filialVendaCNPJ{get;set;}
		public String filialSaidaCNPJ{get;set;}
		public String tipoPagamento{get;set;}
		public String condicaoPagamento{get;set;}
		public Integer quantidadeParcelas{get;set;}
		public DateTime data{get;set;}
		public DateTime dataEntrada{get;set;}
		public DateTime dataCancelamento{get;set;}
		public DateTime dataLiberacaoCredito{get;set;}
		public DateTime dataLiberacaoParaFaturamento{get;set;}
		public DateTime dataFaturamento{get;set;}
		public DateTime dataPrevistaEntrega{get;set;}
		public String tipoEntrega{get;set;}
		public String modalidadeFrete{get;set;}
		public DateTime dataEntrega{get;set;}
		public DateTime dataEntregaAgendada{get;set;}
		public String turnoEntregaAgendada{get;set;}
		public String tipoLogradouroEnderecoEntrega{get;set;}
		public String EnderecoEntrega{get;set;}
		public String numeroEnderecoEntrega{get;set;}
		public String complementoEnderecoEntrega{get;set;}
		public String bairroEnderecoEntrega{get;set;}
		public String cidadeEnderecoEntrega{get;set;}
		public String estadoEnderecoEntrega{get;set;}
		public String paisEnderecoEntrega{get;set;}
		public String CEPEnderecoEntrega{get;set;}
		public String tipoLogradouroEntregaPresente{get;set;}
		public String enderecoEntregaPresente{get;set;}
		public String numeroEntregaPresente{get;set;}
		public String complementoEntregaPresente{get;set;}
		public String bairroEntregaPresente{get;set;}
		public String cidadeEntregaPresente{get;set;}
		public String estadoEntregaPresente{get;set;}
		public String paisEntregaPresente{get;set;}
		public String CEPEntregaPresente{get;set;}
		public String transportadoraPedido{get;set;}
		public String rota{get;set;}
		public Boolean retiraNaLoja{get;set;}
		public Decimal valorMercadoria{get;set;}
		public Decimal valorJuros{get;set;}
		public Decimal valorEntrada{get;set;}
		public Decimal valorFrete{get;set;}
		public Decimal valorMercado{get;set;}
		public Decimal valorJurosFinanceiros{get;set;}
		public Decimal valorTotal{get;set;}
		public Decimal valorTotalIndexado{get;set;}
		public Decimal valorVendaVista{get;set;}
		public Decimal valorVendaLiquida{get;set;}
		public Decimal valorParcela{get;set;}
		public Decimal valorRebatido{get;set;}
		public Decimal percentualJuros{get;set;}
		public Decimal taxaJurosRebate{get;set;}
		public Integer SituacaoPedidoId{get;set;}
		public String SituacaoPedido{get;set;}
		public Integer origem{get;set;}
		public Boolean listaCasamento{get;set;}
		public Boolean flagCancelamento{get;set;}
		public Boolean flagTroca{get;set;}
		public Integer numeroPedidoControle{get;set;}
        public List<ItemPedido> itens{get;set;}
        public Boolean Selected {get;set;}
	}
	/*********************************************/
}