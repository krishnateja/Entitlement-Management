@isTest(seeAllData=true)
private class testEntitlementOpptyManagement{

   

    public static testmethod void  exec(){
        
        User u1 = [SELECT Id FROM User WHERE Alias='KKarn'];
        System.RunAs(u1){
        
        Account a = new Account();
        a.name = 'Testing Account';
        insert a;
        
        opportunity oppty = new opportunity();
        oppty.Name = 'Testing Automated';
        oppty.stageName = 'Prospecting';
        oppty.Probability= decimal.valueOf('10');
        oppty.closedate=system.today();
        oppty.accountId = a.id;
        insert oppty;                 
        
        Product2 p = new product2(name='unittest');
        p.Family = 'License';
        insert p;        
        
        List<Pricebook2> stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        
        if(stdPb[0].id != null){
            PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb[0].id, product2id = p.id,unitprice=1.0,isActive=true);
            insert pbe;
        
        quote q = new quote();
        q.name = 'Testing Automated Quote';
        q.opportunityId=oppty.id;
        q.Pricebook2Id = stdpb[0].id;
        insert q;
        
        
        quoteLineItem i = new quotelineitem(); 
        i.quoteid      = q.id; 
        i.pricebookentryid    = pbe.id ;
        i.quantity            = 1; 
        i.unitprice           = 1; 
        Database.insert(i); 
        //List<OpportunityLineItem> oli = [SELECT id,PriceBookEntry.UnitPrice,PricebookEntry.Name,PricebookEntry.Product2.Name,PricebookEntryId,Quantity,asset__c FROM OpportunityLineItem WHERE OpportunityId=: oppty.id];
        
        //quotelineItem qli = new quotelineItem(PricebookEntryId = '01u90000002jjxr');
        //qli.QuoteId = q.id;
        //qli.Quantity = 1;
        //qli.UnitPrice = oli[0].PriceBookEntry.UnitPrice;
        //insert qli;
        
        quote q1 = new quote(id=q.id);
        q1.status='Approved';
        update q1;
        
        opportunity oppty1 = new opportunity(id=oppty.id);
        oppty1.stageName = 'Closed Won';
        update oppty1;
    }
    }
    }


}