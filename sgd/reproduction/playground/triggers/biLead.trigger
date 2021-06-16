/*      ●１、トリガ処理（リード作成時）                                               *
*       リード作成時にAccountID_ForMA__cに値が入力されており　かつ                     *
*       　　　その値のIDが取引先に存在する場合は                                       *
*       　　　リード内の取引先参照項目に取引先の値を設定する。                         *
*       ２、プロセスビルダ処理（リード作成時）                                         *
*       　　　１で作成した参照項目に値がある場合は                                     *
*       　　　取引先と取引先責任者を紐づけた状態で、取引先責任者へリード情報を昇格     */

trigger biLead on Lead (after insert)
{
    
    Lead[] oInsertLead = Trigger.new;

    pcLeadGetAccountInfo.psvLeadGetAccountInfo(oInsertLead);

}