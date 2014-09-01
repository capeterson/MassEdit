@isTest
private class MassEditTest {

	@isTest static void testUtility() {
		SObject o = MassEditUtility.getObject('Account');
		System.assert(o instanceof Account);

		Map<String, String> names = MassEditUtility.getObjectNames();
		System.assert(names.keySet().equals(Schema.getGlobalDescribe().keySet()));

		Schema.SObjectType obj = Schema.getGlobalDescribe().get('Account');
        Map<String,String> fieldNames = new Map<String,String>();
		System.assert(MassEditUtility.getObjectFields('Account').keySet().equals(
		                  obj.getDescribe().fields.getMap().keySet()));

	}

	// Test for updating all
	@isTest static void testBasicUpdate()
	{
		insert new Account(name='testingMassEdit');
		MassEditController m = new MassEditController();
		m.selectedObj = 'Account';
		m.getFields();
		m.selectedField = 'Name';
		m.addSelectedField();
		m.stub_obj.put('Name','newName');
		m.doUpdate();
		Account a = [SELECT Name FROM Account WHERE Name LIKE 'newName' limit 1];
		System.assert(a.name.equals('newName'));
	}
	// Test for updating selected items
	@isTest static void testFilterUpdate()
	{
		insert new Case(subject='testcase');
		MassEditController m = new MassEditController();
		m.selectedObj = 'Case';
		m.getFields();
		m.selectedField = 'Subject';
		m.addSelectedField();
		m.selectedField = 'description';
		m.addSelectedField();
		m.selectedField = 'status';
		m.addSelectedField();
		m.selectedField = 'id';
		m.addSelectedField();
		m.removeField = 'id';
		m.removeSelectedField();
		m.searchText = 'subject = \'testcase\'';
		m.doSearch();
		m.stub_obj.put('Subject','testFilterUpdate');
		m.stub_obj.put('description', 'testdescription here');
		m.doUpdate();
		m.doSelectAll();
		Case a = [SELECT subject FROM case WHERE subject LIKE 'testFilterUpdate' limit 1];
		System.assert(a.subject.equals('testFilterUpdate'));
	}
}
