import numpy as np
import pandas as pd    

data = pd.read_csv(snakemake.input[0], comment='#')
with open(snakemake.output[0], 'w') as writer:
    singular = data.columns[0].strip().upper()
    plural = f"{singular}S"

    for i, header in enumerate(data.columns[1:]):
        constant_name = f"{singular}_{header.strip()}"
        writer.write(f"{constant_name} = {i+1};\n")

    writer.write("\n")
    writer.write(f"{plural} = \n")
    writer.write(np.array2string(data.values, separator=", ").replace("\'", "\""))
    writer.write(";\n\n")

    writer.write(f"function search_{plural.lower()}(key) = {plural}[search([key], {plural})[0]];\n"
)