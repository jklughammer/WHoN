library(shiny)
library(ggplot2)
library(data.table)


theme_set(theme_bw())
diff_cols=c("#e41a1c","#1D81F3","#4daf4a","#984ea3","#ff7f00","#F5DC3F","#964B00","#999999")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  withProgress(message='Loading data ...',detail="might take a while...",{
      incProgress(1/4)
      load("nations_data_exp.RData")
      incProgress(1/2)
   
})


  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  
  output$plot<- renderPlot({

    ggplot(all_data[year==input$time],aes(x=income.prox,y=lifeExpectancy.prox,size=population.prox,fill=region))+geom_point(shape=21)+xlab("log10(income)")+ylab("life expectancy")+scale_size_continuous(range=c(input$min,input$max),limits=c(3.500e+02,1.327e+09))+ylim(c(10,100))+scale_x_continuous(breaks=c(300,400,1000,2000,3000,4000,10000,20000,30000,40000,100000), trans="log1p", expand=c(0,0),limits=c(300,100000))
    
  
    
  })

})

