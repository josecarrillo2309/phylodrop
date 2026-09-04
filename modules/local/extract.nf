process EXTRACT {
    publishDir "${params.outdir}/00_metadata", mode: 'copy'

    input:
    path gb_file

    output:
    path "metadata.tsv", emit: metadata

    script:
    """
    #!/usr/bin/env python3
    import sys

    with open("${gb_file}", "r") as fin, open("metadata.tsv", "w") as fout:
        fout.write("sample_id\\tspecies\\torigin\\tdate\\n")
        
        current_id = "unknown"
        current_species = "unknown"
        current_origin = "unknown"
        current_date = "unknown"
        
        for line in fin:
            if line.startswith("LOCUS"):
                parts = line.split()
                if len(parts) >= 8:
                    current_date = parts[-1]
            elif line.startswith("VERSION"):
                current_id = line.split()[1]
            elif line.startswith("  ORGANISM"):
                current_species = line.replace("ORGANISM", "").strip()
            elif line.startswith("SOURCE"):
                current_origin = line.replace("SOURCE", "").strip()
            elif line.startswith("//"):
                fout.write(f"{current_id}\\t{current_species}\\t{current_origin}\\t{current_date}\\n")
                current_id = "unknown"
                current_species = "unknown"
                current_origin = "unknown"
                current_date = "unknown"
    """
}
