system"cd D:\\projects\\Tickerplant\\Tickerplant\\tick\\db2";
system"l ."

.rdb.stocks:([] date:raze (3#2000.01.01;3#2000.01.02;3#2000.01.03); sym:9#(`AMZN`TSLA`META); close:130 250 2150 135 25 2140 132 247 2165; time:9#.z.p);

.eod.saveTable:{[tab]
    dateRange:`minDate`maxDate!(min;max)@\:exec distinct date from r:` sv `.rdb,tab;
    data:(value r),select from tab where date within dateRange[`minDate`maxDate]; 
    dts:exec distinct date from data;

    {[tab;data;dt]
        .Q.dd[(.Q.par[`:.;dt;tab]);`] set .Q.en[`:.](delete date from select from data where date = dt)
        }[tab;data;]each dts
    }

.eod.saveDown:{
    .eod.saveTable each tables`;
    }