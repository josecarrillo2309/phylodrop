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
        fout.write("sample_id\\tspecies\\torigin\\tdate\\tlength_bp\\tmolecule_type\\tcompleteness\\n")
        
        current_id = "unknown"
        current_species = "unknown"
        current_origin = "unknown"
        current_date = "unknown"
        current_length = "unknown"
        current_molecule = "unknown"
        current_completeness = "unknown"
        
        def_text = ""
        in_def = False

        for line in fin:
            if not line.startswith(" ") and in_def:
                in_def = False
                dl = def_text.lower()
                if "complete genome" in dl: current_completeness = "complete genome"
                elif "complete cds" in dl: current_completeness = "complete cds"
                elif "partial cds" in dl: current_completeness = "partial cds"
                elif "partial sequence" in dl: current_completeness = "partial sequence"
                elif "complete sequence" in dl: current_completeness = "complete sequence"
                else: current_completeness = "unspecified"

            if line.startswith("LOCUS"):
                parts = line.split()
                if len(parts) >= 3:
                    current_length = parts[2]
                
                # Buscar el tipo de molécula (después de 'bp', 'aa', o 'rc')
                for ext in ["bp", "aa", "rc"]:
                    if ext in parts:
                        idx = parts.index(ext)
                        if len(parts) > idx + 1:
                            current_molecule = parts[idx + 1]
                        break
                        
                if len(parts) >= 8:
                    current_date = parts[-1]
                    
            elif line.startswith("VERSION"):
                current_id = line.split()[1]
            elif line.startswith("DEFINITION"):
                in_def = True
                def_text = line.replace("DEFINITION", "").strip() + " "
            elif in_def:
                def_text += line.strip() + " "
            elif line.startswith("  ORGANISM"):
                current_species = line.replace("ORGANISM", "").strip()
            elif line.startswith("SOURCE"):
                current_origin = line.replace("SOURCE", "").strip()
            elif line.startswith("//"):
                fout.write(f"{current_id}\\t{current_species}\\t{current_origin}\\t{current_date}\\t{current_length}\\t{current_molecule}\\t{current_completeness}\\n")
                
                # Resetear variables
                current_id = "unknown"
                current_species = "unknown"
                current_origin = "unknown"
                current_date = "unknown"
                current_length = "unknown"
                current_molecule = "unknown"
                current_completeness = "unknown"
                def_text = ""
    """
}
