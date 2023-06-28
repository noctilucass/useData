#' Minidot function
#' 
#' Import directly minidot files concatenated with all its columns ready to use for any purpose
#' 
#' @param file_chose Interactively chose the file that you need to import, if FALSE write the path
#' @export
mndot<-function(file_choose=F, path){
  if(file_choose==TRUE) {dat<-read.csv(file.choose(),skip = 6)}
  if(file_choose==FALSE) {dat<-read.csv(path,skip = 6)}
  dat<-dat[-1,2:7]
  UTC<-format(as.POSIXct(dat$UTC_Date_._Time), format = "%y-%m-%d %H:%M")
  UTC<-lubridate::as_datetime(UTC, format = "%y-%m-%d %H:%M")
  HoraChile<-format(as.POSIXct(dat$Hora.de.Chile), format = "%y-%m-%d %H:%M")
  HoraChile<-lubridate::as_datetime(HoraChile, format = "%y-%m-%d %H:%M")
  Battery<-as.numeric(dat$Battery)
  Temperature<-as.numeric(dat$Temperature)
  DissolvedOxygen<-as.numeric(dat$Dissolved.Oxygen)
  SaturationOxygen<-as.numeric(dat$Dissolved.Oxygen.Saturation)
  data.frame(UTC,HoraChile,Battery,Temperature,DissolvedOxygen,SaturationOxygen)
}

#' HOBO function
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
#' @export
plot_ox<-function(path){
  require(ggplot2)
  require(dplyr)
  x=list.files(path,pattern = c(".TXT",".txt",".csv",".CSV"),recursive = TRUE, full.names = T)
  a<-function(path){
    dat<-read.csv(path,skip = 6)
    dat<-dat[-1,2:7]
    UTC<-format(as.POSIXct(dat$UTC_Date_._Time), format = "%y-%m-%d %H:%M")
    UTC<-lubridate::as_datetime(UTC, format = "%y-%m-%d %H:%M")
    HoraChile<-format(as.POSIXct(dat$Hora.de.Chile), format = "%y-%m-%d %H:%M")
    HoraChile<-lubridate::as_datetime(HoraChile, format = "%y-%m-%d %H:%M")
    Battery<-as.numeric(dat$Battery)
    Temperature<-as.numeric(dat$Temperature)
    DissolvedOxygen<-as.numeric(dat$Dissolved.Oxygen)
    SaturationOxygen<-as.numeric(dat$Dissolved.Oxygen.Saturation)
    data.frame(UTC,HoraChile,Battery,Temperature,DissolvedOxygen,SaturationOxygen)}
   b=lapply(x,a)
  names(b) = basename(x) # give them the file name
  for(i in seq_along(b))
    b[[i]]$df_name = names(b)[i]
  df <- do.call(rbind, b)  # bind them all together
  print(ggplot(data = df,aes(HoraChile, SaturationOxygen))+geom_point()+facet_grid(~df_name))
}

