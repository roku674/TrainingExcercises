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