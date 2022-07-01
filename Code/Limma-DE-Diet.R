library(edgeR)
library(tidyverse)

# This path should point at the count table
countData <- read.csv("/Users/jameswengler/final_count_table.csv", row.names = 1)
# This path should point to the metadata table
metaData <- read.csv("/Users/jameswengler/meta_count_table.csv")

only4T1Count <- function(countTable){
    mod_count <- select(countTable, "X1E", "X2E", "X3E", "X4E", "X5E", "X6E", "X1G", "X2G", "X3G", "X4G", "X5G", "X6G")
    return(mod_count)
}

only4T1Meta <- function(metaTable){
    mod_meta <- filter(metaTable, mouse == "E0771" & treatment == "Control")
    return(mod_meta)
}

new_count <- only4T1Count(countData)
new_meta <- only4T1Meta(metaData)

data <- DGEList(new_count)
d0 <- calcNormFactors(data)

cutoff <- 500
drop <- which(apply(cpm(d0), 1, max) < cutoff)
d <- d0[-drop,] 
dim(d) # number of genes left

group = pull(new_meta, diet)

# snames <- colnames(new_count)
# plotMDS(d)

mm <- model.matrix(~ group)
y <- voom(d, mm, plot = T)

fit <- lmFit(y, mm)

fit <- eBayes(fit)
topTable(fit)
