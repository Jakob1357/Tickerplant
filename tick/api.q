h:hopen`::5012;
r:hopen`::5011;

selectData:{[dict]
    //check for date range
    if[not all `tab`startDate`endDate in key dict;
        '"error - missing required params tab, startDate, endDate"];
    
    `tab`sd`ed set' dict[`tab`startDate`endDate];

    wc:enlist (within;`date;(sd;ed));
    if[`syms in key dict;
        wc,:enlist (in;`sym;enlist dict[`syms])];

    hdb:h({[tab;wc] ?[tab;wc;0b;()]};tab;wc);
    rdb:h({[tab;wc] ?[tab;wc;0b;()]};` sv `.rdb,tab;wc);
    //reduction
    : select from hdb,rdb where time = (max;time) fby ([ date;sym])
    }