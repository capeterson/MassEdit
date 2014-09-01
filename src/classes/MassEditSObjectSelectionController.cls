public with sharing class MassEditSObjectSelectionController {
	public String targetType {
		get; 
		set{
			if(globalDescribe.containsKey(value)){
				Schema.DescribeSObjectResult describe = globalDescribe.get(value).getDescribe();
				if(describe.isUpdateable() && describe.isQueryable() && !describe.isCustomSetting()) {
					targetType = value;
				}else{
					ApexPages.addMessage( 
						new ApexPages.Message( 
							ApexPages.Severity.ERROR,
							'You do not have access to update '+describe.getLabel()
						)
					);
				}
			}else{
				ApexPages.addMessage( 
					new ApexPages.Message( 
						ApexPages.Severity.ERROR,
						'"'+value+'" is not a valid SObjectType.'
					)
				);
			}
		}
	}
	private final String LABEL_TEMPLATE = '{0} ({1})';
	private final Map<String,Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

	public MassEditSObjectSelectionController() {
		
	}

	/**
	 * Returns all SObjectTypes the running user has edit access too *EXCEPT* custom settings and non-queryable types.
	**/
	public List<SelectOption> getEditableTypes(){
		List<SelectOption> result = new List<SelectOption>();
		for(Schema.SObjectType objType: globalDescribe.values() ) {
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
		result.sort();
		return result;
	}

	public PageReference redirect(){
		if(String.isBlank(targetType)){
			ApexPages.addMessage( 
				new ApexPages.Message( 
					ApexPages.Severity.ERROR,
					'An SObject Type must be selected.'
				)
			);
			return null;
		}else{
			PageReference result = Page.MassEditPage;
			result.setRedirect(true);
			result.getParameters().put('type', targetType);
			return result;
		}
	}
}
