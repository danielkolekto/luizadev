@isTest
private class CustomMetadataDAOTest {
	
	@isTest static void test_method_one() {
		CustomMetadataDAO.getTriggerActiveMapByName();
	}
	
	@isTest static void test_method_two() {
		CustomMetadataDAO.isTriggerActive('trgConta');
	}
	
	@isTest static void test_method_three() {
		CustomMetadataDAO.getAllMilestonesManager();
	}
	
}