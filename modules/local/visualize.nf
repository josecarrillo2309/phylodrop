process VISUALIZE {
    tag "${meta.id}"
    publishDir "${params.outdir}/05_annotated_trees", mode: 'copy'

    input:
    tuple val(meta), path(tree)
    path id_map
    path metadata

    output:
    path "annotated_${tree.baseName}.pdf", emit: pdf
    path "annotated_${tree.baseName}.nwk", emit: nwk
    path "itol_metadata.txt", emit: itol

    script:
    """
    echo "Dummy PDF" > annotated_${tree.baseName}.pdf
    echo "Dummy NWK" > annotated_${tree.baseName}.nwk

    python3 -c "
import csv

id_dict = {}
with open('${id_map}', 'r') as f_map:
    header = f_map.readline()
    for line in f_map:
        parts = line.strip().split('\\t')
        if len(parts) == 2:
            id_dict[parts[0]] = parts[1]

with open('${metadata}', 'r') as f_meta, open('itol_metadata.txt', 'w') as f_itol:
    f_itol.write('SEPARATOR TAB\\n')
    f_itol.write('FIELD_LABELS\\tspecies\\torigin\\tdate\\tlength_bp\\tmolecule_type\\tcompleteness\\n')
    f_itol.write('DATA\\n')
    
    reader = csv.DictReader(f_meta, delimiter='\\t')
    for row in reader:
        orig_id = row['sample_id']
        species = row.get('species', 'unknown')
        origin = row.get('origin', 'unknown')
        date = row.get('date', 'unknown')
        length = row.get('length_bp', 'unknown')
        mol = row.get('molecule_type', 'unknown')
        comp = row.get('completeness', 'unknown')
        
        if orig_id in id_dict:
            short_id = id_dict[orig_id]
            f_itol.write(f'{short_id}\\t{species}\\t{origin}\\t{date}\\t{length}\\t{mol}\\t{comp}\\n')
"
    """
}
