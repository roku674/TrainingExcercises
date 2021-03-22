Global class AccountScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
    	//
    	// create a loader class and instantiate it
    	// define "query" in loader class
    	//
		AccountLoader myLoader = new AccountLoader();
        //
        // set the query string for the SOQL query
        //
        myLoader.query = 'select Id, AccountNumber, Account_Text_Info_Two__c from Account';
        //
        // finally, call Database.executeBatch() to start the batch process executing
        // myLoader - instantiation of the batch loader
        // myBatchSize - the number of records to process in each batch
        //
        integer myBatchSize = 2;
        ID batchprocessid = Database.executeBatch(myLoader,myBatchSize);
    }
}