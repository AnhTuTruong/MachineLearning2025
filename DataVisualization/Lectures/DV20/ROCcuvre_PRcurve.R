setwd("E:/Bioinfor/Data_Visualization/ROC_PR/")
library(tidyverse)
set.seed(123)

dt <- iris
table(dt$Species)
dt <- dt[(dt$Species=="versicolor") | (dt$Species=="virginica"),c(1:2,5)]
table(dt$Species)
#virginica versicolor 
#50         50 

dt$class <- ifelse(dt$Species == "virginica", 1, 0)

###################################
library(caret)
# setup train and test data
index <- createDataPartition(dt$Species, p=0.80, list=FALSE)

# 80% of data to training
trainDT <- dt[index,]
table(trainDT$Species)
#virginica versicolor 
#40         40

# select 20% of the data for testing
testDT <- dt[-index,]
table(testDT$Species)
#virginica versicolor 
#10         10 

###################################
# build logistic model
logis <- glm(Species ~ Sepal.Length, trainDT, family="binomial")
summary(logis)
# How train data look like?
ggplot(trainDT) +
  geom_point(aes(Sepal.Length, class, color = Species, shape = Species), alpha = 0.2, size = 5) +
  geom_smooth(aes(Sepal.Length, class), method = "glm", method.args = list(family = "binomial")) +
  labs(title = "Logistic Regression Model", x = "Sepal Length",
       y = "Probability of being virginica species") +
  theme(text = element_text(size = 30))
#ggsave("Output/trainset_scores_predicted.pdf", width = 10, height = 8)

# prediction
testDT$pred <- predict(logis, testDT, type="response")
# How predicted scores look like?
ggplot() +
  geom_smooth(aes(trainDT$Sepal.Length, trainDT$class),method = "glm",
              method.args = list(family = "binomial")) +
  geom_point(aes(testDT$Sepal.Length, testDT$pred, shape=testDT$Species,
                 color=testDT$Species), alpha = 0.4, size = 7) +
  labs(x = "Sepal Length", y = "Probability",
       color="Species", shape="Species") +
  theme(text = element_text(size = 30))
#ggsave("Output/testset_scores_predicted.pdf", width = 10, height = 8)

# classifying
cutoff <- 0.5
testDT$pred.species <- ifelse(testDT$pred > cutoff, "virginica", "versicolor")
table(testDT$pred.species)

#translate predicted scores into binary class
testDT$pred.class <- ifelse(testDT$pred > cutoff, 1, 0)

# How classified test data at cutoff 0.5 look like?
ggplot() +
  geom_smooth(aes(trainDT$Sepal.Length, trainDT$class),method = "glm",
              method.args = list(family = "binomial")) +
  geom_point(aes(testDT$Sepal.Length, testDT$pred.class, shape=testDT$Species,
                 color=testDT$Species), alpha = 0.3, size = 7) +
  labs(x = "Sepal Length", y = "Probability",
       color="Species", shape="Species") +
  theme(text = element_text(size = 30))
#ggsave("Output/testset_0.5_predicted.pdf", width = 10, height = 8)

###################################
# confusion matrix
confusionMatrix(factor(testDT$pred.species),
                factor(testDT$Species),
                positive  = "virginica")

cm <- confusionMatrix(factor(testDT$pred.species),
                      factor(testDT$Species),
                      positive  = "virginica")$table
# Sens and Spec
sensitivity = cm[2, 2] / (cm[2, 2] + cm[1, 2])
sensitivity
specificity = cm[1, 1] / (cm[1, 1] + cm[2, 1])
specificity

#Loop to summarize multiple confusion matrix
table_sens_spec= data.frame(Threshold = numeric(),
                            Sens = numeric(),
                            Spec = numeric(),
                            stringsAsFactors=FALSE)

step <- 0.1
cutoff_step = seq(from=0,by=step, length.out = (1/step)+1)
for (i in 1:length(cutoff_step)) {
  table_sens_spec[i,1] <- cutoff_step[i]
  i_pred.species <- ifelse(testDT$pred > cutoff_step[i], "virginica", "versicolor")
  i_cm <- confusionMatrix(factor(i_pred.species),
                          factor(testDT$Species),
                          positive  = "virginica")$table
  # Sens and Spec
  i_sensitivity = i_cm[2, 2] / (i_cm[2, 2] + i_cm[1, 2])
  table_sens_spec[i,2] <- i_sensitivity
  i_specificity = i_cm[1, 1] / (i_cm[1, 1] + i_cm[2, 1])
  table_sens_spec[i,3] <- i_specificity
}
table_sens_spec$FPR <- 1-table_sens_spec$Spec

###################################
# ROC curve
ggplot(table_sens_spec, aes(x=FPR, y=Sens)) + geom_point(size=5) + geom_path(size = 2) +
  labs(x = "False Positive Rate", y = "True Positive Rate") +
  geom_abline(intercept=0, slope = 1, size =1, linetype=2) +
  theme(text = element_text(size = 30))
#ggsave("Output/ROCcurve.pdf", width = 8.3, height = 8)

###################################
ROC_height = (table_sens_spec$Sens[-1]+table_sens_spec$Sens[-length(table_sens_spec$Sens)])/2
ROC_width = -diff(table_sens_spec$FPR)
AUC <- sum(ROC_height*ROC_width)

###################################
# accuracy
cm <- confusionMatrix(factor(testDT$pred.species),
                      factor(testDT$Species),
                      positive  = "virginica")$table
accuracy = (cm[2, 2] + cm[1, 1]) / (cm[1, 1] + cm[1, 2] + cm[2, 1] + cm[2, 2])
accuracy

###################################
# Precision
ppv = cm[2, 2] / (cm[2, 2] + cm[2, 1])

# Loop to summarize multiple confusion matrix
table_sens_ppv = data.frame(Threshold = numeric(),
                            Sens = numeric(),
                            PPV = numeric(),
                            stringsAsFactors=FALSE)

step <- 0.1
cutoff_step = seq(from=0,by=step, length.out = (1/step)+1)
for (i in 1:length(cutoff_step)) {
  table_sens_ppv[i,1] <- cutoff_step[i]
  i_pred.species <- ifelse(testDT$pred > cutoff_step[i], "virginica", "versicolor")
  #i_pred.class <- ifelse(i_pred > i_cutoff, 1, 0)
  i_cm <- confusionMatrix(factor(i_pred.species),
                          factor(testDT$Species),
                          positive  = "virginica")$table
  # Sens and Spec
  i_sensitivity = i_cm[2, 2] / (i_cm[2, 2] + i_cm[1, 2])
  table_sens_ppv[i,2] <- i_sensitivity
  i_ppv = i_cm[2, 2] / (i_cm[2, 2] + i_cm[2, 1])
  table_sens_ppv[i,3] <- i_ppv
}
table_sens_ppv$PPV[is.nan(table_sens_ppv$PPV)] <- 1

ggplot(table_sens_ppv, aes(x=Sens, y=PPV)) + geom_point(size=5) + geom_path(size = 2) +
  labs(x = "Recall", y = "Precision") + xlim(0,1) + ylim(0,1) +
  geom_hline(yintercept = 0.5, size =1, linetype=2) +
  theme(text = element_text(size = 30))
#ggsave("Output/PRcurve.pdf", width = 8.3, height = 8)

###################################
PR_height = (table_sens_ppv$PPV[-1]+table_sens_ppv$PPV[-length(table_sens_ppv$PPV)])/2
PR_width = -diff(table_sens_ppv$Sens)
AUPRC <- sum(PR_height*PR_width)

###################################
# Calculate ROC and Precision-Recall curves
library(precrec)
ROCnPR <- evalmod(scores = testDT$pred, labels = testDT$Species)
plot(ROCnPR)
autoplot(ROCnPR)
autoplot(ROCnPR, "ROC")
autoplot(ROCnPR, "PRC")
aucs <- auc(ROCnPR)
knitr::kable(aucs)

#ggplot ROC
dt.roc <- as.data.frame(ROCnPR)[as.data.frame(ROCnPR)$type == "ROC",]
ggplot(dt.roc, aes(x=x, y=y)) + geom_path(size = 2) + geom_point() +
  labs(x = "False Positive Rate", y = "True Positive Rate") + xlim(0,1) + ylim(0,1) +
  geom_abline(intercept= 0, slope = 1, size =1, linetype=2) +
  theme(text = element_text(size = 30))
#ggsave("Output/ROCcurve_package.pdf", width = 8.3, height = 8)
dim(dt.roc)

#ggplot PR
dt.pr <- as.data.frame(ROCnPR)[as.data.frame(ROCnPR)$type == "PRC",]
ggplot(dt.pr, aes(x=x, y=y)) + geom_path(size = 2) + geom_point() +
  labs(x = "Recall", y = "Precision") + xlim(0,1) + ylim(0,1) +
  geom_hline(yintercept = 0.5, size =1, linetype=2) +
  theme(text = element_text(size = 30))
#ggsave("Output/PRcurve_package.pdf", width = 8.3, height = 8)
dim(dt.pr)
