---
title: "readme"
output: html_document
date: "2025-10-16"
---

```{r setup, include=FALSE}
install.packages("devtools") #Package need to install packages from repositories
library(devtools) #load package

install_github("noctilucass/useData") # This function from devtools allows you to install repositories from github. First you write the username and second the repository
library(useData) #Load the package
```

```{r}
?mndot() #Read the help instructions, this functions allows you to imoprt the CAT file directly with all his columns formatted. You can either choose the file interactive or by writing the path to it. 

?plot_ox() #This function can save you a lot of time when you want to plot the oxygen of multiples cat files all at the same time. Leave all the files in one folder and write the path to the FOLDER. the filename will be the title of each plot. 

?plot_temp() #This function can save you a lot of time when you want to plot the temperature multiples cat files all at the same time. Leave all the files in one folder and write the path to the FOLDER. the filename will be the title of each plot.
```


```{r}
#Examples

mndot(file_choose = T)
mndot(file_choose = F, path = "path/to/the/cat.txt")

plot_ox(path = "path/to/the/folder", interactive = T, facet = T) #Interactive will make a plot using ggplotly where you can see info of each point inside the plot. 

plot_temp(path = "path/to/the/folder", interactive = T, facet = T) #Interactive will make a plot using ggplotly where you can see info of each point inside the plot. 
```

