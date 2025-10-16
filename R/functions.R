#' mndot function
#' 
#' Import directly minidot files concatenated with all its columns ready to use for any purpose
#' 
#' @param file_chose Interactively chose the file that you need to import, if FALSE write the path. Default TRUE
#' @export
mndot<-function(file_choose=T, path){
  if(file_choose==TRUE) {dat<-read.csv(file.choose(),skip = 6)}
  if(file_choose==FALSE) {dat<-read.csv(path,skip = 6)}
  dat<-dat[-1,]
  UTC<-format(as.POSIXct(dat[,2]), format = "%y-%m-%d %H:%M")
  UTC<-lubridate::as_datetime(UTC, format = "%y-%m-%d %H:%M")
  DatetimeZone<-format(as.POSIXct(dat[,3]), format = "%y-%m-%d %H:%M")
  DatetimeZone<-lubridate::as_datetime(DatetimeZone, format = "%y-%m-%d %H:%M")
  Battery<-as.numeric(dat$Battery)
  Temperature<-as.numeric(dat$Temperature)
  DissolvedOxygen<-as.numeric(dat$Dissolved.Oxygen)
  SaturationOxygen<-as.numeric(dat$Dissolved.Oxygen.Saturation)
  MeasureQuality <- as.numeric(dat$q)
  data.frame(UTC,DatetimeZone,Battery,Temperature,DissolvedOxygen,SaturationOxygen)
}

#' hbo function
#' 
#' Import directly HOBO files with all its columns ready to use for any purpose
#' 
#' @param file_chose Interactively chose the file that you need to import, if FALSE write the path
#' @export
hbo<-function(file_choose=F, path){
  if(file_choose==TRUE) hobo <- readxl::read_excel(file.choose())
  if(file_choose==FALSE) hobo <- readxl::read_excel(path)
  HoraChile<-lubridate::as_datetime(hobo$`Fecha/hora (Chile Daylight Time)`)
  pH<-as.numeric(hobo$`Ch: 3 - pH   (pH)`)
  Minivoltios<-as.numeric(hobo$`Ch: 2 - Milivoltios   (mv)`)
  colnames(hobo)<-c("1","HoraChile","Temperature","pH","Minivoltios")
  Temperature<-as.numeric(hobo$Temperature)
  data.frame(HoraChile, Temperature, pH, Minivoltios)
}

#' plot_ox function
#'
#' Directly plot multiple minidot files that are in the same folder
#'
#' @param path write the path of the folder where the files are
#' @param interactive logic, TRUE or FALSE to make interactive ggplot. Default FALSE
#' @param facet logic, TRUE or FALSE to make facet ggplot. Default FALSE
#' @export
plot_ox<-function(path, interactive=F, facet=T){
  require(ggplot2)
  require(plotly)
  require(dplyr)
  require(lubridate)
  x=list.files(path, pattern = c(".TXT",".txt",".csv",".CSV"), recursive = TRUE, full.names = T)
  a<-function(path){
    dat<-read.csv(path,skip = 6)
    dat<-dat[-1,]
    UTC<-format(as.POSIXct(dat[,2]), format = "%y-%m-%d %H:%M")
    UTC<-lubridate::as_datetime(UTC, format = "%y-%m-%d %H:%M")
    DatetimeZone<-format(as.POSIXct(dat[,3]), format = "%y-%m-%d %H:%M")
    DatetimeZone<-lubridate::as_datetime(DatetimeZone, format = "%y-%m-%d %H:%M")
    Battery<-as.numeric(dat$Battery)
    Temperature<-as.numeric(dat$Temperature)
    DissolvedOxygen<-as.numeric(dat$Dissolved.Oxygen)
    SaturationOxygen<-as.numeric(dat$Dissolved.Oxygen.Saturation)
    MeasureQuality <- as.numeric(dat$q)
    data.frame(UTC,DatetimeZone,Battery,Temperature,DissolvedOxygen,SaturationOxygen)
    }
   b=lapply(x,a)
  names(b) = basename(x) # give them the file name
  for(i in seq_along(b))
    b[[i]]$df_name = names(b)[i]
  df <- do.call(rbind, b)  # bind them all together
  p<-ggplot(data = df,aes(DatetimeZone, SaturationOxygen))+geom_point()
  print(p)
  if (interactive==TRUE && facet==FALSE) {
    ggplotly(p)
  } else if (interactive==FALSE && facet==TRUE){
    print(p + facet_grid(~df_name))
  } else if (interactive==TRUE && facet==TRUE){
    ggplotly(p + facet_grid(~df_name))
  }
  }

#' Read_mndot function
#'
#' Import and concatenate
#'
#' @param path write the path of the folder where the files are
#' @export
Read_mndot<-function(path){
file_list <- list.files(path, full.names = T)
DATA<-matrix(data=NA,nrow=0,ncol=10)

for (i in 1:length(file_list)){
  
  a<-read.delim(file_list[i],skip="2", sep = ",", dec = ".")
  
  DATE<-matrix(data=NA, nrow=nrow(a),ncol=6)
  
  for (j in 1:nrow(a)){
    
    date<-as.POSIXlt(a[j,1],origin="1970-01-01")
    
    DATE[j,1]<-as.numeric(format(date,format="%Y"))
    DATE[j,2]<-as.numeric(format(date,format="%m"))
    DATE[j,3]<-as.numeric(format(date,format="%d"))
    DATE[j,4]<-as.numeric(format(date,format="%H"))
    DATE[j,5]<-as.numeric(format(date,format="%M"))
    DATE[j,6]<-as.numeric(format(date,format="%S"))
    
  }
  
data<-cbind(DATE,a[2:5])
colnames(DATA)<-colnames(data)
DATA<-rbind(DATA,data)
colnames(DATA)<-c("year","mes","dia","hora","minuto","segundo","Volts","TempC","DOmg/l","Battery")
}
assign("DATA", DATA, envir = .GlobalEnv)
}

#' plot_temp function
#'
#' Directly plot multiple minidot files that are in the same folder
#'
#' @param path write the path of the folder where the files are
#' @param interactive logic, TRUE or FALSE to make interactive ggplot
#' @param facet logic, TRUE or FALSE to make facet ggplot
#' @export
plot_temp<-function(path, interactive=F, facet=T){
  require(ggplot2)
  require(plotly)
  require(dplyr)
  x=list.files(path,pattern = c(".TXT",".txt",".csv",".CSV"),recursive = TRUE, full.names = T)
  a<-function(path){
    dat<-read.csv(path,skip = 6)
    dat<-dat[-1,]
    UTC<-format(as.POSIXct(dat[,2]), format = "%y-%m-%d %H:%M")
    UTC<-lubridate::as_datetime(UTC, format = "%y-%m-%d %H:%M")
    DatetimeZone<-format(as.POSIXct(dat[,3]), format = "%y-%m-%d %H:%M")
    DatetimeZone<-lubridate::as_datetime(DatetimeZone, format = "%y-%m-%d %H:%M")
    Battery<-as.numeric(dat$Battery)
    Temperature<-as.numeric(dat$Temperature)
    DissolvedOxygen<-as.numeric(dat$Dissolved.Oxygen)
    SaturationOxygen<-as.numeric(dat$Dissolved.Oxygen.Saturation)
    MeasureQuality <- as.numeric(dat$q)
    data.frame(UTC,DatetimeZone,Battery,Temperature,DissolvedOxygen,SaturationOxygen)}
  b=lapply(x,a)
  names(b) = basename(x) # give them the file name
  for(i in seq_along(b))
    b[[i]]$df_name = names(b)[i]
  df <- do.call(rbind, b)  # bind them all together
  p<-ggplot(data = df,aes(DatetimeZone, Temperature))+geom_point()
  print(p)
  if (interactive==TRUE && facet==FALSE) {
    ggplotly(p)
  } else if (interactive==FALSE && facet==TRUE){
    print(p + facet_grid(~df_name))
  } else if (interactive==TRUE && facet==TRUE){
    ggplotly(p + facet_grid(~df_name))
  }
}


