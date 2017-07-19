/**
*	@author Diego Moreira
*	@class Classe de negocio para leitura do dados de integração 
*/
public class MktPlace_ProductInboundIntegrationBO {
	/**
	* 	Cria os dados do produto do caso 
	*	@param objProductList Lista de objeto contendo os atributos do produto
	*/
	public static void caseProduct( List<Object> objProductList, String idCase ) {
		List<CaseProduct__c> caseProductToInsert = new List<CaseProduct__c>();

		for( Object objResult : objProductList ) {
            Map<String, Object> mapProduct = ( Map<String, Object> ) objResult;

            CaseProduct__c caseProduct = new CaseProduct__c();
            caseProduct.Caso__r 	= new Case( LuizaCode__c = idCase );
            caseProduct.Produto__r 	= new Product2( LuizaCode__c = Util.getString( mapProduct.get( 'productId' ) ) );

            caseProductToInsert.add( caseProduct );
        }

        insert caseProductToInsert;
	}		

	/**
	* 	Cria/Atualiza os dados do produto 
	*	@param objProductList Lista de objeto contendo os atributos do produto
	*/
	public static void product( List<Object> objProductList ) {
		List<Product2> productToUpsert = new List<Product2>();

		for( Object objResult : objProductList ) {
            Map<String, Object> mapProduct = ( Map<String, Object> ) objResult;

            Product2 product = new Product2();
            product.LuizaCode__c 	= Util.getString( mapProduct.get( 'productId' ) );
            product.Name 			= Util.getString( mapProduct.get( 'productName' ) );
            product.Description 	= Util.getString( mapProduct.get( 'productDescription' ) );
            product.IsActive 		= true;

            productToUpsert.add( product );
        }

        upsert productToUpsert LuizaCode__c;
	}
}