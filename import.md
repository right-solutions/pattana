# Importing the data

Basic Usage

## Importing Master Data

Use the following scripts to import master data like countries, regions and cities

country data is an xlsx file.
region data is a csv file.
city data is a huge csv file and hence we have split it into small csv files.

pass verbose=false to avoid printing more details while running these commands.

### Importing countries

This will import countries parsing the excel file 'countries.xlsx' located in db/master_data
```rails import:master_data:countries```

### Importing regions

This will import countries parsing the csv file 'regions.csv' located in db/master_data
```rails import:master_data:regions```

### Importing cities

This will import countries parsing the cities folder recursively which has multiple small city files located in db/master_data/cities
```rails import:master_data:cities```


### Importing all together in one line

```rails import:master_data:countries import:master_data:regions import:master_data:cities```


## Testing the import scripts

### Single .csv File Import

This will import a single file 
```rails import:test:csv:single_file RAILS_ENV=test```


### Split Files (.csv) Importing

This will import all the files in a folder recursevely.
Run split_csv.sh script to split a large file into multiple small csv files keeping the header.
Make sure that the name of the big file is master.csv

```rails import:test:csv:split_files RAILS_ENV=test```


### Single .xlsx File Import

This will import a single file 
```rails import:test:xlsx:single_file RAILS_ENV=test```


### Split Files (.xlsx) Importing

This will import all the files in a folder recursevely.
Run split_csv.sh script to split a large file into multiple small csv files keeping the header.
Make sure that the name of the big file is master.csv


```rails import:test:xlsx:split_files RAILS_ENV=test```

### Single .sql File Import

This will import a single file 
```rails import:test:sql:file RAILS_ENV=test```



# Making the data for import 

About mentioned data is stored in SQL like a backup file with insert statements.

However, we might have to update these information periodically at times. The make_data rake tasks deals with those.

## Parse countries.xlsx file and save them to coutries

```rails import:master_data:countries```
```rails import:make_data:countries_lat_lon```

The last command would update the lat and lon for the countries


## Parse regions/*.csv files and save them to coutries

```rails import:master_data:regions```


## Parse cities/*.csv files and save them to coutries

```rails import:master_data:cities```


