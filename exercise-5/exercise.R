### Exercise 5 ###
library(jsonlite)
library(dplyr)
library(httr)

# Write a function that allows you to specify a movie, that does the following:
GetReview <- function(movie) {
  
  # Construct a search query using YOUR api key
  # The base URL is https://api.nytimes.com/svc/movies/v2/reviews/search.json?
  # Your parameters should include a "query" and an "api_key"
  # Note: the HTTR library will take care of spaces in the arguments
  # See the interactive console for more detail:https://developer.nytimes.com/movie_reviews_v2.json#/Console/GET/reviews/search.json
  
  
  # Request data using your search query
  
  
  # What type of variable does this return?
  
  # Flatten the data stored in the `$results` key of the data returned to you
  
  
  # From the most recent review, store the headline, short summary, and link to full article each in their own variables
  

  # Return an list of the three pieces of information from above
  
}

# Test that your function works with a movie of your choice

