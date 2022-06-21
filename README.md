# Differential Expression Data Analysis for the Mice Obesity Study
James Wengler | jwengler@gmail.com |
Last Updated: June 21, 2022
### Analysis Overview
This code is designed to analyze the RNASeq data from the Mice Obesity Study. The data for this project was provided by Dr. Chang's lab. The goal of these scripts is to use the DESeq2 package to perform a differential expression analysis on the RNASeq Data. For an overview of DESeq2 and what it can do please refer to: https://lashlock.github.io/compbio/R_presentation.html

### Package Dependencies and Versions
Packages used in analysis (June 21, 2022)
- Pandas (Python) : 1.0.4
- DESeq2 (R) : 1.28.1
- Tidyverse (R) : 1.3.1
- Subread (Conda) : 2.0.3

### Analysis Steps
1. Obtain the aligned bamfiles and reference genome
2. Install the necessary packages
3. Run featureCount from the subread package to generate a count table
4. Run cleanCount.py to clean the count table and generate a metadata table
5. Manually clean the count table
6. Run ObeseMiceDeSEQ2.R to perform the DESeq2 analysis

#### 1. Obtain the aligned bamfiles andn reference genome
The raw data for this experiment are the aligned bamfiles from the Mice Obesity study. The other required file is a reference genome in the .gtf format. This can be obtained here: https://www.gencodegenes.org/mouse/. The file I used was the "Comprehensive gene annotation" covering the CHR regions. 

#### 2. Install the necessary packages
##### subread
The easiest way to install subread is through the Conda installer. Details on Conda are here: https://docs.conda.io/en/latest/. Once Conda is installed, the installSubreadConda.sh script can be ran with the following command:
```
bash installSubreadConda.sh
```
##### DESeq2
R Code:
```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DESeq2")
```
##### tidyverse
R Code: 
```
install.packages("tidyverse")
```

##### pandas
The easiest way is to use the Conda installer.
```
conda install pandas
```

#### 3. Run featureCount
The following command is the exact command I used:
```
featureCounts -a /Path/To/gencode.vM29.annotation.gtf -T 4 -o /Path/To/CountTable.tsv /Path/To/rawBams/*
```
```featureCounts``` -> Calls the package
```-a /Path/To/gencode.vM29.annotation.gtf``` -> Where the package should look for the .gtf file
```-T 4``` -> Uses 4 cores for multithreading. This is optional but will speed up the code if you have multiple cores available
```-o /Path/To/CountTable.tsv``` -> Where you want the count table to be saved
```/Path/To/rawBams/*``` -> Where the raw bamfiles are located. This should be a directory containing ONLY the bamfiles

On a 2017 Macbook Air with 4 cores this step took approximately 1.5 hours to run. 

#### 4. Run cleanCount.py
This can be done in an IDE of your choice or via commandline with the following command:
```python3 cleanCount.py```
You will have to edit the file to change the paths that the code uses. There are extensive comments in the code that walk you through how to do this. 

#### 5. Clean the count table manually
By default, featureCounts puts a lot of information into the count table that is unnecessary and will break the downstream DESeq2 analysis. Below is a screenshot of the EXACT layout that your file should be in. The easiest way to edit the file is to open it in excel and delete the unnecessary columns (DO NOT convert the file to .xslx, keep it as a .csv)

#### 6. Run ObeseMiceDeSEQ2.R
This step is best done in Rstudio to enable easy viewing of the graphs, results, etc. Once ObeseMiceDeSEQ2.R is opened in RStudio, read the comments to change the script to perform whatever analysis you want

### Contact
Please contact James Wengler with any questions.
jwengler@gmail.com
jwengler@tamu.edu
