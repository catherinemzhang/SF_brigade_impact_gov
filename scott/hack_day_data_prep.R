library(dplyr)
library(readr)

# Make csv with percent change better or worse than goal
perf.measures.FY13 <- read.csv('../data/Citywide_Performance_Measurement_Annual_Report_FY13_Dataset.csv')
perf.measures.FY14 <- read.csv('../data/Citywide_Performance_Measurement_Annual_Report_FY14_Dataset.csv')

goal.evaluater <- function(row, actual.col, target.col){
    actual = as.numeric(row[actual.col])
    target = as.numeric(row[target.col])
    if(row['Performance.Pattern'] == 'Below target is positive'){
        actual < target
    }else if(row['Performance.Pattern'] == 'Above target is positive'){
        actual > target
    }else{
        # Checked within 5% is good for now, needs more research
        (target-actual)/target < .05 & (target-actual)/target > -.05
    }
}

goal.percents <- function(row, actual.col, target.col){
    actual = as.numeric(row[actual.col])
    target = as.numeric(row[target.col])
    if(row['Performance.Pattern'] == 'Below target is positive'){
        -(round((actual-target)/target, 4) * 100)
    }else if(row['Performance.Pattern'] == 'Above target is positive'){
        round((actual-target)/target, 4) * 100
    }else{
        # if this is big it should be bad... need better way
        # if the target is 0 it gives inf, that's not ideal
        round(1 - abs((actual-target)/target), 4) * 100
    }
}


perf.measures.FY13$met.goal <- apply(perf.measures.FY13, 1, goal.evaluater,
                                     'FY.2013...Total.Actual.Data',
                                     'FY.2013...Total.Target.Data')

perf.measures.FY14$met.goal <- apply(perf.measures.FY14, 1, goal.evaluater,
                                     'FY.2014...Total.Actual.Data',
                                     'FY.2014...Total.Target.Data')

perf.measures.FY13$goal.percent <- apply(perf.measures.FY13, 1, goal.percents,
                                        'FY.2013...Total.Actual.Data',
                                        'FY.2013...Total.Target.Data')

perf.measures.FY14$goal.percent <- apply(perf.measures.FY14, 1, goal.percents,
                                         'FY.2014...Total.Actual.Data',
                                         'FY.2014...Total.Target.Data')

write_csv(perf.measures.FY13, 'Performance_Measurement_w_goals_FY_13.csv')
write_csv(perf.measures.FY14, 'Performance_Measurement_w_goals_FY_14.csv')

