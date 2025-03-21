##Visualizing Forest
###1Random Forest in R
library(randomForest)
library(datasets)
library(caret)
library(varImp)
library(dplyr)
library(ggplot2)
library(stablelearner)
library(ggRandomForests)
#Getting Data
data<-iris

#The datasets contain 150 observations and 5 variables 
data$Species <- as.factor(data$Species)
table(data$Species)
#setosa versicolor  virginica
# 50         50         50
#Data Partition
set.seed(2910)
rf <- randomForest(Species~., data=data, ntree = 100, mtry = 2, proximity=TRUE) 
print(rf)


#Variable Importance
varImpPlot(rf,
           sort = T,
           n.var = 10,
           main = "Variable Importance")

#Variable Frequency Plot
rf_st <- stablelearner::as.stabletree(rf)
summary(rf_st, original = FALSE)
barplot(rf_st, cex.names = 0.6)

#Variable Importance by Node Purity
plot(gg_vimp(rf)) + theme_gray()
#############################################################################
#VARIABLE IMPORTANCE AND VARIABLE INTERACTIONS
#library
library(tidyverse)
library(tidymodels)
library(recipes)
library(randomForestExplainer)
#import
heart<-read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data", col_names = F)
# Renaming var 
colnames(heart)<- c("age", "sex", "rest_cp", "rest_bp",
                    "chol", "fast_bloodsugar","rest_ecg","ex_maxHR","ex_cp",
                    "ex_STdepression_dur", "ex_STpeak","coloured_vessels", "thalassemia","heart_disease")
#elaborating cat var
##simple ifelse conversion 
heart<-heart %>% mutate(sex= ifelse(sex=="1", "male", "female"),fast_bloodsugar= ifelse(fast_bloodsugar=="1", ">120", "<120"), ex_cp=ifelse(ex_cp=="1", "yes", "no"),
                        heart_disease=ifelse(heart_disease=="0", "no", "yes")) 
## complex ifelse conversion using `case_when`
heart<-heart %>% mutate(
  rest_cp=case_when(rest_cp== "1" ~ "typical",rest_cp=="2" ~ "atypical", rest_cp== "3" ~ "non-CP pain",rest_cp== "4" ~ "asymptomatic"), rest_ecg=case_when(rest_ecg=="0" ~ "normal",rest_ecg=="1" ~ "ST-T abnorm",rest_ecg=="2" ~ "LV hyperthrophy"), ex_STpeak=case_when(ex_STpeak=="1" ~ "up/norm", ex_STpeak== "2" ~ "flat",ex_STpeak== "3" ~ "down"), thalassemia=case_when(thalassemia=="3.0" ~ "norm", 
                                                                                                                                                                                                                                                                                                                                                                                thalassemia== "6.0" ~ "fixed", thalassemia== "7.0" ~ "reversable")) 
# convert missing value "?" into NA
heart<-heart%>% mutate_if(is.character, funs(replace(., .=="?", NA)))
# convert char into factors
heart<-heart %>% mutate_if(is.character, as.factor)
#train/test set 
set.seed(4595)
data_split <- initial_split(heart, prop=0.75, strata = "heart_disease")
heart_train <- training(data_split)
heart_test <- testing(data_split)
# create recipe object

heart_recipe<-recipe(heart_disease ~., data= heart_train) %>%
  step_impute_knn(all_predictors()) %>% 
  step_dummy(all_nominal(), -heart_disease)

# process the traing set/ prepare recipe(non-cv)
heart_prep <-heart_recipe %>% prep(training = heart_train, retain = TRUE)
set.seed(69)
rf_model<-rand_forest(trees = 500, mtry = 4, mode = "classification") %>% set_engine("randomForest",
                                                                                      importance=T, localImp = T, ) %>% fit(heart_disease ~ ., data = juice(heart_prep))

impt_frame<-measure_importance(rf_model$fit)

impt_frame %>% head()
###############variable depth
md_frame <- min_depth_distribution(rf_model$fit)
plot_min_depth_distribution(md_frame, mean_sample = "top_trees") # default mean_sample arg 
###############variable interaction
vars<- important_variables(impt_frame, k = 6, measures = c("times_a_root", "no_of_nodes"))
interactions_frame <- min_depth_interactions(rf_model$fit, vars)
head(interactions_frame)
plot_min_depth_interactions(interactions_frame)
#plot_predict_interaction(rf_model$fit, bake(heart_prep, new_data = heart_train), "rest_bp", "ex_STdepression_dur")
set.seed(69)
forest <- randomForest::randomForest(heart_disease ~ ., data = bake(heart_prep, new_data = heart_train), localImp = TRUE, importance=T, ntree = 500, mtry = 4, type= "classification")

plot_predict_interaction(forest, bake(heart_prep, new_data = heart_train), "rest_bp", "ex_STdepression_dur", main = "Distribution of Predicted Probability of Having Heart Disease") + theme(legend.position="bottom") + geom_hline(yintercept = 2, linetype="longdash") + geom_vline(xintercept = 140, linetype="longdash")

########
######################
##DECISION BOUNDARY WITH RANDOM FOREST
library(randomForest)
library(tidyverse)
library(caret)
library(dslabs)
library(ggthemes)
head(mnist_27)
?mnist_27
model<- randomForest(y~., data = mnist_27$train)
data<- mnist_27$train %>% select(x_1, x_2, y)
class<- "y"
#predict_type = "class"
resolution = 75


if(!is.null(class)) cl <- data[,class] else cl <- 1
data <- data[,1:2]




r <- sapply(data, range, na.rm = TRUE)
xs <- seq(r[1,1], r[2,1], length.out = resolution)
ys <- seq(r[1,2], r[2,2], length.out = resolution)
g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
colnames(g) <- colnames(r)
g <- as.data.frame(g)

q<- predict(model, g, type = "class")
p <- predict(model, g, type = "prob")
p<- p %>% as.data.frame() %>% mutate(p=if_else(`2`>=`7`, `2`, `7`))
p<- p %>% mutate(pred= as.integer(q))







ggplot()+
  geom_raster(data= g, aes(x= x_1, y=x_2, fill=p$`2` ), interpolate = TRUE)+
  geom_contour(data= NULL, aes(x= g$x_1, y=g$x_2, z= p$pred), breaks=c(1.5), color="black", size=1)+
  theme_few()+
  scale_colour_manual(values = cols)+
  labs(colour = "", fill="")+
  scale_fill_gradient2(low="#338cea", mid="white", high="#dd7e7e", 
                       midpoint=0.5, limits=range(p$`2`))+
  theme(legend.position = "none")
###### Visualization of SPECIFIC TREES WITHIN A FOREST 
library(dplyr)
library(ggraph)
library(igraph)
library(randomForest)
tree_func <- function(final_model, 
                      tree_num) {
  
  # get tree by index
  tree <- randomForest::getTree(final_model, 
                                k = tree_num, 
                                labelVar = TRUE) %>%
    tibble::rownames_to_column() %>%
    # make leaf split points to NA, so the 0s won't get plotted
    mutate(`split point` = ifelse(is.na(prediction), `split point`, NA))
  
  # prepare data frame for graph
  graph_frame <- data.frame(from = rep(tree$rowname, 2),
                            to = c(tree$`left daughter`, tree$`right daughter`))
  
  # convert to graph and delete the last node that we don't want to plot
  graph <- graph_from_data_frame(graph_frame) %>%
    delete_vertices("0")
  
  # set node labels
  V(graph)$node_label <- gsub("_", " ", as.character(tree$`split var`))
  V(graph)$leaf_label <- as.character(tree$prediction)
  V(graph)$split <- as.character(round(tree$`split point`, digits = 2))
  
  # plot
  plot <- ggraph(graph, 'dendrogram') + 
    theme_bw() +
    geom_edge_link() +
    geom_node_point() +
    geom_node_text(aes(label = node_label), na.rm = TRUE, repel = TRUE) +
    geom_node_label(aes(label = split), vjust = 2.5, na.rm = TRUE, fill = "white") +
    geom_node_label(aes(label = leaf_label, fill = leaf_label), na.rm = TRUE, 
                    repel = TRUE, colour = "white", fontface = "bold", show.legend = FALSE) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          plot.background = element_rect(fill = "white"),
          panel.border = element_blank(),
          axis.line = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          plot.title = element_text(size = 18))
  
  print(plot)
}


tree_func(final_model = forest, 300)


#############################################################################
##TRACE PLOT
library(dplyr)
#install.packages("remotes")
#remotes::install_github("yaweige/ggpcp")
library(ggpcp)
library(ggplot2)
library(TreeTracer)
penguins <- na.omit(palmerpenguins::penguins)
penguin_features <- 
  penguins %>% 
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)
penguins %>%
  ggplot(aes(color = species)) +
  geom_pcp(aes(
    vars = vars(
      bill_length_mm, 
      bill_depth_mm, 
      flipper_length_mm, 
      body_mass_g
    )
  ), alpha = 0.5) + 
  scale_color_brewer(palette = "Paired")
# Fit a random forest
set.seed(71)
penguin_rf <-
  randomForest::randomForest(
    species ~ bill_length_mm + bill_depth_mm + flipper_length_mm + body_mass_g,
    data = penguins, 
    ntree = 50
  )
# Print feature importance
penguin_rf$importance %>% 
  data.frame() %>% 
  arrange(desc(MeanDecreaseGini))



# Trace plots of trees in the forest
trace_plot(
  rf = penguin_rf,
  train = penguin_features,
  tree_ids = 1:penguin_rf$ntree,
  alpha = 0.4
) + 
  theme(aspect.ratio = 1)
#####

rf_tree1 <- randomForest::getTree(rfobj = penguin_rf, k = 1)
tt_tree1 = TreeTracer::get_tree_data(rf = penguin_rf, k = 1)
head(tt_tree1)
tree1_trace <-
  TreeTracer::get_trace_data(
    tree_data = tt_tree1,
    rf = penguin_rf,
    train = penguin_features
  )
# One tree trace plot
penguin_trace_tree1 <-
  TreeTracer::trace_plot(
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1,
    alpha = 1
  )
plot(penguin_trace_tree1)
# Multiple tree trace plot
ntrees = penguin_rf$ntree
penguin_trace <-
  TreeTracer::trace_plot(
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:ntrees,
    alpha = 0.4
  )
plot(penguin_trace)
## Extending trace plot
penguin_trace_col <-
  trace_plot( 
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:ntrees,
    alpha = 0.4,
    tree_color = "#9dad7f"
  )
plot(penguin_trace_col)
##Display a rapresentative tree
penguin_trace_rep <-
  trace_plot( 
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:ntrees,
    alpha = 0.4,
    tree_color = "#9dad7f",
    rep_tree =
      get_tree_data(
        rf = penguin_rf,
        k = 12
      ),
    rep_tree_size = 1.5,
    rep_tree_alpha = 0.9,
    rep_tree_color = "#557174"
  ) + 
  labs(
    title = "Highlighting Tree 12"
  )
plot(penguin_trace_rep)
##Color by ID
penguin_trace_by_id <-
  trace_plot( 
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:6,
    alpha = 0.9, 
    color_by_id = TRUE
  ) + 
  scale_color_manual(
    values = c(
      "#c7cfb7",
      "#9dad7f",
      "#557174",
      "#D67236",
      "#F1BB7B",
      "#916a89"
    ))
plot(penguin_trace_by_id)
##Facet by ID
penguin_trace_facet <-
  trace_plot( 
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:6,
    alpha = 0.9, 
    color_by_id = TRUE, 
    facet_by_id = TRUE
  ) + 
  scale_color_manual(
    values = c(
      "#c7cfb7",
      "#9dad7f",
      "#557174",
      "#D67236",
      "#F1BB7B",
      "#916a89"
    ))
plot(penguin_trace_facet)
##Maximum Depth
penguin_trace_max <-
  trace_plot( 
    rf = penguin_rf,
    train = penguin_features,
    tree_ids = 1:ntrees,
    alpha = 0.4,
    max_depth = 3
  )
plot(penguin_trace_max)

#################################
