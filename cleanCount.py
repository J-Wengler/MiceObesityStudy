# File to clean up the count table
import pandas as pd

data = pd.read_csv("/Users/jameswengler/CountTable.csv")
new_col_dict = {}
sample_names = []

for col in data.columns:
    if col.startswith("/"):
        name_list = col.split("/")
        bam_name = name_list[9]
        sample_name = bam_name.split(".")[0]
        sample_names.append(sample_name)
        new_col_dict[col] = sample_name

data.rename(columns = new_col_dict, inplace = True)
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
    
