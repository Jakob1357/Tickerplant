\d .u

/ defines .u.t and .u.w
init:{w::t!(count t::tables`.)#()}

/ clears subscriptions from .u.w
del:{[tab;handle]
    w[tab]_:w[tab;;0]?handle};
    .z.pc:{del[;x]each t};

/select a subset of data for RTS
sel:{[tab;syms]
    $[`~syms;tab;select from tab where sym in syms]
    }

/ publish relevant rows ti interested RTS
pub:{[tab;data]
    {[tab;data;w]
        if[count data:sel[data]w 1;
            (neg first w)(`upd;tab;data)]
        }[tab;data]each w tab
        }

/ add subscription to .u.w
add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])}

/ subscibes to specified tables and syms
sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}

/ send messages to all RTS telling them to .u.end
end:{(neg union/[w[;;0]])@\:(`.u.end;x)}