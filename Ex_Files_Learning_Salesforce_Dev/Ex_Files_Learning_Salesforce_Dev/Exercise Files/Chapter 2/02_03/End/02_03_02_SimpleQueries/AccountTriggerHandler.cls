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
    	//
    	// Use a set to get Ids from Accounts for Contacts and Opportunities
    	//
    	set<Id> myContactIds = new set<Id>();
    	set<Id> myOppIds = new set<Id>();
    	//
    	// Use a map to access account record based on Contact/Opportunity when doing update
    	//
    	map<Id, Account> myContactToAccountMap = new map<Id,Account>();
    	map<Id, Account> myOppToAccountMap = new map<Id,Account>();
    	for (Account myAct : mapNew.values()) {
    		if (myAct.Contact__c != null) {
    			myContactIds.add(myAct.Contact__c);
    			myContactToAccountMap.put(myAct.Contact__c, myAct);
    		} 
    		if (myAct.Opportunity__c != null) {
    			myOppIds.add(myAct.Opportunity__c);
    			myOppToAccountMap.put(myAct.Opportunity__c, myAct);
    		}
    	}

    	//
    	// query contacts and opportunities associated with accounts in mapNew
    	// simple example to update two fields on contact and opportunity whenever an 
    	// account in updated (but not on creation in this example)
    	//
    	list<Contact> myLstContacts = [select id, Name, Account_Text_Info_One__c, 
    	                               Account_Text_Info_Two__c from Contact where id IN :myContactIds];
    	                               
    	list<Opportunity> myLstOpps = [select id, Name, Account_Text_Info_One__c, Account_Text_Info_Two__c from Opportunity where id IN :myOppIds];
    	

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
