/**
* @CLASS: SMAX_PS_SetFieldsOnWOWebServ_UT
*
* @DESCRIPTION: This is the test class for SMAX_PS_SetFieldsOnWOWebServ
*
*-------------------------------------------------------------------------------------------------------------------
* DEVELOPER                     DATE                  REASON
*-------------------------------------------------------------------------------------------------------------------
* ServiceMax/Shreyas         2021-03-08              Created
********************************************************************************************************************/
@isTest(seeAllData = false)
private class SMAX_PS_SetFieldsOnWOWebServ_UT
{
    static testMethod void testSetAddress()
    {
        Account testAcc = new Account(
            Name = 'Test Account',
            BillingCity = 'Tokyo',
            BillingCountry = 'Japan',
            BillingState = 'Tokyo'
        );
        Insert testAcc;

        SVMXC__Service_Order__c testWO = new SVMXC__Service_Order__c(
            SVMXC__Company__c = testAcc.Id,
            SMAX_PS_Address_Type__c = 'Account'
        );
        Insert testWO;
        
        

        // SFM Request object
        SVMXC.SFM_WrapperDef.SFM_TargetRecord request = new SVMXC.SFM_WrapperDef.SFM_TargetRecord();

        // ***** HEADER OBJECT ********************************
        // SFM Header Record and associate to the SFM request
        SVMXC.SFM_WrapperDef.SFM_TargetRecordObject headerRecord = new SVMXC.SFM_WrapperDef.SFM_TargetRecordObject();
        headerRecord.objName = 'SVMXC__Service_Order__c';
        request.headerRecord = headerRecord;

        // SFM Records and associate to the SFM Header Record
        List<SVMXC.SFM_WrapperDef.SFM_Record> woRecords = new List<SVMXC.SFM_WrapperDef.SFM_Record>();
        headerRecord.records = woRecords;

        // SFM Record for the SFM Records in Header
        SVMXC.SFM_WrapperDef.SFM_Record woRecord = new SVMXC.SFM_WrapperDef.SFM_Record();
        woRecord.sourceRecordId = testWO.Id;
        woRecord.targetRecordId = testWO.Id;
        List<SVMXC.SFM_WrapperDef.SFM_StringMap> woRecordAsKeyValue = new List<SVMXC.SFM_WrapperDef.SFM_StringMap>();
        woRecordAsKeyValue.add(new SVMXC.SFM_WrapperDef.SFM_StringMap('Id', testWO.Id));
        
        woRecord.targetRecordAsKeyValue = woRecordAsKeyValue;
        woRecords.add(woRecord);

        SMAX_PS_SetFieldsOnWOWebServ.setAddressOnChange(request);
    }
    static testMethod void testSetIP()
    {
        Account testAcc = new Account(
            Name = 'Test Account',
            BillingCity = 'Tokyo',
            BillingCountry = 'Japan',
            BillingState = 'Tokyo'
        );
        Insert testAcc;
		Product2 product = new Product2(
            Name='Test Product'
        );
        Insert product;

        SVMXC__Site__c testLoc = SMAX_PS_TestDataFactory.CreateLocation('TestLoc');
        testLoc.SVMXC__Account__c=testAcc.Id;
        insert testLoc;
        
        SVMXC__Installed_Product__c testIP = new SVMXC__Installed_Product__c(
            Name = 'Test IP',
            SVMXC__Product__c = product.Id,
            SVMXC__Company__c = testAcc.Id,
            SVMXC__Site__c=testLoc.id
        );
        Insert testIP;
        Case testCase=new Case(
            AccountId=testAcc.Id,
            SMAX_PS_LastName__c='Test Name',
            SMAX_PS_Segment__c='1',
            SuppliedEmail='test@test.com'
            
        );
        Insert testCase;
        
        
        SVMXC__Case_Line__c testCaseLine = new SVMXC__Case_Line__c(
            SVMXC__Case__c=testCase.Id,
            SVMXC__Installed_Product__c = testIP.Id,
            SVMXC__Product__c = product.Id
            
        );
        Insert testCaseLine;
        
        SVMXC__Quote__c testQuote = new SVMXC__Quote__c(
            SVMXC__Company__c = testAcc.Id,
            SMAX_PS_OutPut_Type__c = 'HTS',
            SMAX_PS_Segment__c='1',
            SMAX_PS_Delivery_Condition__c = '1001'
            
        );
        Insert testQuote;
        

        SVMXC__Service_Order__c testWO = new SVMXC__Service_Order__c(
            SVMXC__Company__c = testAcc.Id,
            SMAX_PS_Address_Type__c = 'Account',
            SVMXC__Component__c = testIP.Id,
            SVMXC__Case__c = testCase.Id,
            SMAX_PS_Service_Quote__c = testQuote.Id
        );
        Insert testWO;

        // SFM Request object
        SVMXC.SFM_WrapperDef.SFM_TargetRecord request = new SVMXC.SFM_WrapperDef.SFM_TargetRecord();

        // ***** HEADER OBJECT ********************************
        // SFM Header Record and associate to the SFM request
        SVMXC.SFM_WrapperDef.SFM_TargetRecordObject headerRecord = new SVMXC.SFM_WrapperDef.SFM_TargetRecordObject();
        headerRecord.objName = 'SVMXC__Service_Order__c';
        request.headerRecord = headerRecord;

        // SFM Records and associate to the SFM Header Record
        List<SVMXC.SFM_WrapperDef.SFM_Record> woRecords = new List<SVMXC.SFM_WrapperDef.SFM_Record>();
        headerRecord.records = woRecords;

        // SFM Record for the SFM Records in Header
        SVMXC.SFM_WrapperDef.SFM_Record woRecord = new SVMXC.SFM_WrapperDef.SFM_Record();
        woRecord.sourceRecordId = testWO.Id;
        woRecord.targetRecordId = testWO.Id;
        List<SVMXC.SFM_WrapperDef.SFM_StringMap> woRecordAsKeyValue = new List<SVMXC.SFM_WrapperDef.SFM_StringMap>();
        woRecordAsKeyValue.add(new SVMXC.SFM_WrapperDef.SFM_StringMap('Id', testWO.Id));
        
        woRecord.targetRecordAsKeyValue = woRecordAsKeyValue;
        woRecords.add(woRecord);

        SMAX_PS_SetFieldsOnWOWebServ.setIPDataOnChange(request);
        SMAX_PS_SetFieldsOnWOWebServ.setFieldsOnLoad(request);
    }
}