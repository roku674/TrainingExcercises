global class QuoteLoader implements Database.Batchable<sObject>, Database.Stateful {
 
    //
    // public variables used in batch class
    public string query;
    public set<string> myStatusSet;

    //==============================================================================         
    // Implementation of the Database.Batchable interface. 
    //==============================================================================     
    // The "Start" method is where you setup any variables used in the query string in the GenericSchedulerClass
    // and the return query.
    // 
    global database.querylocator start(Database.BatchableContext BC) 
    { 
        return Database.getQueryLocator(query); 
    } 

    //
    // This is where you call the method that you want to execute over and over again.   
    //  
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    { 
        { 
            // This is where you process the SCOPE 
        } 
    } 

	//
	// This is where you call the final cleanup/processing/housekeeping method.  Since this will only run once, it should be limited in what it does.
	//
    global void finish(Database.BatchableContext BC) 
    { 
        { 
            // Final cleanup work that might need to be done
        } 
    } 
}