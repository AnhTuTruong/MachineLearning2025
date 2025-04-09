setwd("/Users/truonganhtu/Documents/Machine_Learning_2025/DataVisualization/Shinyapp/")

#install.packages("shiny")
#install.packages("gridExtra")
#install.packages("ggplot2")
#install.packages("reshape2")

library("shiny")
library("gridExtra")
library("ggplot2")
library("reshape2")

#Create a app.R template
#path = "/Users/truonganhtu/Documents/Machine_Learning_2025/DataVisualization/Shinyapp/"
#shinyAppTemplate(path = path, examples = "default", dryrun = FALSE) #choose 2, then "y"

# Illustration of variance and standard deviation

# ui - user interface
ui = fluidPage(
  titlePanel(
    h1("Illustration of Variance, Standard Deviation and Location")
  ),
  
  withMathJax(
    helpText('$$Var\\_sample = s^2 = \\frac{\\sum_{i=1}^{n} (x_i - \\bar{x})^2}{n-1}$$')
  ),
  
  fluidRow(
    column(4,
      sliderInput(inputId='price_mean_1', label='Set mean for sample 1 E(X1)', value=100, min=50, max=150),
      sliderInput(inputId='price_std_1', label='Set STD for sample STD(X1)', value=10, min=5, max=20),
      sliderInput(inputId='price_mean_2', label='Set mean for sample 2 E(X2)', value=125, min=50, max=150),
      sliderInput(inputId='price_std_2', label='Set STD for sample STD(X2)', value=10, min=5, max=20)
    ),
    column(8,
      plotOutput(outputId='barplot', width="100%", height = "600px")
    )
  )
)

# server R
server = function(input, output) {
  output$barplot = renderPlot({
    #Initialization
    n = 50
    stock_price_1 = rnorm(n, mean = input$price_mean_1, sd = input$price_std_1)
    stock_price_2 = rnorm(n, mean = input$price_mean_2, sd = input$price_std_2)
    
    df_stock_price = data.frame(
      "Company_1" = stock_price_1,
      "Company_2" = stock_price_2,
      check.names = F
    )
    
    df_stock_price = melt(df_stock_price)
    colnames(df_stock_price) = c('Company', 'Stock_Price')
    df_stock_price$Time = c(rep(seq(1, n, by = 1),2))
    
    ### Plot all with ggplot
    # Stock_Price changes over Time (Stock_Price ~ Time)
    price_time_p = ggplot(data = df_stock_price, aes(x = Time, y = Stock_Price, colour = Company)) +
      geom_line(size = 1.2) +
      geom_point() +
      geom_hline(yintercept = input$price_mean_1, colour = 'black', linetype = 'dashed') +
      geom_hline(yintercept = input$price_mean_2, colour = 'black', linetype = 'dashed') +
      ylab('Stock Price') +
      ylim(25, 175)  +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      xlab('Time') +
      ggtitle('Stock Price changes over Time \n(Var Illustration)') +
      scale_color_manual(values = c("darkorange", "steelblue")) +
      theme(plot.title = element_text(hjust = 0.3))
    
    # Density/Likelihood of Stock_Price
    price_density_p = ggplot(data = df_stock_price, aes(x = Stock_Price, colour = Company)) +
      geom_density(alpha = 0.5) +
      scale_color_manual(values = c("darkorange", "steelblue")) +
      geom_vline(xintercept = input$price_mean_1, colour = 'black', linetype = 'dashed') +
      geom_vline(xintercept = input$price_mean_2, colour = 'black', linetype = 'dashed') +
      ylab('Density') +
      xlim(0, 200)  +
      ylim(0, 0.1) +
      theme(text = element_text(size = 20), legend.title = element_blank()) +
      xlab('Stock Price') +
      ggtitle('Density of Stock Price \n(STD Illustration)') +
      theme(plot.title = element_text(hjust = 0.5))
    
    
    ### use Grid to split plots
    g = grid.arrange(price_time_p, price_density_p, nrow=1, ncol=2)
    
    print(df_stock_price)
    
  })
}

shinyApp(ui, server)