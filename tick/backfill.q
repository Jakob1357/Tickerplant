h:hopen`::5010
typs:h"(tables`)!{1_upper exec t from meta value x}each tables`";
columns:h"(tables`)!cols each tables`";

bfill:{[tableName;csvLoc]
    /read in csv
    csvLoc:$[-11h~type csvLoc;csvLoc;`$csvLoc];
    tab:(typs[tableName];enlist csv) 0: hsym csvLoc;
    / format it
    tab:columns[tableName] xcols update time:.z.N from tab;

    / push to tp
    h(".u.upd";tableName;flip value each tab)
    }