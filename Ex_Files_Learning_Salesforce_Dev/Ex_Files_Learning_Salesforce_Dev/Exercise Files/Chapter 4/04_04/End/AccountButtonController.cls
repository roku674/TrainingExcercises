public class AccountButtonController {
    public ApexPages.standardcontroller Controller {get;set;} 

    public AccountButtonController(ApexPages.StandardController stdController) {
		Controller = stdController;
	}
	public PageReference startBatch() {
        string myId = ApexPages.currentPage().getParameters().get('id');
    	//
    	// create a loader class and instantiate it
    	// define "query" in loader class
    	//
		AccountLoader myLoader = new AccountLoader();
        //
        // set the query string for the SOQL query
        //
        myLoader.query = 'select Id, AccountNumber, Account_Text_Info_Two__c from Account';
system.debug('**************** myLoader.query: '+myLoader.query);
        //
        // finally, call Database.executeBatch() to start the batch process executing
        // myLoader - instantiation of the batch loader
        // myBatchSize - the number of records to process in each batch
        //
        integer myBatchSize = 2;
        ID batchprocessid = Database.executeBatch(myLoader,myBatchSize);
		//
		// return the user to the current page where the button was pressed
		//
      	PageReference pageRef = new PageReference('/' + myId);
        pageRef.setRedirect(true);
        return pageRef;
	}
}