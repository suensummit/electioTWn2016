library(httr)
library(rvest)
library(jsonlite)
library(jiebaR)
library(dplyr)
library(ggplot2)
library(wordcloud)

url <- URLencode(URL = "http://capitol.tw//search/data/周子瑜/")
url <- URLencode(URL = "http://capitol.tw//search/data/蔡英文/")
# url

# res <- GET(url)
res <- jsonlite::fromJSON(url)
str(res)
res$stream$message[3]

?worker

trySeg <- worker()
resSeg <- trySeg[res$stream$message[3]]
resSeg <- lapply(res$stream$message, function(x) trySeg[x])

resSeg2 <- lapply(res$stream$message, function(x) segment(x, trySeg))
resSeg2 <- do.call("c", resSeg2)

stopwords <- c("的", "是", "了", "跟", "與", "在")
resSeg2 <- filter_segment(resSeg2, stopwords)

resMtx <- table(resSeg2)
dim(resMtx)
View(resMtx)
resMtx2 <- as.data.frame(resMtx) %>% filter(Freq > 2)

par(family='Heiti TC Light')
wordcloud(resMtx2$resSeg2, resMtx2$Freq, min.freq = 5)

pal <- brewer.pal(9,"BuGn")
pal <- brewer.pal(9,"Paired")
#pal <- pal[-(1:4)]
wordcloud(resMtx2$resSeg, resMtx2$Freq, min.freq = 5, colors=pal)
