#####################################################
#                                                   #
#               E0771-Diet.R                        #
#               James Wengler - jwengler@gmail.com  #
#               Last Modified: June 21, 2022        #
#                                                   #
#####################################################
# The purpose of this script is to try to mitigate the confounding effect of having two different mouse models

library(tidyverse)
library(DESeq2)

# This path should point at the count table
countData <- read.csv("/Users/jameswengler/final_count_table.csv", row.names = 1)
# This path should point to the metadata table
metaData <- read.csv("/Users/jameswengler/meta_count_table.csv")

only4T1Count <- function(countTable){
    mod_count <- select(countTable, "X1G", "X2G", "X3G", "X4G", "X5G", "X6G", "X1H", "X2H", "X3H", "X4H", "X5H", "X6H")
    return(mod_count)
}

only4T1Meta <- function(metaTable){
    mod_meta <- filter(metaTable, mouse == "E0771" & diet == "HighFatDiet")
    return(mod_meta)
}

new_count <- only4T1Count(countData)
new_meta <- only4T1Meta(metaData)

dds <- DESeqDataSetFromMatrix(countData = new_count, colData = new_meta, design = ~treatment)

# Analysis below! This can be a traditional DESeq analysis, a PCA graph, whatever you decide
# This is a great resource for looking at the various things DESeq2 can do: https://lashlock.github.io/compbio/R_presentation.html
dds <- DESeq(dds)

vsdata <- vst(dds)
plotPCA(vsdata, intgroup = "diet")

res <- results(dds)
summary(res)
res <- res[order(res$padj, decreasing = FALSE),]
print(head(res, n = 10))