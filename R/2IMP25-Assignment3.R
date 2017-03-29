#Mutilple linear regresstion help
#http://www.statmethods.net/stats/regression.html
#http://www.r-tutor.com/elementary-statistics/multiple-linear-regression
#https://www.youtube.com/watch?v=q1RD5ECsSB0  *star*
#https://www.youtube.com/watch?v=eTZ4VUZHzxw  *star*

library(outliers)
par(mfrow = c(2, 2))
#dep <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_DependentVariable_Eclipse.csv")
#ctrl <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_ControlVariable_Eclipse.csv")
dnc <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_DependentAndControlVariable_Eclipse.csv")
Pre <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_PredictorVariable_Eclipse.csv")

authorId <- c()
changeId <- c()
revisionId <- c()
linesAdded <- c()
linesDeleted <- c()
numberOfFilesModified <- c()
reviewPeriod <- c()
exp <- c()
rp_author <- c()
rp_author[1] <- NA
reduced_authorId <- c()
reduced_authorId[1] <- NA
pre_author <- Pre$authorId
h <- 1
j <- 1

#leave out reviewPeriod < 0
for(i in 1:length(dnc$reviewPeriod)){
  if(dnc$reviewPeriod[i] >= 0){
    if(dnc$linesAdded[i] > 1) {
      authorId[j] <- dnc$authorId[i]
      changeId[j] <- dnc$changeId[i]
      revisionId[j] <- dnc$revisionId[i]
      linesAdded[j] <- dnc$linesAdded[i]
      linesDeleted[j] <- dnc$linesDeleted[i]
      numberOfFilesModified[j] <- dnc$numberOfFilesModified[i]
      reviewPeriod[j] <- dnc$reviewPeriod[i]
      j <- j+1
    }
  } 
} 

#new data dnc2
dnc2 <- data.frame(authorId, changeId, revisionId, reviewPeriod, linesAdded, linesDeleted, numberOfFilesModified)
dnc2 <- dnc2[order(dnc2$authorId),]

#Get reviewperiod per author
for(i in 1:(length(dnc2$authorId) - 1)) {
  if(is.na(rp_author[h])){ #new author
    rp_author[h] <- as.numeric(dnc2$reviewPeriod[i])
    reduced_authorId[h] <- dnc2$authorId[i]
  }
  else
    rp_author[h] <- as.numeric(rp_author[h]) + as.numeric(dnc2$reviewPeriod[i])
  
  if(dnc2$authorId[i] == dnc2$authorId[i+1]) { #next author is the same author
    h <- h
  }
  else {
    h <- h + 1
  }
}

# new data with reviewperiod per author
dnc3 = data.frame(reduced_authorId, rp_author)
#get exp by info in pre
exp <- 2*as.numeric(Pre$ecosystemTenure) + as.numeric(Pre$changeAcitivity) + 3*as.numeric(Pre$reviewTenure)
+ as.numeric(Pre$reviewActivity) + 2*as.numeric(Pre$appBlockTenure) + as.numeric(Pre$appBlockActivity)

# exp per author
exp_author <- data.frame(pre_author, exp)

# find common author in RP/author and EXP/author  
h<-1
exp_final <- c()
reviewPeriod_final <- c()
for(i in 1:length(dnc3$reduced_authorId)) {
  for(j in 1:length(exp_author$pre_author)) {
    if(dnc3$reduced_authorId[i] == exp_author$pre_author[j]) {
      exp_final[h] <- exp_author$exp[j]
      reviewPeriod_final[h] <- dnc3$rp_author[i]
      h <- h + 1
    }
  }
}

model = lm(reviewPeriod_final ~ exp_final)
  
summary(model)
plot(model)


