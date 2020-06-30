
# Unit test of the Madrid-GTFS-Bench

Do you want to test the basic capabilities of your OBDA/I engine? 
We have prepared a set of simple (or unit test) queries that you can use with that aim.
As the focus with this resource is not to test the performance or scalability, we recomend to use GTFS-1 (scale value=1) but with the dataset distributions (format) you are going to use over the normal queries.
The features of the queries are:

| Query | Feature/Operator  |
|-------|-------------------|
| q1    | Basic query       |
| q2    | Optional          |
| q3    | Filter            |
| q4    | Join        		|
| q5    | Multiple joins    |
| q6    | Count             |
| q7    | Distinct          |
| q8    | Filter Not Exists |
| q9    | Group by          |
| q10   | Order by          |
| q11   | Filter with regex |
| q12   | Union             |