# input: 
# model: classification model
# data: training set
# class: response variable
#https://rpubs.com/ZheWangDataAnalytics/DecisionBoundary
set.seed(123)
data(iris)

boundary <- function(model, data, class = NULL, predict_type = "class",
                     resolution = 100, showgrid = TRUE, ...) {
  
  if(!is.null(class)) cl <- data[,class] else cl <- 1
  data <- data[,1:2]
  k <- length(unique(cl))
  
  plot(data, col = as.integer(cl)+1L, pch = as.integer(cl)+1L, ...)
  
  # make grid
  r <- sapply(data, range, na.rm = TRUE)
  xs <- seq(r[1,1], r[2,1], length.out = resolution)
  ys <- seq(r[1,2], r[2,2], length.out = resolution)
  g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
  colnames(g) <- colnames(r)
  g <- as.data.frame(g)
  
  ### guess how to get class labels from predict
  ### (unfortunately not very consistent between models)
  p <- predict(model, g, type = predict_type)
  if(is.list(p)) p <- p$class
  p <- as.factor(p)
  
  if(showgrid) points(g, col = as.integer(p)+1L, pch = ".")
  
  z <- matrix(as.integer(p), nrow = resolution, byrow = TRUE)
  contour(xs, ys, z, add = TRUE, drawlabels = FALSE,
          lwd = 2, levels = (1:(k-1))+.5)
  
  invisible(z)
}

# only use two predictors
x <- iris[1:150, c("Sepal.Length", "Sepal.Width", "Species")]
plot(x[,1:2], col = x[,3])

############ versicolor / virginica
model1 <- glm(Species ~ Sepal.Length + Sepal.Width, data = x[51:150,], family=binomial(link='logit'))
class(model1) <- c("lr", class(model1))

# specify the cutoff point for prediction
predict.lr <- function(object, newdata, ...)
  predict.glm(object, newdata, type = "response") > .5
boundary(model1, x[51:150,], class = "Species", main = "Logistic Regression")


############ setosa / versicolor
model2 <- glm(Species ~ Sepal.Length + Sepal.Width, data = x[1:100,], family=binomial(link='logit'))
class(model2) <- c("lr", class(model2))

# specify the cutoff point for prediction
predict.lr <- function(object, newdata, ...)
  predict.glm(object, newdata, type = "response") > .5
boundary(model2, x[1:100,], class = "Species", main = "Logistic Regression")

