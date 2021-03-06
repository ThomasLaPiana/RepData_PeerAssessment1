## Set the working directory and load required packages
setwd("~/JHU DataScience Courses/R Directory/RepData_PeerAssessment1")
library(data.table)
library(dplyr)
library(Amelia)

## Load in the data
activity = data.table(read.csv('activity.csv'))

## Group the data by day
grouped_day = activity %>% filter(!is.na(steps)) %>% group_by(date) %>% summarise_each(funs(sum)) %>% select(date,steps)

## Perform Step 1 Analysis 
hist(grouped_day$steps)
Mean = paste('Mean: ',mean(grouped_day$steps))
Median = paste('Median: ',median(grouped_day$steps))
print(c(Mean,Median))

## Group the data by 5-minute interval
grouped_interval = activity %>% filter(!is.na(steps)) %>% group_by(interval) %>% summarise_each(funs(mean)) %>% select(interval,steps)

## Perform Step 2 Analysis
plot(grouped_interval$interval,grouped_interval$steps,
     type = 'l')
head(arrange(grouped_interval,desc(steps)),1)

## Perform Step 3 Analysis 
print(sum(is.na(activity$steps)))

## Create a function that imputes data with the mean of the interval's steps
IntervalImpute = function(data_set){
    unique_intervals = unique(data_set$interval)
    filtered_interval = {}
    complete_data_set = data_set
    
    for(interv in unique_intervals){
        only_steps = data_set %>% filter(interval == interv & !is.na(steps)) %>% select(steps)
        steps_mean = mean(only_steps$steps)
        complete_data_set = complete_data_set %>% 
            mutate(steps = ifelse(is.na(steps) & interval == interv & is.na(steps), steps_mean,steps))
    }
    
    return(complete_data_set)
}
complete_activity = IntervalImpute(activity)


## Convert the complete_activity date column to dates
complete_activity$date = ymd(complete_activity$date)

## Mutate a new column to show whether it is a weekday or not
complete_activity = complete_activity %>% 
    mutate(weekday = ifelse(wday(date) > 1 & wday(date) < 7,TRUE,FALSE)) %>% 
    mutate(DayOfWeek = wday(date,label=TRUE))

## Group the complete data by 5-minute interval and weekday or weekend
complete_weekday = complete_activity %>% 
    filter(weekday == TRUE) %>% 
    group_by(interval) %>% 
    summarise_each(funs(mean)) %>% 
    select(interval,steps)

complete_weekend = complete_activity %>% 
    filter(weekday == FALSE) %>% 
    group_by(interval) %>% 
    summarise_each(funs(mean)) %>% 
    select(interval,steps)

## Create the Plot
par(mfrow=c(2,1))

plot(complete_weekend$interval,complete_weekend$steps,
     type = 'l',
     ylab = 'Avg. Number of Steps',
     xlab = 'Interval',
     main='Weekend')

plot(complete_weekday$interval,complete_weekday$steps,
     type = 'l',
     ylab = 'Avg. Number of Steps',
     xlab = 'Interval',
     main='Weekday')
