utility <- read.csv("Utilities.csv")

unique(utility$Utility)

basic_eda <- function(utility)
{
  glimpse(utility)
  df_status(utility)
  freq(utility) 
  profiling_num(utility)
  plot_num(utility)
  describe(utility)
}

summary(as.factor(utility$Technology.Type))
summary(as.factor(utility$Utility))
summary(as.factor(utility$Installer.Name))
summary(as.factor(utility$Application.Status))
summary(as.factor(utility$Customer.Sector))
summary(as.factor(utility$Third.Party.Owned))

## Count of Zip Codes

utility %>% group_by(Service.Zip) %>% summarise(count=n())
