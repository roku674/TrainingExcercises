public class globalUtilities {
    class RecordTypeIdLookupException extends Exception {}

    private static Map<String, ID> mapRecordTypeIdBySObjectAndName;
    private static final String strKeyDelimiter = '+';

    public static String getRecordTypeIdBySObjectAndName(Schema.SObjectType objectType, String strRecordTypeName) {
        return getRecordTypeIdBySObjectAndName_FromSchema(objectType, strRecordTypeName);
    }

	private static void populateRecordTypeCacheFromSchema(Schema.SobjectType objectType) {
		Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
		if (mapRecordTypeIdBySObjectAndName == null) {
			mapRecordTypeIdBySObjectAndName = new Map<String, Id>();
		}
		Map<String, Schema.RecordTypeInfo> mapRecordTypeInfoByName = describeResult.getRecordTypeInfosByName();
		for (String strRecordTypeName : mapRecordTypeInfoByName.keySet()){
			String strLookupKey = objectType.getDescribe().getName() + strKeyDelimiter + strRecordTypeName;
			Id recordTypeId = mapRecordTypeInfoByName.get(strRecordTypeName).getRecordTypeId();
			mapRecordTypeIdBySObjectAndName.put(strLookupKey, recordTypeId);
		}
	}

    public static String getRecordTypeIdBySObjectAndName_FromSchema (Schema.SObjectType objectType, String strRecordTypeName) {
    	String strLookupKey = objectType.getDescribe().getName() + strKeyDelimiter + strRecordTypeName;
    	if (mapRecordTypeIdBySObjectAndName == null || (! mapRecordTypeIdBySObjectAndName.containsKey(strLookupKey)) ) {
    		populateRecordTypeCacheFromSchema(objectType);
    	}
       	if (mapRecordTypeIdBySObjectAndName.containsKey(strLookupKey)) {
       		return mapRecordTypeIdBySObjectAndName.get(strLookupKey);
       	}  else {
       		throw new RecordTypeIdLookupException('No RecordType Id found for '+ objectType.getDescribe().getName() + ' with name "'+strRecordTypeName +'".');
       	}
    }

}