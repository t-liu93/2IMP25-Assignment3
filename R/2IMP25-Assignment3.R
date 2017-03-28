#Mutilple linear regresstion help
#http://www.statmethods.net/stats/regression.html
#http://www.r-tutor.com/elementary-statistics/multiple-linear-regression
#https://www.youtube.com/watch?v=q1RD5ECsSB0  *star*
#https://www.youtube.com/watch?v=eTZ4VUZHzxw  *star*
par(mfrow = c(2, 3))
dep <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_DependentVariable_Eclipse.csv")
ctrl <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_ControlVariable_Eclipse.csv")
Pre <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_PredictorVariable_Eclipse.csv")

plot(ctrl$linesAdded, dep$reviewPeriod)
plot(ctrl$linesDeleted, dep$reviewPeriod)
plot(ctrl$numberOfFilesModified, dep$reviewPeriod)


