library(DESeq2)
library(tidyverse)

#returnBaselineCount <- function(countData){
#    
#    newData = select(countData, "X1A", "X2A", "X3A", "X4A", "X5A", "X6A", "X1E", "X2E", "X3E", "X4E", "X5E", "X6E")
#    return(newData)
#}
#
#returnBaselineMeta <- function(metaData){
#    
#    newData = filter(metaData, dex == "4T1-NormalDiet-Control" | dex == "E0771-NormalDiet-Control")
#    return(newData)
#}
#
#
countData <- read.csv("/Users/jameswengler/final_count_table.csv", row.names = 1)
countDrop <- drop
metaData <- read.csv("/Users/jameswengler/meta_count_table.csv")


dds <- DESeqDataSetFromMatrix(countData = countData, colData = metaData, design = ~treatment)

dds <- DESeq(dds)
#res <- results(dds)
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup = "treatment")