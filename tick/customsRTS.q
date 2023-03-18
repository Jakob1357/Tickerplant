if[not "w"=first string .z.o; system "sleep 1"];

initTables:`trade`quote!(
    {[x] `tradeMetrics upsert select maxPrice:0n,minPrice:0n by sym from x};
    {[x] `quoteMetrics upsert select maxBid:0n,minAsk:0n by sym from x}
    );

updTrade:{[d]
    tab:(0!tradeMetrics),select sym,maxPrice:price,minPrice:price from d;
    `tradeMetrics set select maxPrice:max maxPrice,minprice:min minPrice by sym from tab;

    `aggregation set tradeMetrics lj quoteMetrics
    }

updQuote:{[d]
    tab:(0!quoteMetrics),select sym,maxBid:bid,minAsk:ask from d;
    `quoteMetrics set select maxBid:max maxBid,minAsk:min minAsk by sym from tab;

    `aggregation set tradeMetrics lj quoteMetrics
    }

upd:`trade`quote!(updTrade;updQuote);

h:hopen`::5010;

initTables . h(".u.sub";`trade;`)
initTables . h(".u.sub";`quote;`)
