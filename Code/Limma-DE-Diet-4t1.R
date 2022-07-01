library(edgeR)
library(tidyverse)

# This path should point at the count table
countData <- read.csv("/Users/jameswengler/final_count_table_GW.csv", row.names = 1)
# This path should point to the metadata table
metaData <- read.csv("/Users/jameswengler/meta_count_table_GW.csv")

only4T1Count <- function(countTable){
    mod_count <- select(countTable, "X1A", "X2A", "X3A", "X4A", "X5A", "X6A", "X1C", "X2C", "X3G", "X4C", "X5C", "X6C")
    return(mod_count)
}

only4T1Meta <- function(metaTable){
    mod_meta <- filter(metaTable, mouse == "4T1" & treatment == "Control")
    return(mod_meta)
}

new_count <- only4T1Count(countData)
new_meta <- only4T1Meta(metaData)

data <- DGEList(new_count)
d0 <- calcNormFactors(data)

cutoff <- 20
drop <- which(apply(cpm(d0), 1, max) < cutoff)
d <- d0[-drop,] 
dim(d) # number of genes left

group = pull(new_meta, diet)

# snames <- colnames(new_count)
# plotMDS(d)

mm <- model.matrix(~ 0 + group)
y <- voom(d, mm, plot = T)

fit <- lmFit(y, mm)

fit <- eBayes(fit)
topTable(fit, number = 20)
write.csv(topTable(fit, number = 10000, p.value = .05), file = "LIMMA-4T1.csv")
# 7353 genes with adjusted pval < .05
