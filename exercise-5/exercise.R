### Exercise 5 ###
library(jsonlite)
library(dplyr)
library(httr)

# Write a function that allows you to specify a movie, then does the following:
GetReview <- function(movie) {
  
  # Construct a search query using YOUR api key
  # The base URL is https://api.nytimes.com/svc/movies/v2/reviews/search.json?
  # Your parameters should include a "query" and an "api_key"
  # Note: the HTTR library will take care of spaces in the arguments
  # See the interactive console for more detail:https://developer.nytimes.com/movie_reviews_v2.json#/Console/GET/reviews/search.json
  base.url <- 'https://api.nytimes.com/svc/movies/v2/reviews/search.json?'
  api.key <- "2d3963db35bb4d0f88f17a193b8c62e8"
  query.params <- list(query=movie, api_key = api.key)
  response <- GET(base.url, query = query.params)
  body <- content(response, "text")
  
  # Request data using your search query
  results <- fromJSON(body)
  
  # What type of variable does this return?
  
  # Flatten the data stored in the `$results` key of the data returned to you
  flattened <- flatten(results$results)
  
  # From the most recent review, store the headline, short summary, and link to full article each in their own variables
  first.review <- flattened[1,]
  headline <- first.review$headline
  summary <- first.review$summary_short
  link <- first.review$link.url

  # Return an list of the three pieces of information from above
  info <- list(headline=headline, summary=summary, link=link)
  return(info)
}

# Test that your function works with a movie of your choice
AlmostFamousInfo <- GetReview('Almost Famous')
