@isTest
private class AccountTriggerHandlerTFTest {
	//
	// Creates test data needed for tests.  Called automatically by system, setting up test
	// data - each method in this test class gets a fresh copy of the test data before 
	// execution of the test method.
	@testSetup static void createMyData () {
		//
		// create single account do following - commented out
        /*		Account myAcct = (Account) TestFactory.createSObject(new Account());
				myAcct.AccountNumber = 'Test00';
				myAcct.Description = 'This is a test account 00';
        		insert myAcct;
		*/
		//
		// using custom metadata to configure test class
		//
		list<string> getDefaultFields = new list<String>(Org_Configuration__mdt.SObjectType.getDescribe().fields.getMap().keySet());
		string myQueryString = null;
		//
		// loop thru fields available from metadata object:  Org_Configuration__mdt
		// build a query string dynamically
		//
		for (string x : getDefaultFields ) {
            if (myQueryString == null) {
                myQueryString = 'select '+ x;
            } else { 
				myQueryString += ','+x;
            }
		}
		//
		// after adding fields then finish query and where clause to get specific set of metadata 
		//
		myQueryString += ' from Org_Configuration__mdt where DeveloperName = \'My_Test_Data\'';
		//
		// query data
		//
       	Org_Configuration__mdt myTestConfig = database.query(myQueryString);
		//
		// when creating multiple accounts - remember, still limited to SOQL and DML operations 
		// - always use lists and do bulk insert
		//
		// create 10 accounts using default naming for test
		//      list<Account> myAcctList = (Account[]) TestFactory.createSObjectList(new Account(), 10);
		// or you can specify base name
		//
		integer numAccts = integer.valueOf(myTestConfig.Number_Of_Accounts__c); 			// replaced hard coded value of 10;
		integer numCustomerAccts = integer.valueOf(myTestConfig.Number_Of_Accounts__c / 2); // replaced hard coded value of 5;
		integer numOwnerAccts = integer.valueOf(myTestConfig.Number_Of_Accounts__c / 2); 	// replaced hard coded value of 5;
		integer numContacts = integer.valueOf(myTestConfig.Number_Of_Contacts__c); 			// replaced hard coded value of 10;;
		list<Account> myAcctList = (Account[]) TestFactory.createSObjectList(new Account(), numCustomerAccts);
		list<Account> myOwnerAcctList = (Account[]) TestFactory.createSObjectList(new Account(), numOwnerAccts, 'TestFactory.AcctBizDefaults');
		//
		// create 5 customer accounts
		for (integer cnt = 0; cnt<numCustomerAccts; cnt++) {
			myAcctList[cnt].AccountNumber = 'TestCustomer0'+cnt;
			myAcctList[cnt].Description = 'This is a customer test account 0'+cnt;
		}
		insert myAcctList;
		// create 5 owner accounts
		for (integer cnt = 0; cnt<numOwnerAccts; cnt++) {
			myOwnerAcctList[cnt].AccountNumber = 'TestOwner0'+cnt*5;
			myOwnerAcctList[cnt].Description = 'This is a owner test account 0'+cnt*5;
		}
		insert  myOwnerAcctList;
		//
		// Create contacts
		list<Contact> myConList = (Contact[]) TestFactory.createSObjectList(new Contact(), numContacts);
		insert myConList;
		//
		// need Contact field on account set
		for (integer cnt = 0; cnt < numCustomerAccts; cnt++) {
			myAcctList[cnt].Contact__c = myConList[cnt].Id;
		}
		update myAcctList;
		for (integer cnt = 0; cnt < numOwnerAccts; cnt++) {
			myOwnerAcctList[cnt].Contact__c = myConList[cnt+numCustomerAccts].Id;
		}
		update myOwnerAcctList;
	}
	//
	// First test method
    static testMethod void myAccountTestOne() { 
		//
		// using custom metadata to configure test class
		//
		list<string> getDefaultFields = new list<String>(Org_Configuration__mdt.SObjectType.getDescribe().fields.getMap().keySet());
		string myQueryString = null;
		//
		// loop thru fields available from metadata object:  Org_Configuration__mdt
		// build a query string dynamically
		//
		for (string x : getDefaultFields ) {
            if (myQueryString == null) {
                myQueryString = 'select '+ x;
            } else { 
				myQueryString += ','+x;
            }
		}
		//
		// after adding fields then finish query and where clause to get specific set of metadata 
		//
		myQueryString += ' from Org_Configuration__mdt where DeveloperName = \'My_Test_Data\'';
		//
		// query data
		//
       	Org_Configuration__mdt myTestConfig = database.query(myQueryString);
        // ready to test - data is already loaded that i can query 
        list<Account> myAccounts = [select id, AccountNumber, Description, Account_Text_Info_One__c, 
        							Account_Text_Info_Two__c from Account where Account_Text_Info_One__c = null];
        System.assertEquals(myAccounts.size(), myTestConfig.Number_Of_Accounts__c);
        
        list<Contact> myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
        						from Contact];
        //
        // Assert that there are 10 contacts (based on data entered in createMyData() method
        System.assertEquals(myCons.size(), myTestConfig.Number_Of_Contacts__c);
        
        
        myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
        		  from Contact where Account_Text_Info_One__c = ''];
        // 
        // Assert that there are 10 contacts with Account_Text_Info_one__c not set
        System.assertEquals(myCons.size(), myTestConfig.Number_Of_Contacts__c);
        
        
		for (Account x : myAccounts) {
       		x.Account_Text_Info_One__c = 'Updating test text one';
       		x.Account_Text_Info_Two__c = 'Updating test text two';
       	}
       	update myAccounts;

        myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
        						from Contact where Account_Text_Info_One__c = ''];
        //
        // Assert that there are 0 contacts with Account_Text_Info_One__c not set
        System.assertEquals(myCons.size(), 0);
        
    }
	//
	// Second test method - same as above - asserts only work if data is new copy and not modified - example only
    static testMethod void myAccountTestTwp() { 
    	//
    	// select profile to be used
    	//
		Profile p1 = [SELECT Id FROM Profile WHERE Name='Contract Manager' Limit 1];
		//
		// create a user with the profile - 
		//
		User u = new User(Alias = 'test1A', Email='test_InternalAdmin334455@testorg.com', 
							EmailEncodingKey='UTF-8', LastName='Contract', FirstName = 'Manager', LanguageLocaleKey='en_US', 
							LocaleSidKey='en_US', ProfileId = p1.Id, 
							TimeZoneSidKey='America/Los_Angeles', UserName='test_InternalAdmin334455@testorg.com');
	    //
	    // execute code using this user and profile
	    //
        system.runAs(u) {         
        
	        // ready to test - data is already loaded that i can query 
	        list<Account> myAccounts = [select id, AccountNumber, Description, Account_Text_Info_One__c, 
	        							Account_Text_Info_Two__c from Account where Account_Text_Info_One__c = null];
	        
	        list<Contact> myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
	        						from Contact];
	        //
	        // Assert that there are 10 contacts (based on data entered in createMyData() method
	        System.assertEquals(myCons.size(), 10);
	        
	        
	        myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
	        		  from Contact where Account_Text_Info_One__c = ''];
	        // 
	        // Assert that there are 10 contacts with Account_Text_Info_one__c not set
	        System.assertEquals(myCons.size(), 10);
	        
	        
			for (Account x : myAccounts) {
	       		x.Account_Text_Info_One__c = 'Updating test text one';
	       		x.Account_Text_Info_Two__c = 'Updating test text two';
	       	}
	       	update myAccounts;
	
	        myCons = [select id, AccountId, Account_Text_Info_One__c, Account_Text_Info_Two__c 
	        						from Contact where Account_Text_Info_One__c = ''];
	        //
	        // Assert that there are 0 contacts with Account_Text_Info_One__c not set
	        System.assertEquals(myCons.size(), 0);
        }
        
    }
    
}