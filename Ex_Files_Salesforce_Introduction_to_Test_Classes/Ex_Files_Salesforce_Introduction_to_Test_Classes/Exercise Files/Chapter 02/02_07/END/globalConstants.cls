public class globalConstants {
	//
	// Account Record Types - specify one for each account record type in org
	//
    public static String acctCustomer {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Account.SObjectType, 'Customer'); } private set;
    }
    public static String acctBusiness {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Account.SObjectType, 'Business'); } private set;
    }
    //
    // Contact Record Types
    //
    public static String conOwner {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Contact.SObjectType, 'Owner'); } private set;
    }
    public static String conSales {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Contact.SObjectType, 'Sales'); } private set;
    }
    //
    // Opportunity Record Types
    //
    public static String oppSales {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Opportunity.SObjectType, 'Sales Process'); } private set;
    }
    public static String oppClosed {
        get{ return globalUtilities.getRecordTypeIdBySObjectAndName(Opportunity.SObjectType, 'Closed Opportunity'); } private set;
    }
    
}