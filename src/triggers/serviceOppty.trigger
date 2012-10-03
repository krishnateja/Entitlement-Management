trigger serviceOppty on Opportunity ( after update) {

    for(Opportunity o : Trigger.new){
    
        if(o.StageName=='Closed Won'){
                            
          List<ServiceContract> mutipleCheck = [select id from ServiceContract where Source_Opportunity__c=:o.id ];
          List<Pricebook2> stdPb = [select Id from Pricebook2 where isStandard=true limit 1]; 
          if(mutipleCheck.size()==0){
              ServiceContract sc = new ServiceContract();
              sc.Name= o.Name;
              sc.AccountId = o.AccountId;
              sc.StartDate = o.CloseDate;
              sc.EndDate = sc.StartDate + 365;
              sc.Source_Opportunity__c  = o.id; 
              sc.Pricebook2Id = stdPb[0].id; 
              insert sc;                 
              
              List<OpportunityLineItem> oli = [SELECT id,PriceBookEntry.UnitPrice,PricebookEntry.Name,PricebookEntry.Product2.Name,PricebookEntryId,Quantity,asset__c FROM OpportunityLineItem WHERE OpportunityId=: o.id];
           
               for(integer i=0;i<oli.size();i++){
                   ContractLineItem cli = new ContractLineItem (); 
                   cli.Quantity=oli[0].Quantity;  
                   cli.StartDate=sc.StartDate;
                   cli.EndDate=cli.StartDate+365;                
                   cli.PriceBookEntryId = oli[0].PriceBookEntryId;
                   cli.UnitPrice=oli[0].PriceBookEntry.UnitPrice;
                   cli.ServiceContractId= sc.Id;
                   cli.AssetId = oli[0].Asset__c;
                   insert cli;                                                                             
               }                            
               
               Entitlement en = new Entitlement();
               en.name = o.name;
               en.accountId = o.AccountId;
               en.ServiceContractId  = sc.id;
               en.StartDate = o.CloseDate;
               en.EndDate = en.StartDate+365;
               insert en;
               
          }
                 
        }
    
    }
    

}