#-----------------------------------------------------------------------#
#       Exploration of Budget and Spending and Revenue                  #
#       Data from SF Open Data                                          #
#       Author: Rocio Ng                                                #
#       Created:    02/17/16                                            #
#       Updated:    02/20/16                                            #
#-----------------------------------------------------------------------#
source("data_graber.R") # for downloading .csv budget data files
library(dplyr)
library(ggplot2)
library(ggthemes)


budget <- read.csv("./data/Budget.csv")
spending_revenue <- read.csv("./data/Spending_and_Revenue.csv",
                             na.strings = "")
head(spending_revenue)
colnames(spending_revenue)
summary(spending_revenue)
str(spending_revenue)
    # Counts for each variable
    apply(spending_revenue, MARGIN = 2,FUN = function(x) length(unique(x)))
    organizations <- t(table(spending_revenue$Organization.Group))
    apply(budget, MARGIN = 2,FUN = function(x) length(unique(x)))
    organizations <- t(table(spending_revenue$Organization.Group))

#------------------- Overview of Data ------------------#
#   Fiscal.Year: (18 years)  1999-2016                  #
#                                                       #
#   Organization.Group : Group of Depts - 7             #
#   Department: Primary organizational unit - 81        #
#   Program: Services provided by a department - 586    #
#                                                       #
#   Type Hierarchy                                      #
#       Character -> Object -> Sub.object               #
#                                                       #
#   Fund Hierarchy                                      #
#       Fund.Type -> Fund -> Fund.Category              #
#-------------------------------------------------------#   

#---------- Exploration of Spending and Revenue Data --------------#
    
    # For getting distibution of Programs, Depts and Organization
    program_counts <- spending_revenue %>% 
                        group_by(Organization.Group,
                                 Department.Code,
                                 Department) %>%
                        summarise(total_programs = n_distinct(Program.Code))
    department_counts <- spending_revenue %>%
                            group_by(Organization.Group) %>%
                            summarise(total_departments = 
                                          n_distinct(Department.Code))
    head(program_counts, 10)
    head(department_counts, 7)

    #----------- Plots ----------#
    # count of organizations
    ggplot(aes(Organization.Group, y = total_departments), 
           data = department_counts) + 
        geom_bar(stat = "identity", fill = "#3333FF") + 
        theme(axis.text.x = element_text(angle = 20, hjust = 1))+
        labs(title = "Count of Departments within Organizations",
             x = "Organization", y = "Total Departments")
    ggplot(aes(Department, y = total_programs,
               fill = as.factor(Organization.Group)), 
           data = program_counts) + 
        geom_bar(stat = "identity") +
        labs(title = "Count of Programs within Departments and Organizationa") + 
        coord_flip()

funds_overview <- spending_revenue %>% 
                    group_by(Revenue.or.Spending,
                             Fund.Type.Code,
                             Fund.Type,
                             Fund.Code,
                             Fund,
                             Fund.Category.Code,
                             Fund.Category) %>%
                    summarise(count = n())
ggplot(aes(Fund.Category), data = funds_overview) +
    geom_bar(stat= "count")

#--------- Exploration of Funds within the Public Protection Organization --------------#
    public_protection <- spending_revenue %>% 
        filter(Organization.Group == "Public Protection")
    
    # spending/revenue over time
    # *** For now negative values are removed ****
    public_protection <- public_protection %>% filter(Amount >0,
                                                      Fiscal.Year!=2016) # 2016 incomplete
    public_protection_by_year <- public_protection %>%
                                group_by(Fiscal.Year, Revenue.or.Spending)%>%
                                summarise(total_amount = sum(Amount)) 
    ggplot(aes(x = Fiscal.Year, 
               y = total_amount, 
               group = Revenue.or.Spending,
               color = Revenue.or.Spending),
            data = public_protection_by_year) + 
            geom_point() + geom_line() + 
            labs(title = "Public Protection", y = "total", x = "Fiscal Year") +
        theme(legend.title = element_blank()) + 
        scale_y_continuous(labels = scales::dollar)
#--------------------------------------------------------------------------------------#
# Look at spending and revenue over all the Organizations
by_year_org <- spending_revenue%>%
                        filter(Amount > 0, Fiscal.Year != 2016) %>%
                        group_by(Fiscal.Year, 
                                 Revenue.or.Spending, 
                                 Organization.Group) %>%
                        summarise(total_amount = sum(Amount))

#---- Plot of spending and revenue across all the ORa
p <- ggplot(aes(x = Fiscal.Year, 
           y = total_amount, 
           group = Revenue.or.Spending,
           color = Revenue.or.Spending),
       data = by_year_org) + geom_point()+
    theme_economist_white() + 
    geom_line() + facet_wrap(~Organization.Group, ncol=3, scales = "free") + 
    scale_y_continuous(labels = scales::dollar) +
    theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
    theme(legend.title = element_blank(), 
          legend.key =element_rect(fill = NA) ) +
    labs(title="Yearly Spending and Revenue by Organization",
         x = "Fiscal Year", y = "Total") 
p + theme(strip.text.x = element_text(size = 6)) 
    
ggplot(aes(x = Organization.Group, 
           y = total_amount,
           fill = Revenue.or.Spending),
       data = positive_amounts_year) + geom_bar(stat = "identity", position = "dodge")+
    facet_grid(Fiscal.Year ~ Revenue.or.Spending) +
    scale_y_continuous(labels = scales::dollar) + 
    theme(axis.text.x = element_text(angle = 30, hjust = 1))


#---- BUDGET Over and Underspeanding OVer time ----#
# *** for now only using positive amounts

# budgeted spending over time
budget_by_dept <- budget %>% 
    filter(Amount > 0, Revenue.or.Spending == "Spending", Fiscal.Year <2016) %>%
    group_by(Fiscal.Year, 
             Department) %>%
    summarise(budget_amount = sum(Amount)) %>%
    mutate( year_dept = paste(Fiscal.Year, Department)) %>% as.data.frame()
head(budget_by_dept)    
# actual spending over time

rev_spend_by_dept <- spending_revenue %>% 
    filter(Amount > 0, Revenue.or.Spending == "Spending", Fiscal.Year< 2016) %>%
    group_by(Fiscal.Year, 
             Revenue.or.Spending, 
             Department) %>%
    summarise(spending_amount = sum(Amount))  %>%
    mutate( year_dept = paste(Fiscal.Year, Department)) %>% as.data.frame() %>%
    select(year_dept, spending_amount)
head(rev_spend_by_dept)
total <- inner_join(budget_by_dept, rev_spend_by_dept, by = "year_dept") %>% droplevels()

total <- total %>% select(Fiscal.Year, Department,
                          budget_amount, spending_amount)
total <- total %>% mutate(ratio = budget_amount/spending_amount)

library(plotly)
p <- ggplot(aes(x = Fiscal.Year, y = ratio, group = Department, color = Department),
       data = total) + geom_line()
p
ggplotly(p)






# separate negative and positive values in one year
negative_2014 <- spending_revenue %>% filter(Amount <0, Fiscal.Year == 2014) %>% droplevels()
positive_2014 <- spending_revenue %>% filter(Amount >0, Fiscal.Year == 2014) %>% droplevels()
negative_2014 %>% group_by(Revenue.or.Spending) %>% 
    summarise(total_amount = sum(Amount))
positive_2014 %>% group_by(Revenue.or.Spending) %>%
    summarise(total_amount = sum(Amount))
negative_2014 %>% group_by(Revenue.or.Spending, Fund.Category.Code,
                           Fund.Category) %>%
    summarise(count = n())

# Overview of positive vs negative spending/revenue
negative_spending <- spending_revenue %>% 
    filter(Amount <0, Revenue.or.Spending == "Spending") %>% 
    droplevels()
negative_revenue <- spending_revenue %>% 
    filter(Amount <0, Revenue.or.Spending == "Revenue") %>% 
    droplevels()
positive_spending <- spending_revenue %>% 
    filter(Amount > 0, Revenue.or.Spending == "Spending") %>%
    droplevels()
summary(negative_spending)
negative_spending_types <- apply(negative_spending, 2, unique)
negative_spending_types$Object
negative_spending_types$Fund.Category
summary(negative_revenue)
negative_revenue_types <- apply(negative_revenue, 2, unique)
negative_revenue_types$Object
negative_revenue_types$Fund.Category



summary(positive_spending)
positive_spending_types <- apply(positive_spending, 2, unique)
positive_spending_types$Object
positive_spending_types$Fund.Category



