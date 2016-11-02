library("shiny")
#library(data.table)



shinyUI(fluidPage(
  
  # Application title
  titlePanel("World Wealth and Health"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
#    textInput("GOIs", label = h3("Genes of Interest"), value = "...enter GOIs here..."),
    #Action Button
#    actionButton("goButton", "Go!"),
#    helpText(h4("Some cool genes to copy+paste...")),
#    helpText(paste(GOIs=c("GCG","GC","TTR","TM4SF4","RFX3","INS","PDX1","DLK1","ARX","PPY","SST","HHEX","KRT19","KRT18","KRT8","HNF1B","ITGB2","PTPRC","TMSB4X","MTRNR2L2","PROM1","KIT","CD34","PECAM1","VWF","SPP1","MMP7","CD24","ICAM1","AMY2A","REG1A","PRSS2","NEUROD1","BCL2","NKX6-1","HNF4A","HNF1A","PAX4","PAX6","MAFA","MAFB",c("NEUROD1","MORF4L1","PDX1","BMI1","ARX","IRX2","MEIS1","ETV1","DLK1","GC", "INSM1" , "FOXA2", "...")),collapse=" ")),
    
    sliderInput("min",
                "Minimum bubble size:",
                min = 1,  max = 10, value = 2),
    sliderInput("max",
                "Maximum bubble size:",
                min = 10,  max = 30,  value = 20 ),
    
    sliderInput("time",
                "Time:",
                min = 1800,  max = 2008, value = 1800)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      helpText(h4("Each dot represents one nation...")),
      plotOutput("plot",width="900px",height="750px")
      
    )
  )
))