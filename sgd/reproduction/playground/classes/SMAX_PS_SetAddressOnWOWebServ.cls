/**
* @CLASS: SMAX_PS_SetAddressOnWOWebServ
*
* @DESCRIPTION: This class is used to set the address fields on a work order based on the address type selected. The current choices for address type
                are Account and Installed Product. The fields on work order copy the addresses from these 2 related parent records
*
*-------------------------------------------------------------------------------------------------------------------
* DEVELOPER                     DATE                  REASON
*-------------------------------------------------------------------------------------------------------------------
* ServiceMax/Shreyas         2021-03-03              Created
********************************************************************************************************************/
global class SMAX_PS_SetAddressOnWOWebServ
{
    webservice static SVMXC.SFM_WrapperDef.SFM_PageData setAddress(SVMXC.SFM_WrapperDef.SFM_TargetRecord request)
    {
        SVMXC.SFM_WrapperDef.SFM_PageData pagedata = new SVMXC.SFM_WrapperDef.SFM_PageData();
        SVMXC.SFM_ServicesDef def = new SVMXC.SFM_ServicesDef();
        Map<String,Schema.SObjectType> mapAllobj = new Map<String, Schema.SObjectType>();
        Map<String, Schema.SObjectType> mapGlobalDesc = new Map<String, Schema.SObjectType>();
        Map<String,List<Sobject>> detailSobjectMap = new Map<String, List<Sobject>>();

        mapGlobalDesc = Schema.getGlobalDescribe();

        if(mapGlobalDesc.size() > 0)
        {
            for(Schema.SObjectType schIterator : mapGlobalDesc.values())
            {
                Schema.DescribeSObjectResult result = schIterator.getDescribe();
                mapAllobj.put(result.getName(), schIterator);
            }
        }

        Sobject headerSobj = def.SFM_Page_GetHeaderRecord(request, mapAllobj);
        SVMXC__Service_Order__c objWO = new SVMXC__Service_Order__c();
        objWO = (SVMXC__Service_Order__c)headerSobj;

        if(objWO.SMAX_PS_Address_Type__c != null)
        {
            if(objWO.SMAX_PS_Address_Type__c == 'Account')
            {
                for(Account accIterator : [Select Id, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity From Account
                                           Where Id =: objWO.SVMXC__Company__c Limit 1])
                {
                    objWO.SVMXC__Street__c = accIterator.BillingStreet;
                    objWO.SVMXC__State__c = accIterator.BillingState;
                    objWO.SVMXC__Zip__c = accIterator.BillingPostalCode;
                    objWO.SVMXC__Country__c = accIterator.BillingCountry;
                    objWO.SVMXC__City__c = accIterator.BillingCity;
                }
            }
            else if(objWO.SMAX_PS_Address_Type__c == 'Installed Product')
            {
                for(SVMXC__Installed_Product__c ipIterator : [Select Id, SVMXC__Street__c, SVMXC__State__c, SVMXC__Zip__c, SVMXC__Country__c, SVMXC__City__c
                                                              From SVMXC__Installed_Product__c Where Id =: objWO.SVMXC__Component__c Limit 1])
                {
                    objWO.SVMXC__Street__c = ipIterator.SVMXC__Street__c;
                    objWO.SVMXC__State__c = ipIterator.SVMXC__State__c;
                    objWO.SVMXC__Zip__c = ipIterator.SVMXC__Zip__c;
                    objWO.SVMXC__Country__c = ipIterator.SVMXC__Country__c;
                    objWO.SVMXC__City__c = ipIterator.SVMXC__City__c;
                }
            }
            try
            {
                Update objWO;
                pagedata.response.message = 'Saved Successfully'; 
                pagedata.response.success = true; 
                pagedata.response.messageType = 'SVMX_SUCCESS';
            }
            catch(Exception ex)
            {
                pagedata .response.message = ex.getmessage(); 
                pagedata.response.success = false; 
                pagedata.response.messageType = 'SVMX_ERROR'; 
                return pagedata;
            }
        }
        detailSobjectMap = def.SFM_Page_GetDetailRecords(request, mapAllobj);
        pagedata = def.SFM_Page_BuildResponse(request, objWO, detailSobjectMap); 
        system.debug('Response = ' + pagedata); 
        return pagedata;
    }
}