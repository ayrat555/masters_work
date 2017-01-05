#!/usr/bin/Rscript
library(pamr)

current_directory <- getwd()
proximity_matrix_file <- paste(current_directory, "/data/output/proximity_matrix1.csv", sep = "")

x<-read.table(proximity_matrix_file,sep=',',dec=',',nrows=273,header=F)
p<-pam(x,2,diss=T)
clus<-p$clustering
clusplot(x,clus,shade=T)
