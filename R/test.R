library(outliers)

dep <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_DependentVariable_Eclipse.csv")
ctrl <- read.csv("D:\\2IMP25-Assignment3\\CSVdata\\Eclipse\\CSV_ControlVariable_Eclipse.csv")
Time <- dep$ecosystemTenure

hist(Time, breaks = 50, col = rgb(0,0,1,0.5))
#plot(dep$changeID, period, xlab = "ChangeID", ylab = "Review Period", cex = 0.5, type = "p")
boxplot(Time, col = rgb(0,0,1,0.5))

model = lm(data2$revisionID ~ data2$ecosystemTenure)
for(i in 1:length(data2)) if(is.null(data2$dep.ecosystemTenure)) data2$dep.ecosystemTenure <- 0


ANOVA = aov(model)
TUKEY = TukeyHSD(x = ANOVA, 'data2$ecosystemTenure', conf.level = 0.75)

qqnorm(Time)
