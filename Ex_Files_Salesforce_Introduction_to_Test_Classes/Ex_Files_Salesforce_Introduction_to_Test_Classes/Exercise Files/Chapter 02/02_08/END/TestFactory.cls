@isTest
public class TestFactory {
    //
    // default creation methods for creating single SObject or a list of SObjects
    //
    public static SObject createSObject(SObject sObj) {
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());
        // Construct the default values class. Salesforce doesn't allow '__' in class names
        String defaultClassName = 'TestFactory.' + objectName.replace('__c', '') + 'Defaults';
        // If there is a class that exists for the default values, then use them
        if (Type.forName(defaultClassName) != null) {
            sObj = createSObject(sObj, defaultClassName);
        }
        return sObj;
    }
    
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            Throw new TestFactoryException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, null);
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new SObject[]{};
        SObject newObj;

        // Get one copy of the object
        if (defaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }

        // The name field of the object - not all objects have a field called "Name" so nameFieldMap provides for mapping
        // of objects that don't have nama field.  
        String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
        if (nameField == null) {
            nameField = 'Name';
        }

        // Clone the object the number of times requested. Increment the name field so each record is unique
        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);
            clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + ' ' + i);
            sObjs.add(clonedSObj);
        }
        return sObjs; 
    }

    private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (String field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
    }

    // Specify the "name" field of each object.  The default name field is "name"field
    // for example, Contact - requires LastName
    //              Case -- doesn't have a Name field - so map it to Subject - we get unique subjects
    //              Opportunity -- Name field exists - it is the Opportunity Name - don't specify - let it default to Name above
    private static Map<String, String> nameFieldMap = new Map<String, String> {
        'Contact' => 'LastName',
        'Case' => 'Subject'
    };

	// Exception extension - can specify custom error messages
    public class TestFactoryException extends Exception {}

    // FieldDefaults interface
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults();
    }

    // To specify defaults for objects, use the naming convention [ObjectName]Defaults.
    // For custom objects, omit the __c from the Object Name    
    
    public class AccountDefaults implements FieldDefaults{
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Account',
                'BillingStreet' => '123 Main Street',
                'BillingCity' => 'Portland',
                'BillingState' => 'OR',
                'BillingPostalCode' => '97204',
                'BillingCountry' => 'USA',
                'Phone' => '(555)867-5309',
                'Website' => 'http://www.tester.com',
                'Category__c' => 'Sales Prospect',
                'RecordTypeId' => globalConstants.acctCustomer, // recordType of 'Customer'
                'Industry' => 'Other',
                'AnnualRevenue' => 100000000.00,
                'NumberOfEmployees' => 72
            };
        }
    }

    public class ContactDefaults implements FieldDefaults{
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'FirstName' => 'First',
                'LastName' => 'Last',
                'Title' => 'Tester',
                'RecordTypeId' => globalConstants.conSales, // recordType of 'Sales',
                'LeadSource' => 'Customer',
                'MailingStreet' => '123 Main Street',
                'MailingCity' => 'Portland',
                'MailingState' => 'OR',
                'MailingPostalCode' => '97204',
                'MailingCountry' => 'USA',
                'OtherStreet' => '123 Main Street',
                'OtherCity' => 'Portland',
                'OtherState' => 'OR',
                'OtherPostalCode' => '97204',
                'OtherCountry' => 'USA',
                'Description' => 'This is a test contact.',
                'Phone' => '(555)867-5309',
                'Email' => 'first.last@tester.com'
            };
        }
    }

    public class OpportunityDefaults implements FieldDefaults{
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Opportunity',
                'StageName' => 'Needs Analysis',
                'Sales_Forecast_Category__c' => 'Pipeline',
                'CloseDate' => System.today()+10,
                'Term_Start_Date__c' => system.today(),
                'Term_End_Date__c' => system.today()+15,
                'Booking_Type__c' => 'New',                
                'LeadSource' => 'Partner',
                'RecordTypeId' => globalConstants.oppSales, // recordType of 'Sales Process',
                'Probability' => 20
            };
        }
    }

    //
    // add additional objects (standard or custom)
    //
    
    //
    // add special additional object defaults
    //
    
    //
    // Account default for Business Accounts
    //
    public class AcctBizDefaults implements FieldDefaults{
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'OTA ',
                'BillingStreet' => '123 West Ave C',
                'BillingCity' => 'Portland',
                'BillingState' => 'OR',
                'BillingPostalCode' => '97204',
                'BillingCountry' => 'USA',
                'Phone' => '(555)867-9035',
                'Website' => 'http://www.ownertester.com',
                'Category__c' => 'Business Owner',
                'RecordTypeId' => globalConstants.acctBusiness, // recordType of 'Customer'
                'Industry' => 'Electronics',
                'AnnualRevenue' => 5000000.00,
                'NumberOfEmployees' => 72
            };
        }
    }
}