public class myVisualForcePageController {
	@TestVisible  private Opportunity myOpp;
	
	public myVisualForcePageController (ApexPages.StandardController stdController) {
		this.myOpp = (Opportunity)stdController.getRecord();
	}

	public PageReference processQuotes() {
        string myId = ApexPages.currentPage().getParameters().get('id');
        QuoteLoader myLoader = new QuoteLoader();
        myLoader.query = 'select id, Discount, Date_of_Last_Activity__c, ExpirationDate, GrandTotal, Status, TotalPrice  from Quote where Status IN: myStatusSet';
        //
        // Processing quotes in a given status, set the "status" to the desired strings
        //
        myLoader.myStatusSet = new set<string>();
        
        ID batchprocessid = Database.executeBatch(myLoader,150);  // <- set to the rows to process in the batch 
		//
		// return the user to the current page where the button was pressed
		//
      	PageReference pageRef = new PageReference('/' + myId);
        pageRef.setRedirect(true);
        return pageRef;

	}    
}