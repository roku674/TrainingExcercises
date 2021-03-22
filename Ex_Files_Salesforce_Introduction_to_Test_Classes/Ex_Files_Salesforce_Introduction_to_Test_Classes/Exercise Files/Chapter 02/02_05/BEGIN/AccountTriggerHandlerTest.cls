@isTest
private class AccountTriggerHandlerTest {
	//
	// Creates test data needed for tests.  Called automatically by system, setting up test
	// data - each method in this test class gets a fresh copy of the test data before 
	// execution of the test method.
	@testSetup static void createMyData () {
		//
		// create single account do following - commented out
		/*		Account myAcct = TestUtils.getAccount('Test Account00');
				myAcct.AccountNumber = 'Test00';
				myAcct.Description = 'This is a test account 00';
				insert myAcct;
		*/
		//
		// when creating multiple accounts - remember, still limited to SOQL and DML operations 
		// - always use lists and do bulk insert
		list<Account> myAcctList = new list<Account>();
		for (integer cnt = 0; cnt<10; cnt++) {
			Account myNewAcct = TestUtility.getAccount('Test Account0'+cnt);
			myNewAcct.AccountNumber = 'Test0'+cnt;
			myNewAcct.Description = 'This is a test account 0'+cnt;
			myAcctList.add(myNewAcct);
		}
		insert myAcctList;
		//
		// Create contacts
		list<Contact> myConList = new list<Contact>();
		for (integer cnt = 0; cnt < 10; cnt++) {
			Contact myNewCon = TestUtility.getContact(myAcctList[cnt], 'Tester0'+cnt, 'TSCon0'+cnt);			
			myConList.add(myNewCon);
		} 
		insert myConList;
		//
		// need Contact field on account set
		for (integer cnt = 0; cnt < 10; cnt++) {
			myAcctList[cnt].Contact__c = myConList[cnt].Id;
		}
		update myAcctList;
	}
	//
	// First test method
    static testMethod void myAccountTestOne() { 
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