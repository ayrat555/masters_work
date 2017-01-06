#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)
file_name = args[1]
number_of_clusters = strtoi(args[2])

library(pamr)

current_directory <- getwd()
proximity_matrix_file <- paste(current_directory, "/data/output/", file_name, sep = "")

x<-read.table(proximity_matrix_file,sep=',',dec=',',nrows=273,header=F)
p<-pam(x,number_of_clusters,diss=T)
clus<-p$clustering
clusplot(x,clus,shade=T)
