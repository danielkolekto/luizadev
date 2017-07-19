@isTest
public class CaseBuild {
	
	public static Case createCase(String rtName, Id sellerId, Id contactSellerId, String orderNumber, String protocolNumb){
		return getNewCase(rtName, sellerId, contactSellerId, orderNumber, protocolNumb);
	}
	
	public static Case createCase(String rtName, Id sellerId, Id contactSellerId){
		String randomOrderNumber = Utils.randomNumberAsString(16);
		String randomProtocol = String.valueOf(Datetime.now().year())+Utils.randomNumberAsString(12);
		return getNewCase(rtName, sellerId, contactSellerId, randomOrderNumber, randomProtocol);
	}
	
	
	public static Case getNewCase(String rtName, Id sellerId, Id contactSellerId, String orderNumber, String protocolNumb){
		return new Case(
			RecordTypeId = Utils.getRecordTypeId('Case', rtName),
			Subject = 'Teste',
			Description = 'Caso de testes Marketplace',
			Seller__c = sellerId,
			ContactSeller__c = contactSellerId,
			OrderNumber__c = orderNumber,
			ProtocoloAtendimento__c = protocolNumb,
			LuizaCode__c = protocolNumb
		);
	}
	
}