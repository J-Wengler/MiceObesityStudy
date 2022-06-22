#####################################################
#                                                   #
#               cleanCount.py                       #
#               James Wengler - jwengler@gmail.com  #
#               Last Modified: June 21, 2022        #
#                                                   #
#####################################################
# This file generates a count table and meta table from the mice obesity RNASeq data
# REQUIRED: Count table created by the featureCounts package 
# OUTPUT: refactored count table, meta table

# The pandas package is used to clean/manipulate dataframes in Python
import pandas as pd

# This path needs to point at the count table that was generated by the featureCounts package
data = pd.read_csv("/Users/jameswengler/CountTable.csv")
new_col_dict = {}
sample_names = []

# Creates a dictionary to rename the columns in the dataframe with the appropiate names. The below code is highly dependent on the location of your count table
for col in data.columns:
    if col.startswith("/"):
        # Only gets full paths
        name_list = col.split("/")
        # This number will change based on where the actual sample name is found in your path
        bam_name = name_list[9]
        # Again, change this to match your path
        sample_name = bam_name.split(".")[0]
        # Add the sample name to a master list to be used later in the meta table generation
        sample_names.append(sample_name)
        # col needs to be the original column name in the dataframe, sample_name needs to be whatever you want the new column name to be
        # For example, col = "/Volumes/TheBrick/Data/ChangLab/MouseData/ObesityStudyRNASeq/bam/rawBams/6A.bam" and sample_name = "6A"
        new_col_dict[col] = sample_name

# IF THIS LINE THROWS AN ERROR THEN THE ABOVE FOR LOOP IS DOING SOMETHING WRONG
data.rename(columns = new_col_dict, inplace = True)
# Change the path wherever you want the count table to be stored
data.to_csv("/Users/jameswengler/final_count_table.csv")

# 4T1 Mouse Models
# 4T1, normal diet, control
T1_N_C = ["1A", "2A", "3A", "4A", "5A", "6A"]
# 4T1, normal diet, treated
T1_N_T = ["1B", "2B", "3B", "4B", "5B", "6B"]
# 4T1, high fat diet, control
T1_F_C = ["1C", "2C", "3C", "4C", "5C", "6C"]
# 4T1, high fat diet, treated
T1_F_T = ["1D", "2D", "3D", "4D", "5D", "6D"]

# E0771 Mouse Models
# E0771, normal diet, control 
E0_N_C = ["1E", "2E", "3E", "4E", "5E", "6E"]
# E0771, normal diet, treated
E0_N_T = ["1F", "2F", "3F", "4F", "5F", "6F"]
# E0771, high fat diet, control 
E0_F_C = ["1G", "2G", "3G", "4G", "5G", "6G"]
# E0771, high fat diet, treated
E0_F_T = ["1H", "2H", "3H", "4H", "5H", "6H"]

# This for loop uses the sample name list you generated in the first for loop
# This creates the meta table that stores the needed meta information about each sample
with open("/Users/jameswengler/meta_count_table.csv", "w+") as meta_file:
    first_line = f"id,mouse,diet,treatment\n"
    meta_file.write(first_line)
    for samp in sample_names:
        if samp in T1_N_C:
            name_str = f"{samp},4T1,NormalDiet,Control\n"
            meta_file.write(name_str)
        if samp in T1_N_T:
            name_str = f"{samp},4T1,NormalDiet,Treatment\n"
            meta_file.write(name_str)
        if samp in T1_F_C:
            name_str = f"{samp},4T1,HighFatDiet,Control\n"
            meta_file.write(name_str)
        if samp in T1_F_T:
            name_str = f"{samp},4T1,HighFatDiet,Treatment\n"
            meta_file.write(name_str)
        if samp in E0_N_C:
            name_str = f"{samp},E0771,NormalDiet,Control\n"
            meta_file.write(name_str)
        if samp in E0_N_T:
            name_str = f"{samp},E0771,NormalDiet,Treatment\n"
            meta_file.write(name_str)
        if samp in E0_F_C:
            name_str = f"{samp},E0771,HighFatDiet,Control\n"
            meta_file.write(name_str)
        if samp in E0_F_T:
            name_str = f"{samp},E0771,HighFatDiet,Treatment\n"
            meta_file.write(name_str)
    
# Please direct all questions to jwengler@gmail.com 