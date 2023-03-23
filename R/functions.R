#' Minidot import
#' 
#' Import directly minidot files concatenated with all its columns ready to use for any purpose
#' 
#' @param file_path Characther path to the file
#' @export
mndot<-function(file_path){
  dat<-read.csv(file_path,skip = 6)
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


