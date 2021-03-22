public class AccountTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on account object
	//
    private boolean myIsExecuting = false;
    private integer BatchSize = 0;
	//
	// constructor
	//
    public AccountTriggerHandler(boolean isExecuting, integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert 
	//   
    public void OnBeforeInsert(list<Account> lstNew) { 
    } 
	//
	// On After Insert 
	// 
    public void OnAfterInsert(map<id, Account> mapNew) {
    }
	//
	// On Before Update 
	//    
    public void OnBeforeUpdate(map<id, Account> mapOld, map<id, Account> mapNew) { 
    }
	//
	// On After Update
	//
    public void OnAfterUpdate(map<id, Account> mapOld, map<id, Account> mapNew) {
    }
	//
	// On Before Delete 
	//
    public void OnBeforeDelete(map<ID, Account> mapOld) {
    }
	//
	// On After Delete 
	//
    public void OnAfterDelete(map<ID, Account> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(list<Account> lstNew) {
    }
}
