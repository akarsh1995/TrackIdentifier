access_key = "xyz"
access_secret = "abc"
source("TrackIdentifier.R")
resp.content <- getmusicdata("path of the music file")
resp.content<-resp.content$metadata%>%unlist%>%as.data.frame()
resp.content<- cbind(row.names(resp.content), resp.content)
resp.content
