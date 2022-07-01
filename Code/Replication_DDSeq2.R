#####################################################
#                                                   #
#               Replication_DDSeq2.R                #
#               James Wengler - jwengler@gmail.com  #
#               Last Modified: June 21, 2022        #
#                                                   #
#####################################################
# This file is for replication efforts of the GeneWiz differential expression analysis

#
library(DESeq2)
library(tidyverse)
#library(edgeR)
#library(scales)
#library(goseq)
#library(stringr)
#library(scater)
#library(scaterlegacy)


rescale_range <- function(vec){
    new_vec <- rescale(vec, to = c(0,1000))
    return(new_vec)
}

onlyE0771Count <- function(countTable){
    mod_count <- dplyr::select(countTable, "X1E", "X2E", "X3E", "X4E", "X5E","X6E", "X1G", "X2G", "X3G", "X4G", "X5G", "X6G")
    return(mod_count)
}

onlyE0771Meta <- function(metaTable){
    mod_meta <- dplyr:: filter(metaTable, mouse == "E0771" & treatment == "Control")
    return(mod_meta)
}

only4T1Count <- function(countTable){
    mod_count <- select(countTable, "X1A", "X2A", "X3A", "X4A", "X5A", "X6A", "X1C", "X2C", "X3C", "X4C", "X5C", "X6C")
    return(mod_count)
}

only4T1Meta <- function(metaTable){
    mod_meta <- filter(metaTable, mouse == "4T1" & treatment == "Control")
    return(mod_meta)
}

cleanGeneNames <- function(gene){
    gene_split <- str_split(gene, pattern = fixed("."))
    gene_name <- gene_split[[1]][1]
    return(gene_name)
}

getGeneLengths <- function(countData){
    # Add means to an empty list. Return that list. I also need to drop any rows that do not appear in the length thingie
    inOrder <- c()
    genes <- rownames(countData)
    in_file <- read.delim("/Users/jameswengler/GTFtools_0.8.5/gene_lengths.out")
    secondGenes <- in_file$gene
    #genes <- lapply(genes, cleanGeneNames)
    #secondGenes <- lapply(secondGenes, cleanGeneNames)
    #print(secondGenes)
    for (g in secondGenes){
        row <- tidyverse::filter(in_file, gene == g)
        inOrder <- c(inOrder, row$mean)
    }
    
    return(inOrder)
}

cleanDataFrame <- function(geneList, data){
    # MissingGene <- 
    # Filter rows based on -missingGenes
    genesInData <- rownames(data)
    missingGenes <- genesInData[!genesInData %in% geneList]
    #data <- mutate(data, geneNames = rownames(data))
    #print(data)
    #print(missingGenes)
    cleanData <- data[ !( rownames(data) %in% missingGenes), ] 
    #print(cleanData)
    return(cleanData)
}
################################ Code to get the same top 7 genes #################################
# onlyE0771Meta <- function(metaTable){
#     mod_meta <- filter(metaTable, mouse == "E0771" & treatment == "Control")
#     return(mod_meta)
# }
# 
# countData1 <- read.csv("/Volumes/TheBrick/Data/ChangLab/MouseData/ObesityStudyRNASeq/DEG/deseq2/E0771NDControl-vs-E0771HFDControl/counts/raw_counts.csv", row.names = 1)
# # This path should point to the metadata table
# metaData <- read.csv("/Users/jameswengler/meta_count_table.csv")
# metaData <- onlyE0771Meta(metaData)
# 
# countData <- mutate_if(countData, is.numeric, round)
# 
# dds <- DESeqDataSetFromMatrix(countData = countData, colData = metaData, design = ~diet)
# 
# dds <- DESeq(dds, test = "Wald")
# res <- results(dds)
# summary(res)
# sigRes <- subset(res, padj < .05)
# sigRes <- subset(sigRes, abs(log2FoldChange) > 1)
# print(head(sigRes, n = 10))
# quit(1)
################################# Code to get the same top 7 genes ################################# 
################################# Code to test normalized data  ################################# 

# This path should point at the count table
#countData <- read.csv("/Users/jameswengler/final_count_table.csv", row.names = 1)
# This path should point at the count table
countData <- read.csv("/Users/jameswengler/S0_final.csv", row.names = 1)
countData <- only4T1Count(countData)


# This path should point to the metadata table
metaData <- read.csv("/Users/jameswengler/meta.csv")
metaData <- only4T1Meta(metaData)

print(rownames(metaData))
countData <- countData[metaData$id]

#countData.fpm <- log2( ( countData / (colSums(countData) / 1e6)) + 1)
#countData <- mutate_if(countData.fpm, is.numeric, round)

#in_file <- read.delim("/Users/jameswengler/GTFtools_0.8.5/gene_lengths.out")
#secondGenes <- in_file$gene
#cleanCount <-cleanDataFrame(secondGenes, countData)
#fragmentLength <- getGeneLengths(cleanCount)
#countData <- vst(countData, blind = TRUE)





dds <- DESeqDataSetFromMatrix(countData = countData, colData = metaData, design = ~diet)
dds <- dds[rowSums(counts(dds)) >= 5,]
# dds <- estimateSizeFactors(dds)
# normalizedCounts <- counts(dds, normalized = TRUE)
# # countData <- as.data.frame(normalizedCounts)
# countData <- mutate_if(countData, is.numeric, round)
#countData <- countData[(rowSums(countData[])) > 10, ]
# 
# dds <- DESeqDataSetFromMatrix(countData = countData, colData = metaData, design = ~diet)

# Analysis below! This can be a traditional DESeq analysis, a PCA graph, whatever you decide
# This is a great resource for looking at the various things DESeq2 can do: https://lashlock.github.io/compbio/R_presentation.html
dds <- DESeq(dds, test = 'Wald')
res <- results(dds)
print(summary(res))
sigRes <- subset(res, padj < .05)
sigRes <- subset(sigRes, abs(log2FoldChange) > 1)
print(head(sigRes, n = 10))

# plotCounts(ds)

#vsdata <- vst(dds, blind = FALSE)
#plotPCA(vsdata, intgroup = "diet")

