library(jsonlite)
library(tidyjson)   # this library
library(dplyr) 
library(data.table)
library(zoo)
library(ggplot2)

theme_set(theme_bw())
setwd("/data/groups/lab_bock/jklughammer/gitRepos/otherProjects/IMED2016/world_health/")

json=readLines("nations.json")
json_corr=gsub("\\[([0-9]+),([0-9]+[\\.]*[0-9]+)\\]",'{\"year\": \\1,\"value\": \\2}',json,perl=TRUE)


income_dt <- data.table(json_corr %>%
  gather_array %>%                    
  spread_values(name = jstring("name")) %>% 
  spread_values(region = jstring("region")) %>%
  enter_object("income") %>% gather_array %>%
  spread_values(                                
    year = jnumber("year"),
    income = jnumber("value")
  ) %>%# stack the purchases
  select(name, region, year, income)) 


population_dt <- as.data.table(json_corr %>%
  gather_array %>%                                 
  spread_values(name = jstring("name")) %>% 
  spread_values(region = jstring("region")) %>%
  enter_object("population") %>% gather_array %>%
  spread_values(                                      
    year = jnumber("year"),
    population = jnumber("value")
  ) %>%# stack the purchases
  select(name, region, year, population)) 


lifeExpectancy_dt <- as.data.table(json_corr %>%
  gather_array %>%                                    
  spread_values(name = jstring("name")) %>% 
  spread_values(region = jstring("region")) %>%
  enter_object("lifeExpectancy") %>% gather_array %>%
     spread_values(                                      
         year = jnumber("year"),
         lifeExpectancy = jnumber("value")
         ) %>%# stack the purchases
    select(name, region, year, lifeExpectancy)) 

all_data_pre=merge(income_dt,population_dt,by=c("name","region","year"),all.x=TRUE,all.y=TRUE)
all_data=merge(all_data_pre,lifeExpectancy_dt,by=c("name","region","year"),all.x=TRUE,all.y=TRUE)


#interpolate missing values

expanded=as.data.table(expand.grid(all_data[,c("name","year"),with=FALSE]))
all_data=merge(all_data,unique(expanded),by=c("name","year"),all.x=TRUE,all.y=TRUE)
all_data=all_data[order(year)]
all_data[,region:=na.omit(region)[1],by="name"]


all_data[,income.prox:=tail(head(na.approx(c(first(na.omit(income)),income,last(na.omit(income)))),-1),-1),by=c("name","region")]


all_data[,population.prox:=tail(head(na.approx(c(first(na.omit(population)),population,last(na.omit(population)))),-1),-1),by=c("name","region")]

all_data[,lifeExpectancy.prox:=tail(head(na.approx(c(first(na.omit(lifeExpectancy)),lifeExpectancy,last(na.omit(lifeExpectancy)))),-1),-1),by=c("name","region")]



save(all_data,file="nations_data_exp.RData")


ggplot(all_data[year==1801],aes(x=log10(income.prox),y=lifeExpectancy.prox,size=population.prox,fill=region))+geom_point(shape=21)+xlab("log10(income)")+ylab("life expectancy")+scale_size_continuous(range=c(2,30))




