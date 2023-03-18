if[not "w"=first string .z.o;system "sleep 1"];

upd:insert;

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{[dt]
    t:tables`.;
    t@:where `g=attr each t@\:`sym; / create list of tables with grouped attribute applied
    .Q.hdpf[`$":",.u.x 1;`:.;dt;`sym]; / save all tables with .Q.dpft, clears the tables and tell HDB to reload
    @[;`sym;`g#] each t; / re-apply grouped attribute
    };


/args:
/ list of 2 item lists with (tableName;shcema), 2 item lists with (.u.i;.u.L)
/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{[table;logfile]
    (.[;();:;].)each table; /create tables in memory
    if[null first logfile;:()];
    -11!logfile; /replay the log file with specific .u.i
    system "cd D:\\projects\\Tickerplant\\Tickerplant\\tick\\db1"}; / cd to HDB location for EOD
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
/.u,sub return a list if table names (schema;(logcount;log)) pairs,
/ we also collect .u.i and .u.L from the ticker
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";
