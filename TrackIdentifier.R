# Function to fetch data from api

library(dplyr)
library(httr)
library(jsonlite)
library(tuneR)

getmusicdata <- function(file_path = "xyz.mp3", access_key, access_secret){
  
  fingerprint<-readMP3(file_path)
  fingerprint%>%
    tuneR::extractWave(15, 20,xunit = "time")%>%
    tuneR::writeWave("identify.wav")
  
  # Signing a string
  url <- "http://ap-southeast-1.api.acrcloud.com/v1/identify"
  http_method <- "POST"
  http_uri <- "/v1/identify"
  data_type <- "audio"
  signature_version <- "1"
  timestamp1 <- Sys.time()%>%unclass
  
  string_to_sign <- paste(http_method,
                          http_uri,
                          access_key,
                          data_type,
                          signature_version,
                          timestamp1,
                          sep = "\n")
  
  
  
  signature <- digest::hmac(access_secret,
                            object = string_to_sign,
                            algo = "sha1",
                            raw = T)%>%
    base64_enc()
  
  data <- 
    list(
      access_key = access_key,
      data_type = data_type,
      sample_bytes = file.size("identify.wav"),
      sample = upload_file("identify.wav"),
      signature_version = 1,
      signature = signature,
      timestamp = timestamp1
    )
  response <- httr::POST(url = url, body = data)
  file.remove("identify.wav")
  return(content(response)%>%
           fromJSON())
}