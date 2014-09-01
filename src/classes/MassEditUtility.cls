public with sharing class MassEditUtility {
	public static List<String> removeSelectedField(List<String> toUpdate_fields, String field) {
		for (Integer i = 0; i < toUpdate_fields.size(); i++)
			if (toUpdate_fields.get(i) == field)
				toUpdate_fields.remove(i);
		return toUpdate_fields;
	}

	public static Map<String, String> getObjectFields(String the_object) {
		Schema.SObjectType obj = Schema.getGlobalDescribe().get(the_object);
		Map<String, String> fieldNames = new Map<String, String>();
		for (String key : obj.getDescribe().fields.getMap().keySet()) {
			fieldNames.put(key, key);
		}
		return fieldNames;
	}

	public static Map<String, String> getObjectNames() {
		List<String> objNames = new List<String>();
		objNames.addAll(Schema.getGlobalDescribe().keySet());
		Map<String, String> objMap = new Map<String, String>();
		objNames.sort();
		for (String s : objNames)
			objMap.put(s, s);
		return objMap;
	}

	public static SObject getObject(String obj) {
		return Schema.getGlobalDescribe().get(obj).newSobject();
	}
}
