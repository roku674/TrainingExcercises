@isTest
private class QuoteLoaderTest {

	//
	// Create quote test data
	//
	@testSetup static void createMyData () {
		//
		// create test data
		//
		integer numAccts = 2; 
		integer numCustomerAccts = 1; 
		integer numOwnerAccts = 1; 	
		integer numContacts = 2;
		list<Account> myAcctList = (Account[]) TestFactory.createSObjectList(new Account(), numCustomerAccts);
		list<Account> myOwnerAcctList = (Account[]) TestFactory.createSObjectList(new Account(), numOwnerAccts, 'TestFactory.AcctBizDefaults');
		//
		// create 1 customer accounts
		for (integer cnt = 0; cnt<numCustomerAccts; cnt++) {
			myAcctList[cnt].AccountNumber = 'TestCustomer0'+cnt;
			myAcctList[cnt].Description = 'This is a customer test account 0'+cnt;
		}
		insert myAcctList;
		// create 1 owner accounts
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
		//
		// create opportunity
		//
		list<Opportunity> myOppList = (Opportunity[]) TestFactory.createSObjectList(new Opportunity(), 1);
		insert myOppList;
		//
		// Create quote and associated Opportunity
		//
		list<Quote> myQuoteList = (Quote[]) TestFactory.createSObjectList(new Quote(), 1);
		myQuoteList[0].OpportunityId = myOppList[0].Id;
		insert myQuoteList[0];
		
	}

    static testMethod void QuoteLoader_test() {
       
        QuoteLoader myLoader = new QuoteLoader();
        
        myLoader.query = 'select id, Discount, Date_of_Last_Activity__c, ExpirationDate, GrandTotal, Status, TotalPrice  from Quote where Status IN: myStatusSet';
        //
        // Processing quotes in a given status, set the "status" to the desired strings
        //
        myLoader.myStatusSet = new set<string>();
        myLoader.myStatusSet.add('Needs Review');
        myLoader.myStatusSet.add('In Review');
        myLoader.myStatusSet.add('Presented');
	 	test.startTest();
	        ID batchprocessid = Database.executeBatch(myLoader,200);  // <- set to the rows to process in the batch 
	    test.stopTest();
	    system.assertNotEquals(batchprocessid, null);
    }
}
