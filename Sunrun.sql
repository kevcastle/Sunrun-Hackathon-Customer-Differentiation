/* Query to filter for only California zip codes*/
SELECT *
FROM `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`
WHERE state_name = 'California'
ORDER BY region_name;
/*Query results in 1212 records*/

/*Query for the top 10 zip codes based on qualified solar buildings*/
SELECT *,existing_installs_count/count_qualified AS install_perc
FROM `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`
WHERE state_name = 'California' AND count_qualified > 1000
ORDER BY count_qualified DESC
LIMIT 10;
/*Result shows that the top 10 zip codes are
92345 - San Bernadino County - Hesperia,Lugo (Cities) - 24776 qualified houses
92592 - Temecula (City) - 23608 qualified houses
92336 - San Benadino County - Fontana, Nealys Corner(Cities) - 23471 qual. hous
94565 - Pittsburg, Bay Point, Concord, Shore Acres, Nortonville(Cities) - 23381
93722 - Fresno, Highway City, Muscatel, California, Herndon, California -23281
92503 - Riverside County - Riverside, Home Gardens - 22287 qualified houses
90650 - Los Angeles County - Norwalk (City) -22217 qualified houses
95630 - Sacramento County - Folsom (City) - 21939 qualified houses
92683 - Orange County - Westminster, Seal Beach - 21638 qualified houses
91710 - San Bernadino County - Ontario, Chino - 21196
*/

/* Actual customers for top 10 zip codes
92345 - 2270
92592 - 4132
92336 - 3803
94565 - 2151
93722 - 3496
92503 - 1181
90650 - 897
95630 - 0
92683 - 1274
91710 - 2329
*/

/* Query in SQLDF in R to identify how many of the 28504 installations from the
20 most adopted zip codes come from Sunrun*/
adoptedutil_SQL <- sqldf("SELECT *
                         FROM adopted_util
                         WHERE InstallerName LIKE 'Sunrun%';")
/*Only 791 come from Sunrun, only 2.77% are using Sunrun*/

/* Query in SQLDF in R to identify how many of the 28504 installations from the
20 most adopted zip codes come from SolarCity*/
adoptedutil_SQL <- sqldf("SELECT InstallerName, COUNT(*) AS count_per_installer
                         FROM adopted_util
                         WHERE InstallerName LIKE 'Solar%' OR InstallerName LIKE 'Tesla%'
                         GROUP BY InstallerName
                         ORDER BY count_per_installer DESC
                         LIMIT 5;"
/* After exporting to CSv and seeing the SUM, at least 4463 installations come
from SolarCity and Tesla accounting for 15% of the installations*/

/* Identifying how many of the 28504 installations from the 20 most adopted
zip codes come from Sunpower*/
adoptedutil_SQL <- sqldf("SELECT InstallerName, COUNT(*) AS count_per_installer
                         FROM adopted_util
                         WHERE InstallerName LIKE 'SUNPOWER%' OR InstallerName LIKE 'Sunpower%'
                         GROUP BY InstallerName
                         ORDER BY count_per_installer DESC
                         ;")
/*At least 3038 of the 28504 come from the 20 most adopted zip codes accounting
for 10%*/

/* Identifying how many of the 28504 installations from the 20 most adopted
zip codes come from Vivint*/
adoptedutil_SQL <- sqldf("SELECT InstallerName, COUNT(*) AS count_per_installer
                         FROM adopted_util
                         WHERE InstallerName LIKE 'Vivint%'
                         GROUP BY InstallerName
                         ORDER BY count_per_installer DESC
                         ;")
/*Only 780 come from Vivint, only 2.73% are using Vivint*/                         
