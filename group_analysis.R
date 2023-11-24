df <- read.csv("Group-data/group_bests.csv")
df$Total.Time.Seconds <- df$Time.Hours*3600 + df$Time.Minutes * 60 + df$Time.Seconds + df$Time.Tenths/10
df$Pace <- df$Total.Time.Seconds / df$Distance * 500 

ggplot(df, aes(x = Distance, y = Pace, color = Name)) + 
  geom_point(size = 3) + 
  geom_smooth(method = "lm", formula = y ~ log2(x/2000), 
             alpha=0.08, linewidth = 0.4,
              fullrange=TRUE, n=1000, se=F)