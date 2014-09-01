@isTest
private class MassEditSObjectSelectionControllerTest {
	
	static User createTestUser(String profileName){
		Profile p = [SELECT Id FROM profile WHERE name = :profileName];
        User mock = new User(
        	alias = 'testUsr',
        	email='MassEditSObjectSelectionController@example.org',
        	emailencodingkey='UTF-8',
        	lastname='Testing',
        	languagelocalekey='en_US',
        	localesidkey='en_US',
        	profileid = p.Id,
            timezonesidkey='America/Los_Angeles',
            username='MassEditSObjectSelectionController@'+UserInfo.getOrganizationId()+'.organization'
         );
        insert mock;
        return mock;
	}

	@isTest 
	static void readonly_oppAccess() {
		System.runAs(createTestUser('Read Only')){
			MassEditSObjectSelectionController con = new MassEditSObjectSelectionController();
			Boolean foundOpp = false;
			for(SelectOption opt:con.getEditableTypes()){
				if(opt.getValue().equalsIgnoreCase('Opportunity'))
					foundOpp = true;
			}
			System.assertEquals(false, foundOpp, 'Opportunity type available for editing on a readonly profile!');
			con.targetType = 'Opportunity'; //try and force it anyways
			System.assertEquals(null, con.targetType, 'targetType setter should have prevented last update.');
			System.assertEquals(null, con.redirect());
		}
	}
	
	@isTest 
	static void sysadmin_oppAccess() {
		System.runAs(createTestUser('System Administrator')){
			MassEditSObjectSelectionController con = new MassEditSObjectSelectionController();
			Boolean foundOpp = false;
			for(SelectOption opt:con.getEditableTypes()){
				if(opt.getValue().equalsIgnoreCase('Opportunity'))
					foundOpp = true;
			}
			System.assertEquals(true, foundOpp, 'Opportunity type not available for editing on a sysadmin profile!');
			con.targetType = 'Opportunity';
			System.assertNotEquals(null, con.redirect());
			System.assert(con.redirect().getUrl().containsIgnoreCase('Opportunity'));
		}
	}
	
}