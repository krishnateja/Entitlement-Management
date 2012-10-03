trigger fetchAsset on QuoteLineItem (before insert) {

    for(QuoteLineItem quo : Trigger.new){
      
        PricebookEntry pbe = [select id,Product2Id from PricebookEntry where id=: quo.PricebookEntryId];

        List<asset> ast = [select id from asset where product2id=: pbe.Product2Id]; //
        
        for(integer i=0;i<ast.size();i++){
            quo.Asset__c = ast[i].id;
        }
        
    
    }

}