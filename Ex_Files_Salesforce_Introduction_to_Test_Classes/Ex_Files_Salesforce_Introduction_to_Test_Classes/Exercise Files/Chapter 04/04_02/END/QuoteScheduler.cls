Global class QuoteScheduler implements Schedulable {
   
    global void execute(SchedulableContext SC) {
    	//
    	// instantiate the corresponding loader class
    	//
        QuoteLoader myLoader = new QuoteLoader();
        //
        // Set your query on the next line.  Notice that if you want to have string values in query, you need to set them up as
        // variables (i.e. myExclude) in the GenericBatchLoader.cls.   You can do the same thing with Sets (e.g. accountIds)
        //      
        myLoader.query = 'select id, Discount, Date_of_Last_Activity__c, ExpirationDate, GrandTotal, Status, TotalPrice  from Quote where Status IN: myStatusSet';
        //
        // Processing quotes in a given status, set the "status" to the desired strings
        //
        myLoader.myStatusSet = new set<string>();
        myLoader.myStatusSet.add('Needs Review');
        myLoader.myStatusSet.add('In Review');
        myLoader.myStatusSet.add('Presented');
                
        //
        // the secord parameter is the number of records that you want processed per execution.   The lower the number, the more likely that you wont hit any execution 
        // limits.  In the comment notification code, I could actually use around 75 but decided to go with a much lower number to avoid any issues.
        //
        ID batchprocessid = Database.executeBatch(myLoader,40);  // <- set to the rows to process in the batch 
    	
    }
}