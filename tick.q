system"l tick/",(src:first .z.x,enlist"sym"),".q"

if[not system"p";system"p 5010"]

\l tick/u.q
\d .u
/ retur the log file
ld:{[dt]
    if[not type key L::`$(-10_string L),string dt;
        /Amend entire - create empty logfile
        .[L;();:;()]
    ];
    i::j::-11!(-2;L);
    if[0<=type i;
        -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
        exit 1
    ];
    hopen L
    };


tick:{[src;tplog]
    init[];
    /check for `time`sym cols
    if[not min(`time`sym~2#key flip value@)each t;
        '`timesym
    ];
    / apply grouped attribute
    @[;`sym;`g#]each t;
    d::.z.D;
    /create handle to tplog
    if[l::count tplog;
        L::`$":",tplog,"/",src,10#".";
        l::ld d
    ]
    };

/ called .u.end and increment global .u.d by 1, called .u.ld to create the new log file
endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};


ts:{[dt]
    if[d<dt;
        if[d<dt-1;system"t 0";'"more than one day?"];
        endofday[]
    ]
    };

/batching mode,  store data intermediate state , publish data in chunks on a timer
if[system"t";
    / publish updates to RTS , clear out tables , set i = j, check for eod
 .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
    /add time stamp if not present , insert data locally , send message to tplog , increment 1
    upd:{[t;x]
        if[not -16=type first first x;
            if[d<"d"$a:.z.P;
            .z.ts[]
            ];
        a:"n"$a;
        x:$[0>type first x;
            a,x;
            (enlist(count first x)#a),x
             ]
        ];
        t insert x;
        if[l;l enlist (`upd;t;x);j+:1];}];

/ zero latency
if[not system"t";system"t 1000";
    /each tick check for end of date()
    .z.ts:{ts .z.D};
    /check for end of date, add timestamp if not present , create tab from data and publish to RTS, send message to logfile , increment i;
    upd:{[tab, data]
        ts"d"$a:.z.P;
        if[not -16=type first first data;
            a:"n"$a;
            data:$[0>type first data;
                a,data;
                (enlist(count first data)#a),data
                ]
            ];
        f:key flip value tab;
        pub[tab;$[0>type first data;enlist f!data;flip f!data]];
        if[l;l enlist (`upd;tab;data);i+:1];
        }
    ];

\d .
.u.tick[src;.z.x 1];

\
 globals used (.u contains)
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date

/test
>q tick.q
>q tick/ssl.q

/run
>q tick.q sym  .  -p 5010	/tick
>q tick/r.q :5010 -p 5011	/rdb
>q sym            -p 5012	/hdb
>q tick/ssl.q sym :5010		/feed