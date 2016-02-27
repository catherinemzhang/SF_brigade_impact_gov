<a href="url"><img src="https://github.com/catherinemzhang/SF_brigade_impact_gov/blob/master/OrangeGov.png" align="left" height="70" width="90" ></a>

# ImpactGov
> Our mission is to increase the social return on investment for every dollar spent by the city of San Francisco.

###Data Sources

####Operational Data
* [Budget Data](https://data.sfgov.org/City-Management-and-Ethics/Budget/xdgd-c79v )
* [Spending and Revenue](https://data.sfgov.org/City-Management-and-Ethics/Spending-And-Revenue/bpnb-jwfb)
* [Vendor Payments (Purchase Order Summary)](https://data.sfgov.org/City-Management-and-Ethics/Vendor-Payments-Purchase-Order-Summary-/p5r5-fd7g)
* [Vendor Payments (Vouchers)](https://data.sfgov.org/City-Management-and-Ethics/Vendor-Payments-Vouchers-/n9pm-xkyq)
* [Citywide Performance Data 2014](https://data.sfgov.org/City-Management-and-Ethics/Citywide-Performance-Measurement-Annual-Report-FY1/6h77-suve)
* [Citywide Performance Data 2013](https://data.sfgov.org/City-Management-and-Ethics/Citywide-Performance-Measurement-Annual-Report-FY1/5x94-tptc)
* [1996-2011 City Survey Database (study of residents' perceptions of the quality of select City services)](https://data.sfgov.org/City-Management-and-Ethics/1996-2011-City-Survey-Database/583k-63vu)

####Market Data
* [San Francisco Development Pipeline 2015 Quarter 3](https://data.sfgov.org/Housing-and-Buildings/San-Francisco-Development-Pipeline-2015-Quarter-3/apz9-dh7k)
* [Eviction Notices](https://data.sfgov.org/Housing-and-Buildings/Eviction-Notices/5cei-gny5)
* [HSA 90 Day Emergency Shelter Waitlist](https://data.sfgov.org/Health-and-Social-Services/HSA-90-day-emergency-shelter-waitlist/w4sk-nq57)

####Get the Data
To get the data without manually going to each site, clone the repo and then run:
```
Rscript data_graber.R
```
Currently this will download Budget Data, Spending and Revenue, Citywide Performance Data 2014, and Citywide Performance Data 2013 into 'data' and their data dictionaries into 'data/Data_Dictionaries'. Will add the rest as we decide what all to use.

*ImpactGov is part of the [Data Science Working Group](https://github.com/sfbrigade/data-science-wg) at Code for San Francisco.*
