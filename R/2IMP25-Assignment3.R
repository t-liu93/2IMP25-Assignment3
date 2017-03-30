#par(mfrow = c(2, 2))

# Change the file address according to your system and the dataset you want to process
#dnc <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_DependentAndControlVariable_Eclipse.csv")
#Pre <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_PredictorVariable_Eclipse.csv")
dnc <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\LibreOffice\\CSV_DependentAndControlVariable_LibreOffice.csv")
Pre <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\LibreOffice\\CSV_PredictorVariable_LibreOffice.csv")

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
LA_author <- c()
LA_author[1] <- NA
LD_author <- c()
LD_author[1] <- NA
FM_author <- c()
FM_author[1] <- NA
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
#sort by authorId
dnc2 <- dnc2[order(dnc2$authorId),]

#Get reviewperiod, Line added, Linedeleted and nr. files modified per author
for(i in 1:(length(dnc2$authorId) - 1)) {
  if(is.na(rp_author[h])){ #new author
    rp_author[h] <- as.numeric(dnc2$reviewPeriod[i])
    reduced_authorId[h] <- dnc2$authorId[i]
    LA_author[h] <- dnc2$linesAdded[i]
    LD_author[h] <- dnc2$linesDeleted[i]
    FM_author[h] <- dnc2$numberOfFilesModified[i]
  }
  else {
    rp_author[h] <- as.numeric(rp_author[h]) + as.numeric(dnc2$reviewPeriod[i])
    LA_author[h] <- LA_author[h] + dnc2$linesAdded[i]
    LD_author[h] <- LD_author[h] + dnc2$linesDeleted[i]
    FM_author[h] <- FM_author[h] + dnc2$numberOfFilesModified[i]
  }
  
  if(dnc2$authorId[i] == dnc2$authorId[i+1]) { #next author is the same author
    h <- h
  }
  else {
    h <- h + 1
  }
}

# new data with reviewperiod per author
dnc3 = data.frame(reduced_authorId, rp_author, LA_author, LD_author, FM_author)

# find common author in pre and dnc3 
h<-1
#exp_final <- c()
reviewPeriod_final <- c()
author_final <- c()
LA_final <- c()
LD_final <- c()
FM_final <- c()
eco <- c()
change <- c()
review_tenure <- c()
review_act <- c()
block_tenure <- c()
block_act <- c()

for(i in 1:length(dnc3$reduced_authorId)) {
  for(j in 1:length(pre_author)) {
    if(dnc3$reduced_authorId[i] == pre_author[j]) {
      #exp_final[h] <- exp[j]
      reviewPeriod_final[h] <- dnc3$rp_author[i]
      LA_final[h] <- dnc3$LA_author[i]
      LD_final[h] <- dnc3$LD_author[i]
      FM_final[h] <- dnc3$FM_author[i]
      author_final[h] <- dnc3$reduced_authorId[i]
      eco[h] <- Pre$ecosystemTenure[j]
      change[h] <- Pre$changeAcitivity[j]
      review_tenure[h] <- Pre$reviewTenure[j]
      review_act[h] <- Pre$reviewActivity[j]
      block_tenure[h] <- Pre$appBlockTenure[j]
      block_act[h] <- Pre$appBlockActivity[j]
      h <- h + 1
    }
  }
}

#data set with final LA, LD, FM, authorID, reviewPeriod
dnc4 <- data.frame(author_final, LA_final, LD_final, FM_final, reviewPeriod_final, 
             eco, change, review_tenure, review_act, block_tenure, block_act)

#get exp 
exp <- 2*as.numeric(dnc4$eco) + as.numeric(dnc4$change) + 3*as.numeric(dnc4$review_tenure) +
  as.numeric(dnc4$review_act) + 2*as.numeric(dnc4$block_tenure) + as.numeric(dnc4$block_act) +
  log(as.numeric(dnc4$LA_final)) + log(as.numeric(dnc4$LD_final)+0.5) + log(as.numeric(dnc4$FM_final))


#final dataset
dnc_final = data.frame(dnc4, exp)

#do log transform on review period
#dnc_final$reviewPeriod_final <- log(dnc_final$reviewPeriod_final + 0.5)

#Calculate and remove the outliers
#Outliers for review period
p25Rp = quantile(dnc_final$reviewPeriod_final, prob = 0.25)
p75Rp = quantile(dnc_final$reviewPeriod_final, prob = 0.75)
IQRRp = p75Rp - p25Rp
yLowerRp = p25Rp - 1.5 * IQRRp
yUpperRp = p75Rp + 1.5 * IQRRp
RP <- c()
exp2 <- c()

#h <- 1
#for (i in 1 : length(dnc_final$author_final)) {
#  if (dnc_final$reviewPeriod_final[i] >= yLowerRp) {
#    if(dnc_final$reviewPeriod_final[i] <= yUpperRp) {
#      #Under this condition is the values we need
#      RP[h] <- dnc_final$reviewPeriod_final[i]
#      exp2[h] <- dnc_final$exp[i]
#      h <- h + 1
#    }
#  }
#}
#without using exp
ReviewPeriod <- c()
LinesAdded <- c()
LinesDeleted <- c()
FileModified <- c()
EcosystemTenure <- c()
ChangeActivity <- c()
ReviewTenure <- c()
ReviewActivity <- c()
AppBlockTenure <- c()
AppblockActivity <- c()

h <- 1
for (i in 1 : length(dnc_final$author_final)) {
  if (dnc_final$reviewPeriod_final[i] >= yLowerRp) {
    if(dnc_final$reviewPeriod_final[i] <= yUpperRp) {
      #Under this condition is the values we need
      ReviewPeriod[h] <- dnc_final$reviewPeriod_final[i]
      LinesAdded[h] <- dnc_final$LA_final[i]
      LinesDeleted[h] <- dnc_final$LD_final[i]
      FileModified[h] <- dnc_final$FM_final[i]
      EcosystemTenure[h] <- dnc_final$eco[i]
      ChangeActivity[h] <- dnc_final$change[i]
      ReviewTenure[h] <- dnc_final$review_tenure[i]
      ReviewActivity[h] <- dnc_final$review_act[i]
      AppBlockTenure[h] <- dnc_final$block_tenure[i]
      AppblockActivity[h] <- dnc_final$block_act[i]
      exp2[h] <- dnc_final$exp[i]
      RP[h] <- dnc_final$reviewPeriod_final[i]
      h <- h + 1
    }
  }
}


#order
dnc_final_orer = dnc_final[order(exp),]

#Make model

model1 = lm(ReviewPeriod ~ log(LinesAdded) + 
                log(LinesDeleted+0.5) + 
                log(FileModified) + 
                EcosystemTenure + 
                ChangeActivity + 
                ReviewTenure + 
                ReviewActivity + 
                AppBlockTenure +
                AppblockActivity)
model2 = lm(RP ~ exp2)

#summary of the model  
#summary(model1)
#summary(model2)
#plot(model1)
#plot(model2)
plot(log(exp2), RP)
#anova(model1)
#anova(model2)
