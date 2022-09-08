# Data Engineering
### From Start to Finish
There are various steps needed to create the final product. Please see the steps below as well as the MSSQL code I used to get the data.

### The ETL Process
* Staging Tables - See [TableCreation](https://github.com/romerogarza/DataEngineering/blob/main/TableCreation/TableCreation.sql)
* For this Dashboard, there was only one data set needed to populate this data. Otherwise, I would hit multiple sources.

### Data Engineering
* Once the data has been populated and brought into our staging tables, I'll begin to create the views that will sit on top of our table and will represent the different sections of the Dashboard.
* See [Views](https://github.com/romerogarza/DataEngineering/tree/main/DataManipulation) to see how data is manipulated, transformed and aggregated.

### Data Automation
* Jobs are scheduled within the SQL Server Agent to run at various times. Usually on a daily basis. This allows us to automate the data extraction by executing our Stored Procedures.

### Data Analysis
* This can be done in conjuction with the Data Engineer aspect. As aggregation gets under way, you can start to see where the numbers are. This is usually a milestone where I'll meet with the Stakeholder before visualization work begins and get feedback.

### Data Visualization
* With our views created and sectioned out, it makes easy work to create the Dashboard and overall telling the story. Please see below on the PowerBi screenshots of the Dashboard creation.

![ ](https://user-images.githubusercontent.com/90928939/189237637-aeb35f02-e6fc-4d40-a71b-a9896f9b8247.png)
