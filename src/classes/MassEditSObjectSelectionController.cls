public with sharing class MassEditSObjectSelectionController {
	public String targetType {get; set;} //TODO: validate sobject type is real and editable in setter
	private final String LABEL_TEMPLATE = '{0} ({1})';

	public MassEditSObjectSelectionController() {
		
	}

	/**
	 * Returns all SObjectTypes the running user has edit access too *EXCEPT* custom settings and non-queryable types.
	**/
	public List<SelectOption> getEditableTypes(){
		List<SelectOption> result = new List<SelectOption>();
		for(Schema.SObjectType objType: Schema.getGlobalDescribe().values() ) {
			Schema.DescribeSObjectResult describe = objType.getDescribe();
			if(describe.isUpdateable() && describe.isQueryable() && !describe.isCustomSetting()){
				result.add( 
					new SelectOption(
						describe.getName(),
						String.format(LABEL_TEMPLATE, new List<String>{describe.getLabel(), describe.getName()})
					) 
				);
			}
		}
		return result;
	}

	public PageReference redirect(){
		PageReference result = Page.MassEditPage;
		result.setRedirect(true);
		result.getParameters().put('type', targetType);
		return result;
	}
}