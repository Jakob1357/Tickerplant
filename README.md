# Tickerplant
## Design
1. Data feeder: feed data to tickerplant.
2. Tickerplant: it takes data from feeder and push data straight away to logfile; it maintains the log file; send data to subscribes 
3. Logfile: logfile save data on disks and hold all the updates from tp.
4. RDB: real time databases subscribe the tp for updates and populate to its in-memory table; at end of day write data to HDB and wipes itself 
## Implementation
1. Implement tickerplant: basic functions including clear subscriptions, select a subset of data for real time subscribers(rts), published relevant rows to rts, add a new subscribers, subscribe to specified tables and syms, telling subscribers to end of day. Implement batching mode where tp store data at a intermediate table and publish data in chunks on a timer; implement zero latency where tp publish to rts every on every time tick.
2. Feed handler: publish data to tp on every tick.
3. RTS: init subscribe table in memory and replay the logfile in tp; save the data to hdb at end of day and clears the table.
4. Backfills: backfill data from csvs to tp;
5. End of day: save data to hdb that receives today but could be data from any point in time.
6. Build an api for users where they can get access to the data from both rdb and hdb by specifing a date range.
7. Database maintenance: working on...
8. custom rts: still debuging.
