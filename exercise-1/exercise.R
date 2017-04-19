### Exercise 1 ###

# Load the httr and jsonlite libraries for accessing data
library("httr")
library("jsonlite")

## For these questions, look at the API documentation to identify the appropriate endpoint and information.
## Then send GET() request to fetch the data, then extract the answer to the question

# For what years does the API have statistical data?
response <- GET("http://data.unhcr.org/api/stats/time_series_years.json")
body <- content(response,"text")
years <- fromJSON(body)
years

# What is the "country code" for the "Syrian Arab Republic"?
response <- GET("http://data.unhcr.org/api/countries/list.json")
countries <- fromJSON(content(response, "text"))
filter(countries, name_en == "Syrian Arab Republic") %>%
  select(country_code)

# How many persons of concern from Syria applied for residence in the USA in 2013?
# Hint: you'll need to use a query parameter
# Use the `str()` function to print the data of interest
# See http://www.unhcr.org/en-us/who-we-help.html for details on these terms
query.params <- list(country_of_residence = "USA", country_of_origin = "SYR", year = 2013)
response <- GET("http://data.unhcr.org/api/stats/persons_of_concern.json", query = query.params)
usa.persons <- fromJSON(content(response,"text"))
str(usa.persons)

## And this was only 2013...


# How many *refugees* from Syria settled the USA in all years in the data set (2000 through 2013)?
# Hint: check out the "time series" end points
query.params <- list(country_of_residence = "USA", country_of_origin = "SYR", population_type_code = "RF")
response <- GET("http://data.unhcr.org/api/stats/time_series_all_years.json?", query = query.params)
refugees.usa <- fromJSON(content(response,"text"))
refugees.usa <- select(refugees.usa, year, usa = value)

# Use the `plot()` function to plot the year vs. the value.
# Add `type="o"` as a parameter to draw a line
plot(refugees.usa, type="o")


# Pick one other country in the world (e.g., Turkey).
# How many *refugees* from Syria settled in that country in all years in the data set (2000 through 2013)?
# Is it more or less than the USA? (Hint: join the tables and add a new column!)
# Hint: To compare the values, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`

query.params <- list(country_of_residence = "TUR", country_of_origin = "SYR", population_type_code = "RF")
response <- GET("http://data.unhcr.org/api/stats/time_series_all_years.json?", query = query.params)
refugees.other <- fromJSON(content(response,"text"))
refugees.other <- select(refugees.other, year, other = value)
refugees.other

left_join(refugees.usa, refugees.other, by="year") %>%
    mutate(usa = as.numeric(usa), other = as.numeric(other)) %>%
    mutate(usa.more = usa > other)

## Bonus (not in solution):
# How many of the refugees in 2013 were children (between 0 and 4 years old)?


## Extra practice (but less interesting results)
# How many total people applied for asylum in the USA in 2013?
# - You'll need to filter out NA values; try using `is.na()`
# - To calculate a sum, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`
query.params <- list(country_of_asylum = "USA", year = 2013)
response <- GET("http://data.unhcr.org/api/stats/asylum_seekers.json", query = query.params)
usa.seekers <- fromJSON(content(response,"text"))
select(usa.seekers, applied_during_year) %>%
  filter(is.na(applied_during_year) == FALSE) %>%  # remove NA values
  mutate(applied_during_year = as.numeric(applied_during_year)) %>%  # make numbers
  summarize(sum(applied_during_year))

## Also note that asylum seekers are not refugees
