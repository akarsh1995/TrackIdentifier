
source("TrackIdentifier.R")

resp.content <- getmusicdata("path of the music file")
resp.content<-resp.content$metadata%>%unlist%>%as.data.frame()
resp.content<- cbind(row.names(resp.content), resp.content)
resp.content#### HEADER ####

# Signing a string
url <- "http://ap-southeast-1.api.acrcloud.com/v1/identify"
access_key <- "4c28eb9280d46056c68b0cac98dd60ac"
access_secret <- "H4yyfMKCivJzxc6fPAAgskQ52hfb14l4kiAJ6JT5"
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
signature

file_path = "/home/akarsh/Downloads/toolur_HnXQ1j.mp3"
to.read <- file(file_path, open = "r", raw = T)

data <- 
  list(
    access_key = access_key,
    data_type = data_type,
    sample_bytes = file.size(file_path),
    sample = upload_file(file_path),
    signature_version = 1,
    signature = signature,
    timestamp = timestamp1
  )


response <- httr::POST(url = url, body = data, verbose())
