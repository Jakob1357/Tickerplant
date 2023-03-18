h:neg hopen `::5010

.feed.syms: `AAPL`MSFT`AMZN`GOOGL`TSLA`META
.feed.prices: .feed.syms!131 247 105 2144 648 163

priceMultiplier:{[plusMinus]
    plusMinus[1;rand 0.03]
    }

getBid:{[syms]
    priceMultiplier[-] * .feed.prices[syms]
    }

getAsk:{[syms]
    priceMultiplier[+] * .feed.prices[syms]
    }

updatePrices:{[]
    .feed.prices:{priceMultiplier[rand (+;-)] * x}'[.feed.prices]
    }


/runs on every tick
.z.ts:{
    updatePrices[];
    n: rand 6;
    syms:n?.feed.syms;

    $[rand 2; 
        h(".u.upd";`trade;(n#.z.N;syms;.feed.prices[syms];n?rand 100));
        h(".u.upd";`quote;(n#.z.N;syms;getBid'[syms];getAsk'[syms];n?rand 100;n?rand 100))
        ]
    }

\t 100