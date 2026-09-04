process MUSCLE {
    tag "${meta.id}"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("${fasta.baseName}_muscle.fasta"), emit: alignment

    script:
    """
    muscle -align ${fasta} -output ${fasta.baseName}_muscle.fasta
    """
}
