@isTest
private class pcLeadGetAccountInfoTEST
{
    @isTest
    static void runTest()
    {
        Id RecordTypeId = [SELECT id FROM RecordType WHERE DeveloperName = 'AccountType' LIMIT 1].Id;
        Account Acc = new Account(Name = 'test', PostNumber__c = '1111111', Pref__c = 'test', Address__c = 'test', RecordTypeId = RecordTypeId);
        
        Database.SaveResult resultAcc = Database.insert(Acc , false);
        Id AccId = resultAcc.getId();
        
        Lead oLead = new Lead( LastName = '姓', AccountID_ForMA__c = AccId , Company = AccId);
        insert oLead ;
    }
}