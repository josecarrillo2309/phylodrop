process RENAME {
    tag "$fasta"
    publishDir "${params.outdir}/01_format", mode: 'copy'

    input:
    path fasta
    path metadata

    output:
    path "clean_${fasta.baseName}.fasta", emit: clean_fasta
    path "id_map.tsv", emit: id_map

    script:
    """
    #!/usr/bin/env python3
    import sys
    import csv
    import re

    fasta_in = "${fasta}"
    metadata_in = "${metadata}"
    fasta_out = "clean_${fasta.baseName}.fasta"
    
    meta_dict = {}
    with open(metadata_in, "r") as fmeta:
        reader = csv.DictReader(fmeta, delimiter='\\t')
        for row in reader:
            meta_dict[row['sample_id']] = row.get('species', 'sp')

    with open(fasta_in, "r") as fin, open(fasta_out, "w") as fout, open("id_map.tsv", "w") as fmap:
        fmap.write("original_id\\tshort_id\\n")
        
        for line in fin:
            if line.startswith(">"):
                old_id = line[1:].strip().split()[0]
                species = meta_dict.get(old_id, 'unknown_sp')
                accession = old_id.split('.')[0]
                species_clean = re.sub(r'[^A-Za-z0-9]', '_', species)
                new_id = f"{accession}_{species_clean}"
                
                fmap.write(f"{old_id}\\t{new_id}\\n")
                fout.write(f">{new_id}\\n")
            else:
                fout.write(line)
    """
}
