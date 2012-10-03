trigger updateQuote on Quote ( after update) {

public List<QuoteLineItem> qli;
public Quote qid;
    for(Quote q : Trigger.new){
    
       if(q.Status == 'Approved'){
                  
           qid = [select id,OpportunityId  from Quote where id=: q.id];
           qli = [SELECT Quantity,TotalPrice,PricebookEntryId,Asset__c   FROM QuoteLineItem WHERE QuoteId =: q.id];
           
           for(integer i=0;i<qli.size();i++){
               OpportunityLineItem p = new OpportunityLineItem ();               
               p.OpportunityId  = qid.OpportunityId;
               p.Quantity  = qli[i].Quantity ;
               p.TotalPrice = qli[i].TotalPrice ;
               p.PricebookEntryId  = qli[i].PricebookEntryId ;
               p.asset__c = qli[i].asset__c;
               insert p;
                              
           }           
       }           
    }    
}