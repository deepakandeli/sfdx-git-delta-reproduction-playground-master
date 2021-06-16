/*      ●１、トリガ処理（リード作成時）                                               *
*       リード作成時にAccountID_ForMA__cに値が入力されており　かつ                     *
*       　　　その値のIDが取引先に存在する場合は                                       *
*       　　　リードを取引先責任者に昇格する                                           */

public class pcLeadGetAccountInfo
{
    public static void psvLeadGetAccountInfo(Lead[] oTargetLead)
    {
        for(Lead oCurrentLead : oTargetLead)
        {
            System.debug('pscLeadGetAccountInfo:Start LeadInfo = ' + oCurrentLead );
            System.debug('pscLeadGetAccountInfo:Start oTargetLead.AccountID_ForMA__c = ' + oCurrentLead .AccountID_ForMA__c);
            
            try
            {
            
                IF( oCurrentLead .AccountID_ForMA__c != null )
                {
                    IF( [SELECT count() FROM Account WHERE Id =: oCurrentLead .AccountID_ForMA__c] != 0)
                    {
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(oCurrentLead.id);
                        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        lc.setAccountId(oCurrentLead.AccountID_ForMA__c);
                        lc.setDoNotCreateOpportunity(TRUE);
                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                    }
                }
            }
            catch(Exception e)
            {
                //データ取得失敗時は該当レコードスルー
            }
        }
        
    }
}