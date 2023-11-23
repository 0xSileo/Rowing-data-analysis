library(dplyr)
library(ggplot2)
library(ggthemes) # Load additional ggplot themes
library(scales) # For breaks_width()
library(viridis)

# Convert seconds to mm:ss
format_seconds <- function(x) {
  mins <- floor(x / 60)
  secs <- x %% 60
  sprintf("%2d:%02d", mins, secs)
}

# Loading times and removing columns with only NAs
season_df <- read.csv('Concept2-data/concept2-season-2024.csv')
#Removing 'formatted' columns 
season_df[c(4,6,12)] <- rep(NULL,3)

# Cleaning the data
colnames(season_df)[c(4,5,8)] <- c("Work.Time.Seconds","Rest.Time.Seconds","SPM")
season_df$Pace.Seconds <- (season_df$Work.Time.Seconds/season_df$Work.Distance)*500
season_df <- Filter(function(x)!all(is.na(x)), season_df)

# Pace - SPM graph
ggplot(season_df, aes(x = SPM, y = Pace.Seconds, color = as.character(Work.Distance), alpha = as.POSIXct(Date))) + 
  geom_point(size = 3) +
  scale_x_continuous(breaks = breaks_width(1)) + 
  # scale_color_continuous(trans = "log10") + si color est numerique
  scale_y_continuous(breaks = breaks_width(4), labels = format_seconds) + 
  theme_linedraw(base_size = 16)



# Get the minimum time for each distance
best_times_df <- season_df %>%
  group_by(Work.Distance) %>%
  summarize(Pace.Seconds = min(Pace.Seconds))

best_times_df$Work.Distance.Log <- 5 * log2(best_times_df$Work.Distance/2000)

# Fit a linear regression model
model <- lm(Pace.Seconds ~ Work.Distance.Log , data=best_times_df)


ggplot(season_df, aes(x = Work.Distance, y = Pace.Seconds, color = SPM)) + 
  # Plot best fit curve
  geom_smooth(data = best_times_df,
              method = "lm", 
              formula = y ~ log2(x/2000), 
              color = "blue",
              alpha=0.1,
              size = 0.4,
              fullrange=TRUE,
              level=0.9,
              n=1000) +
  geom_point(data = best_times_df ,size=5, color = "blue") + # Highlight best times
  geom_point(size = 3) + # Plot all times
  scale_color_viridis_c(direction = -1) +  # Use viridis color scale
  scale_x_continuous(n.breaks=30, expand=c(0,0), limits=c(100,11000)) + 
  # scale_color_continuous(trans = "log10") + si color est numerique
  scale_y_continuous(breaks = breaks_width(4), labels = format_seconds) + 
  theme_linedraw(base_size = 16)
