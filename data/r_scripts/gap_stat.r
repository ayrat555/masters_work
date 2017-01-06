#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)
file_name = args[1]
max_number_of_clusters = strtoi(args[2])

current_directory <- getwd()
proximity_matrix_file <- paste(current_directory, "/data/output/", file_name, sep = "")

library(cluster)

#reading dissimilarity matrix
delim = "," 
dec = "."
myDataFrame <- read.csv(proximity_matrix_file, header=FALSE, sep=delim, dec=dec, stringsAsFactors=FALSE)

#calculating optimal number of clusters
gap_stat <- clusGap(myDataFrame, FUN = pam, K.max = max_number_of_clusters, B = 20)

print(gap_stat, method = "Tibs2001SEmax")

