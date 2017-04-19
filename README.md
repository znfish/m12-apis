# Introduction to Application Programming Interfaces

The term _*Application Programming Interface*_ (API, for short) encompasses a broad set of utilities (protocols, tools) used for building software. In fact, the term API could appropriately describe some of the libraries we've been using in R, such as `DPLYR`. The general pattern used by `DPLRY` and steps necessary for using it are referred to as it's API. This is well described on [WikiPedia](https://en.wikipedia.org/wiki/Application_programming_interface):

>the API describes and prescribes the expected behavior while the library is an _actual implementation_ of this set of rules

In addition to exposing _functions_ for buidling software, APIs are often built to expose _data_ components. The focus of this learning module is to focus on accessing data from APIs that expose _data_ as their primary function.


Helpful links:

- [URIs (Wikipedia)](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)
- [WikiPedia- APIS](https://en.wikipedia.org/wiki/Application_programming_interface)
- [HTTP Protocol Tutorial](https://code.tutsplus.com/tutorials/http-the-protocol-every-web-developer-must-know-part-1--net-31177)
- [Programmable Web](http://www.programmableweb.com/) (list of web APIs; may be out of date)
- [Spotify Web API](https://developer.spotify.com/web-api/)
- [JSON View Extension](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en)
- [`httr` documentation](https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html)
- [`jsonlite` documentation](https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf)
- [RESTful Architecture](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) (original specification; not for beginners)

## Web APIs
An **interface** is the point at which two different systems meet and _communicate_: exchanging informations and instructions. An **Application Programming Interface (API)** thus represents a way of communicating with a computer application by writing a computer program (a set of formal instructions understandable by a machine). APIs commonly take the form of **functions** that can be called to give instructions to programs&mdash;the set of functions provided by a library like `dplyr` make up the API for that library.
While most APIs provide an interface for utilizing _functionality_, other APIs provide an interface for accessing _data_. One of the most common sources of these data apis are **web services**: websites that offer an interface for accessing their data.

With web services, the interface (the set of "functions" we can call to access the data) takes the form of **HTTP Requests**&mdash;that is, a _request_ for data sent following the _**H**yper**T**ext **T**ransfer **P**rotocol_. This is the same protocol (way of communicating) used by your browser to view a web page! An HTTP Request represents a message that your computer sends to a web server (another computer on the Internet which "serves", or provides, information). That server, upon receiving the request, will determine what data to include in the **response** it sends _back_ to the requesting computer. With a web browser the response data takes the form of HTML files that the browser can _render_ as web pages; with data APIs the response data will be structured data that we can convert into structures such as lists or data frames.

In short, loading data from an Web API involves sending an **HTTP Request** to a server for a particular piece of data, and then receiving and parsing the **response** to that request.

## URIs
Which **resource** you want to access is specified with a **Uniform Resource Indicator (URI)**. A URI is a generalization of a URL (Uniform Resource Locator)&mdash;what we commonly think of as "web addresses". URIs act a lot like the _address_ on a postal letter sent within a large organization such as a university: you indicate the business address as well as the department and the person, and will get a different response (and different data) from Alice in Accounting than from Sally in Sales.

- Note that the URI is known as the **identifier** for the resource, while the **resource** is the actual _data_ that you want to access.

Like postal letter addresses, URIs have a very specific format used to direct the request to the right resource.

![URI Schema](m12-imgs/uri-schema.png)

Note all parts of the format are required (e.g., you don't need a `port`, `query`, or `fragment`). Important parts of the format include:

- `scheme` (`protocol`): the "language" that the computer will use to communicate the request to this resource. With web services this is normally `https` (**s**ecure HTTP)
- `domain`: the address of the web server to request information from
- `path`: which resource on that web server you wish to access. This may be the name of a file with an extension if you're trying to access a particular file, but with web services it often just looks like a folder!
- `query`: extra **parameters** (arguments) about what resource to access.

The `domain` and `path` usually specify the resource. For example, `www.domain.com/users` might be an _identifier_ for a resource which is a list of users. Note that we can also have "subresources" by adding extra pieces to the path: `www.domain.com/users/joel` might refer to the specific "joel" user in that list.

With an API, the domain and path are often viewed as being broken up into two parts:

- The **Base URI** is the domain and part of the path that is included on _all_ resources. It acts as the "root" for any particular resource. For example, the [Spotify API](https://developer.spotify.com/web-api/endpoint-reference/) has a base URI of `https://api.spotify.com`, while the [UNHCR API](http://data.unhcr.org/wiki/index.php/API_Documentation.html) has a base URI of `http://data.unhcr.org/api/`

- An **Endpoint**, or which resource on that domain you want to access. Each API will have _many_ different endpoints.

  For example, Spotify includes endpoints such as:
  - `/v1/tracks/{id}` to refer to a track with a specific `id` (the `{}` indicate a "variable", in that you can put any id in there not the string `"id"`)
  - `/v1/artists/:id/albums` to refer to a specific artist's albumbs (the `:` is another way to indicate a variable)
  - `/v1/browse/new-releases` to refer to a list of new releases

  The UNHCR includes enpoints such as:
  - `countries/show/:id` to refer to region information about a specific country
  - `stats/persons_of_concern` to refer to statistics about people seeking asylum

Thus we equivalently talk about accessing a particular **resource** and sending a request to a particular **endpoint**.

### Query Parameters
Often in order to access only partial sets of data from a resource (e.g., to only get some users) we also include a set of **query parameters**. These are like extra arguments that are given to the request function. Query parameters are listed after a question mark **`?`** in the URI, and are formed as key-value pairs similar to how we named items in _lists_. The key (_parameter name_) is listed first, followed by an equal sign **`=`**, followed by the value (_parameter value_); note that we can't include any spaces in URIs! We can include multiple query parameters by putting an ampersand **`&`** between each key-value pair:

```
?firstParam=firstValue&secondParam=secondValue&thirdParam=thirdValue
```

Exactly what parameter names you need to include (and what are legal values to assign to that name) depends on the particular web service. Common examples include having parameters named `q` or `query` for searching, with a value being whatever term you want to search for: in [`https://www.google.com/search?q=informatics`](https://www.google.com/search?q=informatics), the resource `/search` takes a query parameter `q` with the term you want to search for!

### HTTP Verbs
When we send a request to a particular resource, we need to indicate what we want to _do_ with that resource! This is done by specifying an **HTTP Verb** in the request. The HTTP protocol supports the following verbs:

- `GET`	Return a representation of the current state of the resource
- `POST`	Add a new subresource (e.g., insert a record)
- `PUT`	Update the resource to have a new state
- `PATCH`	Update a portion of the resource's state
- `DELETE`	Remove the resource
- `OPTIONS`	Return the set of methods that can be performed on the resource

By far the most common verb is `GET`, which is used to "get" (download) data from a web service.

We combine the verb and the endpoint to indicate what we want to do to a particular resource. Thus we can say:

```
GET /v1/search?type=artist&q=bowie
```

in order to GET data from the `/v1/search` resource where `type` is `artist` and `q` is `bowie`&mdash;that is, to download the results of a search for artists named "bowie".

Overall, this structure of treating all data on the web as a **resource** which we can interact with via **HTTP Requests** is refered to as the **REST Architecture** (REST stands for _REpresentational State Transfer_). This is a standard way of structuring computer applications that allows them to be interacted with in the same way as everyday websites. Thus a web service that enabled data access through named resources and responds to HTTP requests is known as a **RESTful** service, with a _RESTful API_.

## Accessing Web APIs
So to access a Web API, you just need to send an HTTP Request to a particular URI! You can easily do this with the browser: simple navigate to a particular address (base URI + endpoint), and that will cause the browser to send a GET request and display the resulting data in the browser. For example, you can send a request to search Spotify for artists named "bowie" with:

```
https://api.spotify.com/v1/search?type=artist&q=bowie
```

(Note that the data you'll get back is structued in JSON format. See below for details).

In `R` we can send GET requests using the [`httr`](https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html) library. Like `dplyr`, we will need to install and load it to use it:

```r
install.packages("httr")  # once per machine
library("httr")
```

This library provides a number of functions that reflect HTTP verbs. For example, the **`GET()`** function will send an HTTP GET Request to the specified URI:

```r
response <- GET("https://api.spotify.com/v1/search?type=artist&q=bowie")  # get new releases
```

While it is possible to include _query parameters_ in the URI, `httr` also allows you to include them as a _list_, making it easy to set and change variables (instead of needing to do a complex `paste0()` operation):

```r
query.params <- list(type = "artist", q = "bowie")
response <- GET("https://api.spotify.com/v1/search", query = query.params)
```

If you try printing out the `response` variable, you'll see a bunch of extraneous information:

```
Response [https://api.spotify.com/v1/search?type=artist&q=bowie]
  Date: 2017-01-30 05:14
  Status: 200
  Content-Type: application/json; charset=utf-8
  Size: 15.3 kB
```

This is called the **response header**. Each **response** has two parts: the **header**, and the **body**. You can think of the response as a envelope: the _header_ contains meta-data like the address and postage date, while the _body_ contains the actual contents of the letter (the data).

Since you're almost always interested in working with the _body_, you will need to extract that data from the response (e.g., open up the envelope and pull out the letter). You can do this with the `content()` method:

```r
# extract content from response, as a text string (not a list!)
body <- content(response, "text")
```

Note the `"text"` argument; this is needed to keep `httr` from doing it's own processing on the body data, since we'll be using other methods to handle that; keep reading for details!


## JSON Data
Most APIs will return data in **JavaScript Object Notation (JSON)** format. Like `.csv`, this is a format for writing down structured data&mdash;but while `.csv` files organize data into rows and columns (like a data frame), JSON allows you to organize elements into **key-value pairs** similar to an `R` _list_! This allows the data to have much more complex structure, which is useful for web services (but can be challenging for us)!

In JSON, lists of key-value pairs (called _objects_) are put inside braces (**`{ }`**), with the key and value separated by a colon (**`:`**) and each pair separated by a comma (**`,`**); key-value pairs are often written on separate lines for readability, but this isn't required. Note that keys need to be character strings (so in quotes), while values can either be character strings, numbers, booleans (written in lower-case as `true` and `false`), or even other lists! For example:

```json
{
  "first_name": "Ada",
  "job": "Programmer",
  "salary": 78000,
  "in_union": true,
  "favorites": {
    "music": "jazz",
    "food": "pizza",
  }
}
```

(In JavaScript the period `.` has special meaning, so it is not used in key names, hence the underscores `_`). The above is equivalent to the `R` list:

```r
list(first.name = "Ada", job = "Programmer", salary = 78000, in.union = TRUE,
        favorites = list(music = "jazz", food = "pizza")  # nested list in the list!
    )
```

Additionally, JSON supports what are called _arrays_ of data. These are like lists without keys (and so are only accessed by index). Key-less arrays are written in square brackets (**`[ ]`**), with values separated by commas. For example:

```json
["Aardvark", "Baboon", "Camel"]
```

which is equvalent to the `R` list:

```r
list("Aardvark", "Baboon", "Camel")
```

(Like _objects_ , array elements may or may not be written on separate lines).

Just as R allows you to have nested lists of lists, and those lists may or may not have keys, JSON can have any form of nested _objects_ and _arrays_. This can either be arrays (unkeyed lists) within objects (keyed lists), such as a more complex set of data about Ada:

```json
{
  "first_name": "Ada",
  "job": "Programmer",
  "pets": ["rover", "fluffy", "mittens"],
  "favorites": {
    "music": "jazz",
    "food": "pizza",
    "numbers": [12, 42]
  }
}
```

Or _arrays_ of _objects_ (unkeyed lists of keyed lists), such as a list of data about Seahawks games:

```json
[
  { "opponent": "Dolphins", "sea_score": 12, "opp_score": 10 },
  { "opponent": "Rams", "sea_score": 3, "opp_score": 9 },
  { "opponent": "49ers", "sea_score": 37, "opp_score": 18 },
  { "opponent": "Jets", "sea_score": 27, "opp_score": 17 },
  { "opponent": "Falcons", "sea_score": 26, "opp_score": 24 }
]
```

The later format is incredibly common in web API data: as long as each _object_ in the _array_ has the same set of keys, then you can easily consider this as a data table where each _object_ (keyed list) represents an **observation** (row), and each key represents a **feature** (column).


### Parsing JSON
When working with a web API, the usual goal is to take the JSON data contained in the _response_ and convert it into an `R` data structure we can use, such as _list_ or _data frame_. While the `httr` package is able to parse the JSON body of a response into a _list_, it doesn't do a very clean job of it (particularly for complex data structures).

A more effective solution is to use _another_ library called [`jsonlite`](https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf). This library provides helpful methods to convert JSON data into `R` data, and does a much more effective job of converting content into data frames that we can use.

As always, you will need to install and load this library:

```r
install.packages("jsonlite")  # once per machine
library("jsonlite")
```

`jsonlite` provides a function called **`fromJSON()`** that allows you to convert a JSON string into a list (or even a data frame if the columns have the right lengths!)

```r
response <- GET("https://api.spotify.com/v1/artists/0oSGxfWSnnOXhD2fKuz2Gy/albums")  # albums by Bowie
body <- content(response, "text")  # extract the body JSON
parsed.data <- fromJSON(body)  # convert the JSON string to a list
```

The `parsed.data` will contain a _list_ built out of the JSON. Depending on the complexity of the JSON, this may already be a data frame you can `View()`... but more likely you'll need to explore the list more. Good ways to do this:

- You can `print()` the data, but that is often hard to read (requires a lot of scrolling!)
- The `str()` method will produce a more organized printed list, though it can still be hard to read.
- The `names()` method will let you see a list of the what keys the list has, which is good for delving into the data

As an example continuing the above code:

```r
is.data.frame(parsed.data)  # FALSE
names(parsed.data)  # "href" "items" "limit" "next" "offset" "previous" "total"
  # looking at the JSON data itself (e.g., in the browser), `items` is the
  # key that contains the value we want

items <- parsed.data$items  # extract that element from the list
is.data.frame(items)  # TRUE; we can work with that!
```

### Flattening Data
Because JSON supports&mdash;and in fact encourages&mdash;nested lists (lists within lists), parsing a JSON string is likely to produce a data frame whose columns _are themselves data frames_. As an example:

```r
# Let's do something silly
people <- data.frame(names = c('Spencer', 'Jessica', 'Keagan'))  # a data frame with one column

favorites <- data.frame(  # a data frame with two columns
                food = c('Pizza', 'Pasta', 'salad'),
                music = c('Bluegrass', 'Indie', 'Electronic')
            )
# Store dataframe column
people$favorites <- favorites  # make the `favorites` column a data frame!

# this prints nicely...
print(people)
  #   names favorites.food favorites.music
  # 1 Spencer          Pizza       Bluegrass
  # 2 Jessica          Pasta           Indie
  # 3  Keagan          salad      Electronic

# but doesn't actually work like we expect!
people$favorites.food  # NULL
people$favorites$food  # [1] Pizza Pasta salad
```

Nested data frames make it hard to work with the data using our established techniques. Luckily, the `jsonlite` package provides a helpful function for addressing this called **`flatten()`**. This function takes the columns of each nested data frame and converts them into appropriately named columns in the outer data frame:

```r
people <- flatten(people)
people$favorites.food  # this just got created! Woo!
```

Note that `flatten()` only works on values that are _already data frames_; thus you may need to find the appropriate element inside of the list (that is, the item which is the data frame you want to flatten).

In practice, you will almost always want to flatten the data returned from a web API. Thus your "algorithm" for downloading web data is as follows:

1. Use `GET()` to download the data, specifying the URI (and any query parameters)
2. Use `content()` to extract the data as a JSON string
3. Use `fromJSON()` to convert the JSON string into a list
4. Find which element in that list is your data frame of interest. You may need to go "multiple levels" in
5. Use `flatten()` to flatten that data frame
6. ...
7. Insight!