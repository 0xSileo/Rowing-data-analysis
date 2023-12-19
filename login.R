library(rvest)
library(httr)

LOGIN_URL <- "https://log.concept2.com/login"
EXPORT_URL <- "https://log.concept2.com/season/2024/export"

# Load credentials using source
source("private.r")
username <- credentials$username
password <- credentials$password

# Extract the _token value dynamically
page <- read_html(LOGIN_URL)
token_value <- html_nodes(page, "input[name='_token']") %>% html_attr("value")

payload <- list(
  "_token" = token_value,
  "username" = username,
  "password" = password
)

login_response <- POST(LOGIN_URL, body = payload)

# Check the response status
print(http_status(login_response))
if (http_status(login_response)$category == "Success") {
  print("Login successful.")
  
  # Extract Laravel cookie
  laravel_cookie <- cookies(login_response)$value
  export_response <- GET(EXPORT_URL, set_cookies("laravel_cookie" = laravel_cookie))
  
  if (http_status(export_response)$category == "Success") {
    writeBin(content(export_response, "raw"), "Concept2-data/concept2-season-2024.csv")
    print("CSV file saved as concept2-season-2024.csv !")
  } else {
    print("Export failed.")
  }
} else {
    print("Login failed.")
}




