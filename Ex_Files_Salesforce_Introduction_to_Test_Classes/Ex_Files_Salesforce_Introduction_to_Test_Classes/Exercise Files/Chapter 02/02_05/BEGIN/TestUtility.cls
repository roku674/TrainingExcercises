public without sharing class TestUtility {
    //
    // generic account where name is specified: Record type is the default
    public static Account getAccount(String name)
    {        
        Account a = new Account();
        a.Name = name;
        //
        // Set Initial default values: Account Field values that are 
        // required (e.g. validation rules or workflows)
        a.ShippingStreet = '1234 Test Class Avenue';
        a.ShippingCity = 'Test City';
        a.ShippingPostalCode = '95119'; 
        a.ShippingState = 'California';
        a.ShippingCountry = 'United States';
        a.BillingStreet = '1234 Test Class Avenue';
        a.BillingCity = 'Test City';
        a.BillingState = 'California';
        a.BillingPostalCode = '95119';     
        a.BillingCountry = 'United States';
        return a;
    }
 	//
 	// need to set a specific record type
    public static Account getAccount(String name, Id accRT)
    {        
    	Account a = getAccount(name);
		a.RecordTypeId=accRT;
        return a; 
    }
    //
    // contact associated to specified account
    public static Contact getContact(Account a)
    {
        return getContact(a, 'Test Contact', 'Testing');
    }
   	//
   	// contact with First Name and Last Name specified for specific account
    public static Contact getContact(Account a, String firstName, string lastName)
    {
        Contact c = new Contact();
        c.AccountID = a.id;
        c.LastName = lastName;
        c.FirstName = firstName;
        c.Email = 'testClassEmail@testgmail.com';
        return c;
    }
    
	// 
	// create static method all objects (standard and custom) that are used in the org.
	// As new fields are added and/or requirements added via workflow and validation
	// rules, changes only required here to keep test code up to date
}