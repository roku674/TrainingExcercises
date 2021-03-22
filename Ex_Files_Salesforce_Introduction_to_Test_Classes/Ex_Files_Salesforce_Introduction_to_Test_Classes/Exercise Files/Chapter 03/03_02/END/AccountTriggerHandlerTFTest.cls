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
		// when creating multiple accounts - remember, still limited to SOQL and DML operations 
		// - always use lists and do bulk insert
		//
		// create 10 accounts using default naming for test
		//      list<Account> myAcctList = (Account[]) TestFactory.createSObjectList(new Account(), 10);
		// or you can specify base name
		//
		integer numAccts = 10;
		integer numCustomerAccts = 5;
		integer numOwnerAccts = 5;
		integer numContacts = 10;
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
        // ready to test - data is already loaded that i can query 
        list<Account> myAccounts = [select id, AccountNumber, Description, Account_Text_Info_One__c, 
        							Account_Text_Info_Two__c from Account where Account_Text_Info_One__c = null];
        System.assertEquals(myAccounts.size(), 10);
        
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
	//
	// Second test method - same as above - asserts only work if data is new copy and not modified - example only
    static testMethod void myAccountTestTwp() { 
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