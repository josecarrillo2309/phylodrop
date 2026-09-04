process IQTREE2 {
    tag "${meta.id}"
    publishDir "${params.outdir}/04_trees", mode: 'copy'

    input:
    tuple val(meta), path(alignment)

    output:
    tuple val(meta), path("*.treefile"), emit: tree

    script:
    """
    iqtree -s ${alignment} -m MFP -bb 1000 -nt AUTO
    """
}
