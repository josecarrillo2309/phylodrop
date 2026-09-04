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
    path "itol_*.txt", emit: itol_files

    script:
    """
    echo "Dummy PDF" > annotated_${tree.baseName}.pdf
    echo "Dummy NWK" > annotated_${tree.baseName}.nwk

    python3 -c "
import csv
import hashlib

def get_color(text):
    # Genera un color hexadecimal determinístico basado en el texto
    hash_obj = hashlib.md5(text.encode('utf-8'))
    return '#' + hash_obj.hexdigest()[:6]

id_dict = {}
with open('${id_map}', 'r') as f_map:
    header = f_map.readline()
    for line in f_map:
        parts = line.strip().split('\\t')
        if len(parts) == 2:
            id_dict[parts[0]] = parts[1]

f_popup = open('itol_popup_info.txt', 'w')
f_popup.write('POPUP_INFO\\nSEPARATOR TAB\\nDATA\\n')

f_bar = open('itol_simplebar_length.txt', 'w')
f_bar.write('DATASET_SIMPLEBAR\\nSEPARATOR TAB\\nDATASET_LABEL\\tSequence Length (bp)\\nCOLOR\\t#3498db\\nWIDTH\\t1000\\nSHOW_VALUE\\t1\\nDATA\\n')

f_strip_mol = open('itol_colorstrip_molecule.txt', 'w')
f_strip_mol.write('DATASET_COLORSTRIP\\nSEPARATOR TAB\\nDATASET_LABEL\\tMolecule Type\\nCOLOR\\t#e74c3c\\nSTRIP_WIDTH\\t25\\nSHOW_LABELS\\t1\\nDATA\\n')

f_strip_comp = open('itol_colorstrip_completeness.txt', 'w')
f_strip_comp.write('DATASET_COLORSTRIP\\nSEPARATOR TAB\\nDATASET_LABEL\\tCompleteness\\nCOLOR\\t#2ecc71\\nSTRIP_WIDTH\\t25\\nSHOW_LABELS\\t1\\nDATA\\n')

f_text_origin = open('itol_text_origin.txt', 'w')
f_text_origin.write('DATASET_TEXT\\nSEPARATOR TAB\\nDATASET_LABEL\\tOrigin\\nCOLOR\\t#9b59b6\\nDATA\\n')

f_text_date = open('itol_text_date.txt', 'w')
f_text_date.write('DATASET_TEXT\\nSEPARATOR TAB\\nDATASET_LABEL\\tCollection Date\\nCOLOR\\t#f1c40f\\nDATA\\n')

f_tree_colors = open('itol_tree_colors.txt', 'w')
f_tree_colors.write('TREE_COLORS\\nSEPARATOR TAB\\nDATA\\n')

with open('${metadata}', 'r') as f_meta:
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
            
            # 1. POPUP_INFO (English)
            title = f'Metadata: {short_id}'
            html = f'<ul><li><b>Species:</b> {species}</li><li><b>Origin:</b> {origin}</li><li><b>Collection Date:</b> {date}</li><li><b>Length:</b> {length} bp</li><li><b>Molecule:</b> {mol}</li><li><b>Completeness:</b> {comp}</li></ul>'
            f_popup.write(f'{short_id}\\t{title}\\t{html}\\n')
            
            # 2. SIMPLEBAR (Length)
            if length != 'unknown' and length.isdigit():
                f_bar.write(f'{short_id}\\t{length}\\t{length} bp\\n')
                
            # 3. COLORSTRIP (Molecule Type)
            mol_color = get_color(mol)
            f_strip_mol.write(f'{short_id}\\t{mol_color}\\t{mol}\\n')
            
            # 4. COLORSTRIP (Completeness)
            comp_color = get_color(comp)
            f_strip_comp.write(f'{short_id}\\t{comp_color}\\t{comp}\\n')
            
            # 5. TEXT (Origin)
            f_text_origin.write(f'{short_id}\\t{origin}\\t-1\\t#000000\\tnormal\\t1\\t0\\n')
            
            # 6. TEXT (Date)
            f_text_date.write(f'{short_id}\\t{date}\\t-1\\t#000000\\tnormal\\t1\\t0\\n')
            
            # 7. TREE_COLORS (Color label backgrounds based on molecule type)
            f_tree_colors.write(f'{short_id}\\tlabel_background\\t{mol_color}\\n')

for f in [f_popup, f_bar, f_strip_mol, f_strip_comp, f_text_origin, f_text_date, f_tree_colors]:
    f.close()
"
    """
}
