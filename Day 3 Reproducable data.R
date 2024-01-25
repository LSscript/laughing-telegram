#Day 3 -- Reproducibility 
#1)Document your code properly!! Comment or use Rmarkdown
#2) use scripts for analysis and data cleaning (R) 
#3) use scripts for tweaking your graphs (R)
#4) version control (e.g. Git/Github)
#5) Share and archive your code (journals ofetn mandate that you need to share it)
#6) share your data and metadata (explain your data, i.e. README file with variable names, 
#how it was collected, and anything else that would be helpful for reproducibility)
#Data Portal, Dryad (for archiving data)
#document any version details of R, R packages that were used. 
#Improving reproducibility --> take on one new task and build on the skills overtime. 
#Choose one thing to focus on to get better on and then add to your skills overtime (think kitten climbing the stairs
#A version of version control is to save your document daily i.e. My_Thesis_2023_01_25
#YYYYMMDD correct data convention!! This will sort correctly 

#set up a repo for specfic files that you want Git to track. 
#Simple Git workflow Modify, add and then commit (commit is actually what saves) add --> commit, add --> commit again and again
#Tell it when you want to save those changes --> set up a routine of when you want to save
#you need to give yourself a commit message which explains what has been changed

####When you get a new computer you need to join RStudio and Github again
#install.packages(usethis)
library(usethis)
use_git_config(user.name ="Marla Spencer", user.email = "marla.spencer@nhm.ac.uk")
usethis::create_github_token()
gitcreds::gitcreds_set()

###Linking Rstudio project to Github
#open Github
#create new repository --> then once created click the (green) Get code button and copy the url
#then create a new project in R, click version control and paste the url from Github in


Hello my name is Marla.
I am learning Github
Is this working properly???
  