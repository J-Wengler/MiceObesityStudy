import numpy as np

def charToInt(charList):
    toReturn = []
    for charInt in charList:
        toReturn.append(int(charInt))
    return toReturn

with open("/Volumes/TheBrick/Data/ChangLab/MouseData/ObesityStudyRNASeq/hit-counts/raw_counts.csv", "r") as in_file:
    gene_to_counts = {}
    header = in_file.readline()
    for line in in_file:
        comma_split = line.split(",")
        gene = comma_split[49].strip()
        counts = charToInt(comma_split[1:49])
        if gene == "NA": continue
        if gene not in gene_to_counts.keys():
            gene_to_counts[gene] = counts
        else:
            first_counts = np.array(gene_to_counts[gene])
            new_counts = np.array(counts)
            final_counts = first_counts + new_counts
            gene_to_counts[gene] = final_counts

    with open("/Users/jameswengler/named_counts.csv", "w+") as out_file:
        out_file.write(header)
        for key in gene_to_counts.keys():
            str_to_write = f"{key},"
            counts = gene_to_counts[key]
            for count in counts:
                str_to_write += f"{count},"
            str_to_write = str_to_write.rstrip()
            str_to_write += "\n"
            out_file.write(str_to_write)


