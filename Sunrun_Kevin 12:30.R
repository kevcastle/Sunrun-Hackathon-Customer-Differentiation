#Getting actual iinstalled solar panels with help from Code from Sheel

#loading the dataset
library(readr)
current_utility <- read_csv("Hackathons/Current Utilities.csv")
View(current_utility)

utility <- data.frame(current_utility)

unique(utility$Utility)

#loading dplyr library
library(dplyr)
library(tidyr)
library(funModeling)
glimpse(utility)
df_status(utility)
freq(utility) 
profiling_num(utility)
plot_num(utility)
describe(utility)



summary(as.factor(utility$Technology.Type))
summary(as.factor(utility$Utility))
summary(as.factor(utility$Installer.Name))
summary(as.factor(utility$Application.Status))
summary(as.factor(utility$Customer.Sector))
summary(as.factor(utility$Third.Party.Owned))

# Creating a table for total instalations per zipcode 

Total_installations_per_zipcode <-
  utility %>% 
  group_by(Service.Zip) %>% summarise(count=n())

#loading google sunroof zipcode dataset
library(readr)
Solar_postal_google <- read_csv("Hackathons/Solar_postal_google.csv")
View(Solar_postal_google)

google_postal <- data.frame(Solar_postal_google)
google_postal$Service.Zip <- google_postal$region_name

#using left join to see what extra zip codes are in total tabl compared to google postal 
(gp_merged_total <- left_join(Total_installations_per_zipcode,google_postal))

#inner joining to have the ones that are included in both tables
(gp_total_in_merged <- inner_join(google_postal,Total_installations_per_zipcode))

#creating a column to see the percentage of zip codes adopting solar panels basd on potential
gp_total_in_merged$variance <- gp_total_in_merged$count/gp_total_in_merged$count_qualified*100

library(sqldf)

gp_SQL <- sqldf("SELECT `region_Name`, lat_avg,lng_avg, `count_qualified`,`count`,`variance`
                    FROM gp_total_in_merged
                    GROUP BY region_name
                    HAVING variance > 35 AND variance < 100 AND count_qualified >50;
                    ")
write.csv(gp_SQL,file = '20_best_zip_codes.csv')

gp_SQL_worst <- sqldf("SELECT `region_Name`, `count_qualified`,`count`,`variance`
                FROM gp_total_in_merged
                GROUP BY region_name
                HAVING variance < 100 AND count_qualified >50
                ORDER BY variance
                LIMIT 10;
                ")
write.csv(gp_SQL_worst,file='10_worst_variance.csv')
  
#loading current utilities dataset with 20 indentified zip codes and more important columns
library(readr)
util_adopted_zip_codes <- read_csv("Hackathons/util adopted zip codes.csv")
View(util_adopted_zip_codes)

adopted_util <- data.frame(util_adopted_zip_codes)

adoptedutil_SQL <- sqldf("SELECT InstallerName, COUNT(*) AS count_per_installer
                         FROM adopted_util
                         WHERE InstallerName LIKE 'Vivint%'
                         GROUP BY InstallerName
                         ORDER BY count_per_installer DESC
                         ;")

write.csv(adoptedutil_SQL,file="VivintQL.csv")

