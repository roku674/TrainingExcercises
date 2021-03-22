public class OpportunityTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on account object
	//
    private boolean myIsExecuting = false;
    private integer BatchSize = 0;
	//
	// constructor
	//
    public OpportunityTriggerHandler(boolean isExecuting, integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert 
	//   
    public void OnBeforeInsert(list<Opportunity> lstNew) { 
    } 
	//
	// On After Insert 
	// 
    public void OnAfterInsert(map<id, Opportunity> mapNew) {
    }
	//
	// On Before Update 
	//    
    public void OnBeforeUpdate(map<id, Opportunity> mapOld, map<id, Opportunity> mapNew) { 
    	//
    	// check to see if execution is a test or not
    	// 
    	if (Test.isRunningTest()) {
    		OpportunityTriggerHandler.UpdateRecordsAtFuture(mapNew.keySet()); 
    	} else {
    		OpportunityTriggerHandler.UpdateRecordsNow(mapNew);
    	}
    }
    @future
    public static void UpdateRecordsAtFuture(set<Id> myOppIds) {
    	//
    	// have to query for the data needed based on the set of Ids passed to the at future method
    	//
    	map<Id, Opportunity> myMap = new map<Id, Opportunity>([select Id, Name from Opportunity where Id IN :myOppIds]);
    	
    	UpdateRecordsNow(myMap);
    }


    public static void UpdateRecordsNow(map<id, Opportunity> mapNew) {
    	//
    	// process the records
    	//
    }
    
	//
	// On After Update
	//
    public void OnAfterUpdate(map<id, Opportunity> mapOld, map<id, Opportunity> mapNew) {
    }
	//
	// On Before Delete 
	//
    public void OnBeforeDelete(map<ID, Opportunity> mapOld) {
    }
	//
	// On After Delete 
	//
    public void OnAfterDelete(map<ID, Opportunity> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(list<Opportunity> lstNew) {
    }
}