process MAFFT {
    tag "${meta.id}"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("${fasta.baseName}_mafft.fasta"), emit: alignment

    script:
    """
    mafft ${meta.args} ${fasta} > ${fasta.baseName}_mafft.fasta
    """
}
