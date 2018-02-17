#### Open Food Hackdays
## Date: 2018-02-16 
rm(list = objects(pattern = ".*")) # remove all existing objects


## Standard directory structure for all scripts --------------------------------
root <- "C:/Users/etien/Dropbox/MSE/Hackdays/"      
pathIn <- paste0(root, "data/")          # Path for data to be read into R


# Prognolite GmbH API ---------------------------------------------------------
# oAuth2 (Access_token flow for the prognolite.com api)
# Include this file in your project. See sample to receive data at bottom of this file
#
# TODO: use refresh token!
#
# CONFIG:
base_path = pathIn
#
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE,repos = "https://stat.ethz.ch/CRAN/")
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}
pkgTest("httr")
pkgTest("xml2")
pkgTest("readr")
library(httr)
library(xml2)
library(readr)
source(paste(base_path,"lib-refresh_token.R",sep="/"))
res_auth <- POST("https://api.prognolite.com/1.0/oauth/access_token.json",
                 body = list(grant_type = "password",
                             client_id = "hEVoxbEB7qkt2yuysgwo",
                             client_secret = "MLtZAZ2BF6KiEvFeKNnsYQkeC9WHhEMMlq9E2rvb",
                             username="openhackdays18@prognolite.ch",
                             password="mWUtsY7UpPS"
                 )
)
token <- content(res_auth,type="application/json")$access_token





## install packages ------------------------------------------------------------
# install.packages("anytime")
library(anytime)
# install.packages("data.table")
library(data.table)
# install.packages("randomForest")
library(randomForest)
# install.packages("IDPmisc")
library(IDPmisc)
# install.packages("caret")
library(caret)





## Import Data from csv --------------------------------------------------------
dtReservations <- fread(input = paste0(pathIn, "reservation_data_cleaned.csv"))
dtWeather <- fread(input = paste0(pathIn, "weather-data.csv"))
dtTurnover <- fread(input = paste0(pathIn, "turnover2017.csv"))
names(dtReservations)

str(dtReservations)
str(dtWeather)
str(dtTurnover)
summary(dtReservations)
summary(dtWeather)
summary(dtTurnover)


## Reservation Data Prepartion ------------------------------------------------------------
## Remove obeservation where status is not equal to "Abgereist", "Am Platz", 
# "besteatigt", "Eingetroffen", "Walk-In"

dtReservations[, table(status)]
dtReservations <- dtReservations[status %in% c("Abgereist", "Am Platz", 
                                               "besteatigt", "Eingetroffen", 
                                               "Walk-In"),]
dtReservations[, table(status)]

## Remove Variable connected to time (many observation show mistakes, 
# e.g. reservation was made after start)
str(dtReservations)
dtReservations[,c("start_time", "end_time", "reservation_made_on") := NULL]
str(dtReservations)

## Variable date als Datum formatieren
date <- dtReservations[,date]
dtReservations[,date := as.POSIXct(x = date, format = "%d.%m.%Y")]


## OUTDATED: create timestamps
# ?strptime
# # timestamp_start
# timestamp_start <- paste(dtReservations[,date], dtReservations[,start_time], sep = " ")
# timestamp_start <- as.POSIXct(x = timestamp_start, format = "%d.%m.%Y %H:%M")
# dtReservations[,timestamp_start := as.POSIXct(timestamp_start, format = "%d.%m.%Y %H:%M")]
# 
# # timestamp_end
# timestamp_end <- paste(dtReservations[,date], dtReservations[,end_time], sep = " ") 
# timestamp_end <- as.POSIXct(x = timestamp_end, format = "%d.%m.%Y %H:%M")
# dtReservations[,timestamp_end := as.POSIXct(timestamp_end, format = "%d.%m.%Y %H:%M")]
# 
# # timestamp_reservation
# timestamp_reservation <- as.POSIXct(x = dtReservations[,reservation_made_on], format = "%d.%m.%Y %H:%M")
# dtReservations[,timestamp_reservation := as.POSIXct(timestamp_reservation, format = "%d.%m.%Y %H:%M")]


## OUTDATED: add variable duration of stay
# stay_duration_minutes <- (timestamp_end - timestamp_start) / 60
# dtReservations[,stay_duration_minutes := stay_duration_minutes]

## OUTDATED: add variable duration between reservation and start
# duration_reservation_days <- as.numeric(round(((timestamp_start-timestamp_reservation) / 60 / 60 / 24), 2))
# dtReservations[,duration_reservation_days := NULL]
# dtReservations[,duration_reservation_days := duration_reservation_days]



## OUTDATED: Analyse duration after reservation
# dtReservations[, range(duration_reservation_days)]
# dtReservations[, tail(sort(duration_reservation_days),10)]  #
# dtReservations[, head(sort(duration_reservation_days),10)]
# temp.dt <- dtReservations[duration_reservation_days < 0, ]

# str(dtReservations)
# dtReservations[, hist(duration_reservation_days, breaks = 100)]



## Visualisation of variable status as pie chart
dtReservations[,table(status)]
dtReservations[,pie(table(status))]



## Add variable like hour of day, day of week etc.
?strptime
str(dtReservations)

dtReservations[,`:=` (yearN = as.numeric(format(date, format = "%Y")),
                      monthN = as.numeric(format(date, format = "%m")),
                      monthdayN = as.numeric(format(date, format = "%d")),
                      weekdayN = as.numeric(format(date, format = "%u"))
)]

dtReservations[, weekdayC := format(date, format = "%A")]

## OUTDATED:
# dtReservations[,`:=` (yearN = as.numeric(format(timestamp_start, format = "%Y")),
#                       monthN = as.numeric(format(timestamp_start, format = "%m")),
#                       hourN = as.numeric(format(timestamp_start, format = "%H")),
#                       weekdayN = as.numeric(format(timestamp_start, format = "%u")),
#                       minuteN = as.numeric(format(timestamp_start, format = "%M"))
#                       )]
# dtReservations[,"qhourN" := hourN + (minuteN %/% 15)*0.25]




### Analysis of different variables --------------------------------------------

# Number of rows per year
dtReservations[,table(yearN)]
dtReservations[,barplot(table(yearN), main = "Number of rows per year")]  

# number of rows per month
dtReservations[,table(monthN)]
dtReservations[,barplot(table(monthN), main = "Number of rows per month")]
mtext("January is 1")

# number of rows per weekday
dtReservations[,table(weekdayN)]
dtReservations[,barplot(table(weekdayN), main = "Number of rows per weekday")] 
mtext("Monday is 1")

# number of rows per monthday
dtReservations[,table(monthdayN)]
dtReservations[,barplot(table(monthdayN), main = "Number of rows per day of month")] 

## Modify variable shift: only abend or mittag
dtReservations[shift %in% c("1. MITTAG", "MITTAG"),shift := "mittag"] 
dtReservations[shift %in% c("2. ABEND", "ABEND"),shift := "abend"] 
dtReservations[,table(shift)]


## Aggregation number of people ------------------------------------------------
str(dtReservations)
# people ~ date + shift
agg_people_date <- aggregate(people ~ date + shift, data = dtReservations, FUN = sum)
head(agg_people_date)
agg_people_date <- as.data.table(agg_people_date)
agg_people_date[,table(shift)]
str(agg_people_date)
agg_people_date[shift %in% "abend",]

dtAbend <- data.table(agg_people_date[shift %in% "abend",])
dtMittag <- data.table(agg_people_date[shift %in% "mittag",])


dtAbend[,`:=` (yearN = as.numeric(format(date, format = "%Y")),
               monthN = as.numeric(format(date, format = "%m")),
               monthdayN = as.numeric(format(date, format = "%d")),
               weekdayN = as.numeric(format(date, format = "%u"))
)]
dtAbend[,date := NULL]
dtAbend[,shift := NULL]
fwrite(x = dtAbend, file = paste0(pathIn, "dtAbend.csv"), sep = ";")



dtMittag[,`:=` (yearN = as.numeric(format(date, format = "%Y")),
               monthN = as.numeric(format(date, format = "%m")),
               monthdayN = as.numeric(format(date, format = "%d")),
               weekdayN = as.numeric(format(date, format = "%u"))
)]
dtMittag[,date := NULL]
dtMittag[,shift := NULL]
# fwrite(x = dtMittag, file = paste0(pathIn, "dtMittag.csv"), sep = ";")


## Prediction Mittag: Random Forest --------------------------------------------
set.seed(1)
rf.mittag <- randomForest(formula = people ~ yearN + monthN + monthdayN + weekdayN, 
                          data = dtMittag,
                          mtry = 1)
dates_prediction <- seq(from=as.Date("01.01.2018", format="%d.%m.%Y"), 
                        to=as.Date("31.12.2018", format="%d.%m.%Y"),
                        by = "days")
test_data <- data.table(c(rep(NA,length(dates_prediction))), dates_prediction)



colnames(test_data) <- c("people", "date")
test_data[,date := as.POSIXct(x = date, format = "%d.%m.%Y")]
test_data[,`:=` (yearN = as.numeric(format(date, format = "%Y")),
                 monthN = as.numeric(format(date, format = "%m")),
                 monthdayN = as.numeric(format(date, format = "%d")),
                 weekdayN = as.numeric(format(date, format = "%u"))
)]

test_data[,date := NULL]
rf.mittag.prediction <- predict(rf.mittag, newdata = test_data)
rf.mittag.prediction

dtPrediction <- data.table(dates_prediction, rf.mittag.prediction)
colnames(dtPrediction) <- c("date", "prediction_mittag")
# fwrite(x = dtPrediction, file = paste0(pathIn, "dtPrediction.csv"), sep = ";")



## Prediction Abend: Random Forest --------------------------------------------
set.seed(1)
rf.abend <- randomForest(formula = people ~ yearN + monthN + monthdayN + weekdayN, 
                          data = dtAbend,
                          mtry = 1)

rf.abend.prediction <- predict(rf.abend, newdata = test_data)
rf.abend.prediction
dtPrediction[,"prediction_abend" := rf.abend.prediction]
unix_timestamps <- as.numeric(as.POSIXct(dtPrediction[,date], format="%d.%m.%Y"))

dtPrediction[,"date_UNIX" := unix_timestamps]
# fwrite(x = dtPrediction, file = paste0(pathIn, "dtPrediction.csv"), sep = ";")

dtPrediction[,`:=` (yearN = as.numeric(format(date, format = "%Y")),
                    monthN = as.numeric(format(date, format = "%m")),
                    monthdayN = as.numeric(format(date, format = "%d")),
                    weekdayN = as.numeric(format(date, format = "%u"))
)]



## Uploading data to api --------------------------------------------
#
data <- dtPrediction
data[,c("date", "yearN", "monthN", "monthdayN", "weekdayN") := NULL]

date_today <- as.numeric(as.POSIXct("01.01.2018", format="%d.%m.%Y"))
data_upload <- list(
  data=list(
    'prediction_mittag'=list(
        name='f-sample-lunch_hd18',
        timestamp=date_today,
        values=data[,prediction_mittag]
    ),
    'prediction_abend'=list(
      name='f-sample-evening_hd18',
      timestamp=date_today,
      values=data[,prediction_abend]
    )
  ),
  timestamps=data$date_UNIX
)

 

url <- "https://api.prognolite.com/1.0/en-gb/timeseries/post"
res <- POST(url, add_headers('Authorization' = paste("Bearer", token), 
                              'Content-Type' = "application/x-www-form-urlencoded"), 
            encode = "json", body=data_upload,verbose()) 
