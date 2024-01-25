####Day 2 notes STATISTICS
#you need to know your question in order to properly select the right stats
#BEFORE YOU DO ANY STATS ***FIRST THING --> PLOT YOUR DATA
#1) experimental design, 2)plot your data, 3) make a model 4)evaluate assumptions
#5) evaluate model conclusions 6) add interpretation figure to your data

#different groups --> looking at the mean between two groups

##load libraries
library("tidyverse") #data manipulation and plotting

#read in my data
GardenOzone <- read.csv("data/GardenOzone.csv")

#Look at the data
str(GardenOzone)
head(GardenOzone)

#make a plot
ggplot(GardenOzone, aes(x= Ozone, fill = Garden.location))+
  geom_histogram(bins = 8, colour = "black") +
    theme_bw() +
  facet_wrap(~Garden.location, ncol =1)

#grouping by Garden.location will give the difference between East and West
GardenOzone %>%
    group_by(Garden.location)%>%
  summarise(meanOzone = mean(Ozone),
            varOzone = var(Ozone))
            
#t-test (Y ~ X, data= dataframe name) Y= the thing we are interested in changing 
#what are the assumptions = that the variance of the two groups are equal!! (the spread)
#Welsh's t-test accounts for unequal variance --> add the var.equal = FALSE
t.test(Ozone ~ Garden.location, data = GardenOzone, var.equal = FALSE)
# df = total number of observations minus two (two variables), t value can be reported to 3 sf

#General Linear Models (ANOVA, ANCOVA, Regression, Multiple Regression, Non-linear)
#equation for a line y= mX + c (c= intercept, m= slope, X= the variable)

#look at linear regression
#read in my data
plant <- read.csv("data/plant.growth.rate.csv")

#look at my data
str(plant)

#make a plot
ggplot(plant, aes(x = soil.moisture.content, y = plant.growth.rate))+
  geom_point()+
  theme_classic()

model1 <- lm(plant.growth.rate ~ soil.moisture.content, data = plant)
#check your assumptions first

model1
#gives you the intercept and the slope values

#install.packages("ggfortify")
library(ggfortify)
autoplot(model1)
#autoplot shows the normality of the residuals, ignore the lines and look at the points. 
#Residual vs Fitted is the most important!! If this doesn't look right then we have fit the wrong model!
#this is looking at the error in the data --> you want evenly spread above and below the line
#the residuals are the points from the line. You don't want a pattern of any kind!!
#if you are trying to fit a linear model to curved data you will pick up non-linearty.
#if you have more than one explanatory variable and that's not within your model, then 
#see a pattern within your data and you need to transform your data or pick a different model. 
#EXPECTATION the same amount of variance within the data
#you want a 'sky at night' distribution of points
#Normal Q-Q normal distribution = you want the points to fall on the line, however 
#they will never fall perfectly. The ones to be concerned about are the patterns outside of this
#count data, percentages etc
#linear model --> means that you have a linear relationship!!
#Cook's distance = outliers (the placements of an outliers cause a dip on the line
#leverage. Imagine a long line and then like a see saw the outliers cause a dip.
#Within the plot the outliers of question are numbered. 

#the workhorses! Creates a table 
anova(model1) #shows your p-values (significance)

summary(model1) # this gives the co-efficients (slope and intercept)
#tvalue not important but you want it further from 0
#add the values of the slope and the error when reporting 
#R-squared is the important value!! Use the adjusted R-squared (how close are the points to the line)
#report that you have used the R-squared adjusted values 
#Also if you have lots of variables, then the R-Square goes up, adjusted accounts for this

#add a trend line
#geom_smooth() is not a stats based, it's just to show you a visual trend. 
#only really works when you have 2 variables 
#if you have more than two varables then you will need to calculate the trend line
#To calculate it properly--it's annoying and it's takes ages but it's the proper way to do it
#seq -->look at your x values, here it's from 0 to 2.5!!

newX <- expand.grid(soil.moisture.content = seq(from = 0, to =2.5, length = 10))
newX

newY <- predict(model1, newdata = newX, interval = "confidence")
newY

#create new dataframe
addThese <- data.frame(newX, newY)
addThese

#fit = Y, rename
addThese <- addThese %>%
  rename(plant.growth.rate = fit)

addThese
#plot
ggplot(plant, aes(x = soil.moisture.content, y = plant.growth.rate))+
  geom_point()+
 geom_smooth(data = addThese, aes(ymin = lwr, ymax = upr), stat ="identity")

#aes was inherited
#stat = identity means do only what I tell you to do


###################################################
#read in my data
Daphnia <- read.csv("data/Daphniagrowth.csv")

library(tidyverse)
library(ggfortify)


#Look at the data
glimpse(Daphnia)
head(Daphnia)

#Plot
ggplot(Daphnia, aes(x = parasite, y = growth.rate))+
  geom_boxplot() +
  coord_flip()

#linear model
model2 <- lm(growth.rate ~ parasite, data = Daphnia)
#check assumptions
autoplot(model2)
#have you fitted the right model?? Look at Residuals vs Fitted
#you want constant variance as the mean increases
#these will look messier if you don't have a lot of data

#look at the model conclusions
anova(model2)
#nice simple table to interpret!
#you're testing the MEAN of the growth rates between groups. 
#You're testing if there is a difference
#F value high and p value low = significant!
summary(model2)
#intercept -> is the control (but listed alphabetically)
#mean of the growth rate for the control group
#the following terms within the summary tables are showing the difference between 
#the means from the control. All are compared to the first value. 
#Look at what the typical R-Square valuesare in your field. In ecology typically 0.3 (1 is perfect)

#Tukey Test --> tests all of the pairwise combinations
#you can you the code re-level
#p.adjust() (you can adjust your p value)
#usually there are a couple of pairwise combinations that you care about

###################################################################
ANCOVA
##################################################################
#read in my data
limpet <- read.csv("data/limpet.csv")

#look at the data
glimpse(limpet)

#plot
ggplot(limpet, aes(x = DENSITY, y = EGGS, colour = SEASON))+
    geom_point(size = 4)+
  scale_colour_manual(values = c("Green", "Red"))+
  theme_bw()

#linear model 2 variable season and eggs --> interested in the interaction
model3 <- lm(EGGS ~ DENSITY * SEASON, data = limpet)
#if just interested one variable then Eggs ~ Density, or Eggs ~ season, 
#Eggs ~ Density+ Season + Density : Season (the last one is the interaction) 
#to show all including the interactions --> Eggs ~Density * Season
#straight line across the center - no relationship
#the line may show a slope therefore a relationship
#if the two lines overlap one another completely then no sign
#different intercepts but the same slope --> so each element is significant 
#but no significant interaction
#Different intercept and different slope then significant interaction
#****If you model the interaction then you must always include all terms in model 

#look at the assumptions
autoplot(model3)

#Analysis of Variance Table
anova(model3)
#if there is no significance in the interaction term then it means that 
#the two other lines run parallel to one another

summary(model3)
#the output is always 1 line= intercept, then slope, 2nd line = intercept, slope

#expand.grid is code that all possible combination within the dataset exists
newX <- expand.grid(DENSITY = seq(from = 0, to = 50, length = 10),
                    SEASON = c("spring", "summer"))
newX

newY <- predict(model3, newdata = newX, interval = "confidence")
newY

#create new dataframe
addThese <- data.frame(newX, newY)
addThese

#fit = Y, rename
addThese <- addThese %>%
  rename(EGGS = fit)

addThese
#plot
ggplot(limpet, aes(x = DENSITY, y = EGGS, Group = SEASON, fill = SEASON))+
  geom_point()+
  theme_classic()+
  scale_colour_manual(values = c("yellow", "plum"))+
  geom_smooth(data = addThese, aes(ymin = lwr, ymax = upr), stat ="identity") +
  scale_fill_manual(values = c("yellow", "plum"))
