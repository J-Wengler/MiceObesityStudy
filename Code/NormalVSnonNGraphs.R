#####################################################
#                                                   #
#               NormalVSnonNGraphs.R                #
#               James Wengler - jwengler@gmail.com  #
#               Last Modified: June 28, 2022        #
#                                                   #
#####################################################
# Script to compare the normalized vs TPM data

library(tidyverse)

logTransformCounts <- function(vec){
    return (log2(vec))
}

data.dirty <- read.csv("/Users/jameswengler/final_count_table_GW.csv", row.names = 1)
data.dirty <- data.dirty[rowSums(data.dirty[])> 1, ]
data.dirty <- log2(data.dirty)
