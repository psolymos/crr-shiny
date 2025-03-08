



flist<-readRDS("flist_deploy.Rds")



library(rsconnect)

options(rsconnect.max.bundle.files=100000)
options(rsconnect.max.bundle.size=3145728000)

rsconnect::setAccountInfo(name='albertaccrec',
                          token='1A720D255AD225BC41B85D0A4BE21737',
                          secret='efRoDZQqcUtavgmor7GHiF4g+ZbPwejycra255Lm')

rsconnect::deployApp(appName = "template1",account = "albertaccrec", appFiles=flist, logLevel = "verbose",lint = T,upload=T)



