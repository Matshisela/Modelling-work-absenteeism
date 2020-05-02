library(caret)
library(DAAG)
library(brnn)
library(ggplot2)
library(GGally)
library(texreg)

cdata <- read.csv(file='C:/Users/Matshisela/Downloads/Abseentism/Absenteeism_at_work.csv', 
                  sep=';', header=TRUE)

#The first column of the data is redundant hence it will not be regarded

#Exploratory data analysi
ggpairs(cdata[,2:21])

#From the graph it is abundantly clear that te data is not normalised. Hence I will 
#scale the data using the Max-Min Normalization method

# MAX-MIN NORMALIZATION
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

scaled <- as.data.frame(lapply(cdata[,2:21], normalize))

#For a view of the data observe
str(scaled)

#Checking the GGpairs plot again
ggpairs(scaled)

#Spliting data into train and tests set
set.seed(263)
index <- sample(1:nrow(scaled), round(0.75*nrow(scaled)))
train1 <- scaled[index,]
test1 <- scaled[-index,]

#Since the data is now normalised the modelling begins

#Linear Regression
#Simple Linear Regression
lm1 <- lm(Absenteeism.time.in.hours~., data = train1)
summary(lm1)
cvResults1 <- suppressWarnings(CVlm(data = train1, 
                                    form.lm = lm1, 
                                    m=5,
                                    dots = FALSE, seed=263, legend.pos = "topleft",
                                    printit = FALSE))

attr(cvResults1, 'ms') #0.01020115



#GLM using the Gaussian 
galm <- glm(Absenteeism.time.in.hours~., data=train1, family= gaussian)


screenreg(l=list(lm1, galm))

#Testing linear regression with SA
pr.lm <- predict(lm1, test1)
results_lm <- data.frame(actual = test1$Absenteeism.time.in.hours, 
                         prediction = pr.lm)

predicted_lm <- results_lm$prediction * abs(diff(range(cdata$Absenteeism.time.in.hours))) + 
  min(cdata$Absenteeism.time.in.hours)

actual_lm <- results_lm$actual * abs(diff(range(cdata$Absenteeism.time.in.hours))) + 
  min(cdata$Absenteeism.time.in.hours)

comparison_lm = data.frame(predicted_lm, actual_lm)
deviation_lm =((actual_lm - predicted_lm)/actual_lm)
#comparison_lm =data.frame(predicted_lm, actual_lm, deviation_lm)
#accuracy_lm = 1-abs(mean(deviation_lm))
#accuracy_lm #NaN
MSE_lm <- sum((actual_lm- predicted_lm)^2)/nrow(test1) #1.589542e-29
RMSE(predicted_lm, actual_lm) #3.986907e-15


#Tuning the bayesian neural network
btune <- expand.grid(neurons= seq(from=1, to=40, by=9))

fitcontrol <- trainControl(method = 'repeatedcv',
                           number = 10,
                           repeats = 3)

tic('Bayesian Neural Network')
bnntune <- train(train1, 
                 method='brnn',
                 train1$Absenteeism.time.in.hours,
                 metric="RMSE",
                 trControl=fitcontrol,
                 tuneGrid= btune,
                 verbose=FALSE)

toc(log=TRUE)

plot(bnntune)

#prediction using bayesian neural network
pr.br <- predict(bnntune, test1)
results_br <- data.frame(actual = test1$Absenteeism.time.in.hours, 
                         prediction = pr.br)

predicted_br <- results_br$prediction * abs(diff(range(bdata$Absenteeism.time.in.hours))) + 
  min(bdata$Absenteeism.time.in.hours)

actual_br <- results_br$actual * abs(diff(range(bdata$Absenteeism.time.in.hours))) + 
  min(bdata$Absenteeism.time.in.hours)


MSE_br <- sum((actual_br- predicted_br)^2)/nrow(test1)
RMSE(predicted_br, actual_br) #0.1032593



