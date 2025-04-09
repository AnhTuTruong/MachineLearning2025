setwd("/Users/truonganhtu/Documents/Machine_Learning_2025/DataVisualization/Shinyapp/")

# install.packages("shiny")
# install.packages("gridExtra")
# install.packages("ggplot2")
# install.packages("reshape2")

library("shiny")
library("gridExtra")
library("ggplot2")
library("reshape2")

#Create a app.R template
# path = "/Users/truonganhtu/Documents/Machine_Learning_2025/DataVisualization/Shinyapp/"
# shinyAppTemplate(path = path, examples = "default", dryrun = FALSE) #choose 2, then "y"

#example for classification of male and female based on height

# X: height (meters)
# Y: gender (male, female)

# ui - user interface
ui = fluidPage(
  titlePanel(
    h1("Bayesian Decision Theory: How Prior affects Posterior")
  ),
  
  withMathJax(
    helpText('$$P(Y=female|X)=\\frac{P(X|Y=female)*P(Y=female)}{P(X)}=\\frac{P(X|Y=female)*P(Y=female)}{P(X|Y=female)*P(Y=female)+P(X|Y=male)*P(Y=male)}=\\frac{Likelihood*Prior}{Evidence}=Posterior$$')
  ),
  
  fluidRow(
    column(4,
      sliderInput(inputId='prior_f', label='Set Prior distribution of female P(Y=female)', value=0.50, min=0.00, max=1.00),
      sliderInput(inputId='f_h_mean', label='Set mean for height distribution of female E(X|Y=female)', value=1.50, min=1.00, max=2.00),
      sliderInput(inputId='m_h_mean', label='Set mean for height distribution of male E(X|Y=male)', value=1.70, min=1.00, max=2.00),
      sliderInput(inputId='f_h_std', label='Set STD for height distribution of female STD(X|Y=female)', value=0.1, min=0.05, max=0.2),
      sliderInput(inputId='m_h_std', label='Set STD for height distribution of male STD(X|Y=male)', value=0.1, min=0.05, max=0.2)
    ),
    column(8,
      plotOutput(outputId='barplot', width="100%", height = "800px")
    )
  )
)

# server R
server = function(input, output) {
  output$barplot = renderPlot({
    #Initialization
    height = seq(1.2, 2.2, by = 0.01)
    
    ### Prior Distribution or Class Probability P(Y = y)
    # P(Y = female)
    Y_f = input$prior_f
    # P(Y = male)
    Y_m = 1 - Y_f
    # Put them to the dataframe to be plotted
    prior = data.frame(gender=c("Y=male", "Y=female"), PY=c(Y_m, Y_f), check.names=F)
    
    ### Likelihood or L(X | Y = y)
    # L(X | Y = female)
    X_Yf = dnorm(height, mean = input$f_h_mean, sd = input$f_h_std)
    # L(X | Y = male)
    X_Ym = dnorm(height, mean = input$m_h_mean, sd = input$m_h_std)
    # Put them to the dataframe to be plotted
    likelihood = data.frame(X_height = height, "L(X|Y=male)"=X_Ym, "L(X|Y=female)"=X_Yf, check.names=F)
    likelihood = melt(likelihood, id.vars = 'X_height')
    colnames(likelihood) = c('X_height', 'likelihood_type', 'likelihood_value')
    
    ### Marginal / Evidence or P(X = x) or L(X)
    PX = X_Yf*Y_f + X_Ym*Y_m
    # Put them to the dataframe to be plotted
    evidence = data.frame(X_height = height, PX = PX, check.names = F)
    
    ### Posterior or P(Y = y | X)
    Yf_X = (X_Yf * Y_f) / PX
    Ym_X = (X_Ym * Y_m) / PX
    # Put them to the dataframe to be plotted
    posterior = data.frame(X_height = height, "P(Y=male | X)"=Ym_X, "P(Y=female | X)"=Yf_X, check.names=F)
    posterior = melt(posterior, id.vars = 'X_height')
    colnames(posterior) = c('X_height', 'posterior_type', 'posterior_value')
    
    ### Plot all with ggplot
    # Prior plot P(y=y)
    prior_p = ggplot(data = prior, aes(x = gender, y = PY)) +
      geom_bar(stat = "identity", fill =c("dodgerblue", "pink")) +
      ylab('Prior P(Y=y)') +
      ylim(0, 1.0) +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      xlab('') +
      ggtitle('Prior P(Y=y)') +
      theme(plot.title = element_text(hjust = 0.5))
    
    # Likelihood plot P(X|Y=y)
    likelihood_p = ggplot(data = likelihood, aes(x=X_height, y=likelihood_value, colour=likelihood_type)) +
      geom_line(size = 2) +
      scale_color_manual(values = c("dodgerblue", "pink")) +
      ylab('Likelihood L(X|Y=y)') +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      xlab('') +
      ggtitle('Likelihood L(X|Y=y)') +
      theme(plot.title = element_text(hjust = 0.5))
    
    # Evidence plot P(X=x)
    evidence_p = ggplot(data = evidence, aes(x = X_height, y = PX)) +
      geom_line(size = 1.5, color = "forestgreen") +
      ylab('Evidence L(X)') +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      ggtitle('Evidence L(X)') +
      theme(plot.title = element_text(hjust = 0.5))
    
    # Posterior plot P(Y=y|X)
    posterior_p = ggplot(data = posterior, aes(x=X_height, y=posterior_value, colour=posterior_type )) +
      geom_line(size = 2) +
      scale_color_manual(values = c("dodgerblue", "pink")) +
      ylab('Posterior P(Y=y|X)') +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      xlab('') +
      ggtitle('Posterior P(Y=y|X)') +
      theme(plot.title = element_text(hjust = 0.5))
    
    
    ### use Grid to split plots
    g = grid.arrange(prior_p, likelihood_p, evidence_p, posterior_p, nrow=2, ncol=2)
    
  })
}

shinyApp(ui, server)

#Why melting likelihood and posterior?

#Before melting:
# X_height  P(X|Y=male)  P(X|Y=female)
#   160          0.1            0.4
#   165          0.3            0.2
#   170          0.2            0.1

#After melting:
# X_height       variable     value
#   160         P(X|Y=male)    0.1
#   165         P(X|Y=male)    0.3
#   170         P(X|Y=male)    0.2
#   160       P(X|Y=female)    0.4
#   165       P(X|Y=female)    0.2
#   170       P(X|Y=female)    0.1

#Youtube 1: https://www.youtube.com/watch?v=HZGCoVF3YvM (prior affects posterior)
#Youtube 2: https://www.youtube.com/watch?v=9wCnvr7Xw4E