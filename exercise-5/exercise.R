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
  base.url <- "https://api.nytimes.com/svc/movies/v2/reviews/search.json?"
  api.key <- "7f7f7c39a049478e98436a4aec98f38e"
  query.params <- list(query = movie, api_key = api.key)
  response <- GET(base.url, query = query.params)
  body <- content(response, "text")
  
  # Request data using your search query
  results <- fromJSON(body)
  
  # What type of variable does this return?
  
  # Flatten the data stored in the `$results` key of the data returned to you
  flatten <- flatten(results$results)
  
  # From the most recent review, store the headline, short summary, and link to full article each in their own variables
  headline <- flatten[1, ]$headline
  short.summary <- flatten[1, ]$summary_short
  link <- flatten[1, ]$link.url
  
  # Return an list of the three pieces of information from above
  info <- list(headline=headline, short.summary=short.summary, link=link)
  return (info)
}

# Test that your function works with a movie of your choice
GetReview("Zootopia")
