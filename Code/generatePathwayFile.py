# File to generate a clean list of genes from the MouseModelsCompared.csv for use in the online Reactome tool
with open("/Users/jameswengler/MiceObesityStudy/Data/DietCompared.csv", "r") as input_file:
    for line in input_file:
        print(line)
        line_split = line.split(",")
        full_name = line_split[0]
        full_name = full_name[1:]
        full_name = full_name[:-1]
        fn_period_split = full_name.split(".")
        cleaned_name = fn_period_split[0]
        with open("/Users/jameswengler/MiceObesityStudy/Data/genelistDIET.txt", 'a+') as out_file:
            outStr = f"{cleaned_name}\n"
            out_file.write(outStr)
