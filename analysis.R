## Set the working directory and load required packages
setwd("~/JHU DataScience Courses/R Directory/RepData_PeerAssessment1")
library(data.table)
library(dplyr)
library(Amelia)

## Load in the data
activity = data.table(read.csv('activity.csv'))

## FIll in the missing values for later use
activity = 

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
imputed_activity = 
