library(dplyr)
library(readr)

# Make csv with percent change better or worse than goal
perf.measures.FY13 <- read.csv('../data/Citywide_Performance_Measurement_Annual_Report_FY13_Dataset.csv')
perf.measures.FY14 <- read.csv('../data/Citywide_Performance_Measurement_Annual_Report_FY14_Dataset.csv')

# return if the goal was met/surpassed or not
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

# return the percent over/under their goal they are
goal.percents <- function(row, actual.col, target.col){
    actual = as.numeric(row[actual.col])
    target = as.numeric(row[target.col])
    if(row['Performance.Pattern'] == 'Below target is positive'){
        -(round((actual-target)/target, 4) * 100)
    }else if(row['Performance.Pattern'] == 'Above target is positive'){
        round((actual-target)/target, 4) * 100
    }else{
        # if this is big it should be bad... need better way
        # Catherine is going to toss them out for now
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

# Make csv with budget with % change from last year numbers were last year.
# Grouped by Program and Departments

budget <- read.csv('../data/Budget.csv', stringsAsFactors = FALSE)

# Sum money by department's program
# The arrange makes offsetting to get prev year work
sum.budget <- group_by(budget, Fiscal.Year, Program, Department) %>%
    summarize(Amount = sum(Amount))%>%
    ungroup() %>%
    arrange(Department, Program, desc(Fiscal.Year))

# Create an one row offset version of the budget
prev.sum.budget <- rbind(sum.budget[2:nrow(sum.budget),],
                         sum.budget[1,])

# Check if previous year for same department and program
# If true return previous year's budget else NA
sum.budget$prev.year.amount<- ifelse(
    sum.budget$Program == prev.sum.budget$Program &
        sum.budget$Department == prev.sum.budget$Department &
        sum.budget$Fiscal.Year - 1 == prev.sum.budget$Fiscal.Year,
    prev.sum.budget$Amount,
    NA
    )

# Find percent change from last years budget
sum.budget$percent.change <- with(sum.budget, 
                                  (Amount-prev.year.amount)/prev.year.amount)

write_csv(sum.budget, 'programs_budget_amount_change.csv')



########### Same as Budget but for Spending and Revenue ########################
############# Copy and pasted for speed and laziness ###########################

# Force error if I made a mistake copying
rm(list=c('budget', 'sum.budget', 'prev.sum.budget'))

spend.rev <- read.csv('../data/Spending_And_Revenue.csv',
                   stringsAsFactors = FALSE)

# Sum money by department's program
# The arrange makes offsetting to get prev year work
sum.spend.rev <- group_by(spend.rev, Fiscal.Year, Program, Department) %>%
    summarize(Amount = sum(Amount))%>%
    ungroup() %>%
    arrange(Department, Program, desc(Fiscal.Year))

# Create an one row offset version of the budget
prev.sum.spend.rev <- rbind(sum.spend.rev[2:nrow(sum.spend.rev),],
                         sum.spend.rev[1,])

# Check if previous year for same department and program
# If true return previous year's budget else NA
sum.spend.rev$prev.year.amount<- ifelse(
    sum.spend.rev$Program == prev.sum.spend.rev$Program &
        sum.spend.rev$Department == prev.sum.spend.rev$Department &
        sum.spend.rev$Fiscal.Year - 1 == prev.sum.spend.rev$Fiscal.Year,
    prev.sum.spend.rev$Amount,
    NA
)

# Find percent change from last years budget
sum.spend.rev$percent.change <- with(sum.spend.rev, 
                                  (Amount-prev.year.amount)/prev.year.amount)

write_csv(sum.spend.rev, 'spending_revenue_amount_change.csv')

