@isTest
private class QuoteSchedulerTest {

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
	static testMethod void QuoteScheduler_test() {
		// 
		// Test the Quote Scheduler
		//
		// CRON_EXP --> Seconds Minutes Hours DayOfMonth Month DayOfWeek Year
		// Execute on September 3rd at midnight of 2022
		// ? <-- No specific Value
		//
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        
        test.startTest();
	        // Schedule the test job
	        String jobId = System.schedule('testBasicScheduledApex',
	                                       CRON_EXP, new QuoteScheduler());
	        
	        // Get the information from the CronTrigger API object
	        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
	                          FROM CronTrigger WHERE id = :jobId];
	        
	        // Verify the expressions are the same
	        system.assertEquals(CRON_EXP, ct.CronExpression);
	        
	        // Verify the job has not run
	        system.assertEquals(0, ct.TimesTriggered);
	        
	        // Verify the next time the job will run
	        system.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));      
        test.stopTest();		
	}
}