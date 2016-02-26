# Starting with just the budget and performance measures we can 
# expand as we decide which we are using for what since some are
# pretty big.

# Being lazy I did find and replace to make all \ into \\ seem to
# only be used in data dicts but we need to double all backslashes
# as we add more.

if(dir.exists('data') == FALSE){
 dir.create('data')
}

if(dir.exists('data/Data_Dictionaries') == FALSE){
    dir.create('data/Data_Dictionaries')
}

# Budget 
# https://data.sfgov.org/City-Management-and-Ethics/Budget/xdgd-c79v
if(!file.exists('data/Budget.csv')){
    download.file('https://data.sfgov.org/api/views/xdgd-c79v/rows.csv?accessType=DOWNLOAD',
                  'data/Budget.csv',
                  method = 'curl')
    download.file('https://data.sfgov.org/api/views/xdgd-c79v/files/U8jXOCaazl-D34n4IOPX-V_Ej0yokzhqj-yTPDQhCns?download=true&filename=N:\\EIS\\DataCoordination\\Metadata%20Spring%20Cleaning\\CON_DataDictionary_Budget.pdf',
                  'data/Data_Dictionaries/CON_DataDictionary_Budget.pdf',
                  method = 'curl')
}

# Spending and Revenue
# # https://data.sfgov.org/City-Management-and-Ethics/Spending-And-Revenue/bpnb-jwfb
if(!file.exists('data/Spending_and_Revenue.csv')){
    download.file('https://data.sfgov.org/api/views/bpnb-jwfb/rows.csv?accessType=DOWNLOAD', 
                  'data/Spending_and_Revenue.csv',
                  method = 'curl')
    download.file('https://data.sfgov.org/api/views/bpnb-jwfb/files/l4Kfvck4E4fPLMGB6_qQdbLzKTmY9X3s8Xcnz0gF-w4?download=true&filename=N:\\EIS\\DataCoordination\\Metadata%20Spring%20Cleaning\\CON_DataDictionary_Spending-and-Revenue.pdf',
                  'data/Data_Dictionaries/CON_DataDictionary_Spending-and-Revenue.pdf',
                  method = 'curl')
}



# FY14 Performance Measures 
# https://data.sfgov.org/City-Management-and-Ethics/Citywide-Performance-Measurement-Annual-Report-FY1/6h77-suve
if(!file.exists('data/Citywide_Performance_Measurement_Annual_Report_FY14_Dataset.csv')){
    download.file('https://data.sfgov.org/api/views/6h77-suve/rows.csv?accessType=DOWNLOAD',
                  'data/Citywide_Performance_Measurement_Annual_Report_FY14_Dataset.csv',
                  method = 'curl')
    download.file('https://data.sfgov.org/api/views/6h77-suve/files/VX0TQBunJkyaBZiq8PJCFJrA5pDLTzb_-Xh3-cm6woU?download=true&filename=\\\\CTL-CHFP01\\CSADiv\\CSA\\City%20Performance\\CP%20Projects\\Citywide%20Projects\\Performance_Measurement\\Performance%20Program%202015-16\\DataSF\\CON_DataDictionary_FY14PerformanceMeasures.pdf',
                  'data/Data_Dictionaries/CON_DataDictionary_FY14PerformanceMeasures.pdf',
                  method = 'curl')
}

# FY13 Performance Measures 
# https://data.sfgov.org/City-Management-and-Ethics/Citywide-Performance-Measurement-Annual-Report-FY1/5x94-tptc
if(!file.exists('data/Citywide_Performance_Measurement_Annual_Report_FY13_Dataset.csv')){
    download.file('https://data.sfgov.org/api/views/5x94-tptc/rows.csv?accessType=DOWNLOAD',
                  'data/Citywide_Performance_Measurement_Annual_Report_FY13_Dataset.csv',
                  method = 'curl')
    download.file('https://data.sfgov.org/api/views/5x94-tptc/files/mPFs8spck6JSpixNaV8VZF-0fXk8IWchISnnZB5EpL4?download=true&filename=\\\\CTL-CHFP01\\CSADiv\\CSA\\City%20Performance\\CP%20Projects\\Citywide%20Projects\\Performance_Measurement\\Performance%20Program%202015-16\\DataSF\\CON_DataDictionary_FY13PerformanceMeasures.pdf',
                  'data/Data_Dictionaries/CON_DataDictionary_FY13PerformanceMeasures.pdf',
                  method = 'curl')
}

# Vendor Payments (Purchase Order Summary) 815163 rows
# https://data.sfgov.org/City-Management-and-Ethics/Vendor-Payments-Purchase-Order-Summary-/p5r5-fd7g
# if(!file.exists('data/Vendor_Payments__Purchase_Order_Summary_.csv')){
#     download.file('https://data.sfgov.org/api/views/p5r5-fd7g/rows.csv?accessType=DOWNLOAD',
#                   'data/Citywide_Performance_Measurement_Annual_Report_FY13_Dataset.csv',
#                   method = 'curl')
#     download.file('https://data.sfgov.org/api/views/p5r5-fd7g/files/Znav_nsIc0RTKTn6Y1sIA4-9mMFvBWmOLHp_r4uCZJs?download=true&filename=N:\\All%20Departments\\DataCoordination\\Metadata%20Spring%20Cleaning\\CON_DataDictionary_Vendor-Payments-Purchase-Order-Summary.pdf',
#                   'data/Data_Dictionaries/CON_DataDictionary_Vendor-Payments-Purchase-Order-Summary',
#                   method = 'curl')
# }

# Vendor Payments (Vouchers) is 3254438 rows
