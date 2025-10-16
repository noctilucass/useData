
# 📈 useData: Simplifying miniDOT files in R
useData is an R package designed to make working with datasets from miniDOT loggers a breeze! 💨
✅ Directly import one or multiple datasets
✅ No need to remove header lines or manually format columns
✅ Quick plotting of oxygen 🧪 and temperature 🌡️ data across multiple files
Whether you're a marine scientist 🌊, data analyst 📊, or just exploring logger data, useData helps you get from raw files to beautiful plots in seconds! 🚀

## 📦 Installing and Loading Packages
```{r setup, include=FALSE}
install.packages("devtools") #Package need to install packages from repositories
library(devtools) #load package

install_github("noctilucass/useData") # This function from devtools allows you to install repositories from github. First you write the username and second the repository
library(useData) #Load the package
```

## ❓ Help Functions
```{r}
?mndot() #Read the help instructions, this functions allows you to imoprt the CAT file directly with all his columns formatted. You can either choose the file interactive or by writing the path to it. 

?plot_ox() #This function can save you a lot of time when you want to plot the oxygen of multiples cat files all at the same time. Leave all the files in one folder and write the path to the FOLDER. the filename will be the title of each plot. 

?plot_temp() #This function can save you a lot of time when you want to plot the temperature multiples cat files all at the same time. Leave all the files in one folder and write the path to the FOLDER. the filename will be the title of each plot.
```

## 🧪 Examples
```{r}
mndot(file_choose = T)
mndot(file_choose = F, path = "path/to/the/cat.txt")

plot_ox(path = "path/to/the/folder", interactive = T, facet = T) #Interactive will make a plot using ggplotly where you can see info of each point inside the plot. 

plot_temp(path = "path/to/the/folder", interactive = T, facet = T) #Interactive will make a plot using ggplotly where you can see info of each point inside the plot. 
```

