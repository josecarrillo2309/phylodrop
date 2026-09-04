process TRIMAL {
    tag "${meta.id}"

    input:
    tuple val(meta), path(alignment)

    output:
    tuple val(meta), path("${alignment.baseName}_trimal.fasta"), emit: trimmed

    script:
    """
    trimal -in ${alignment} -out ${alignment.baseName}_trimal.fasta ${meta.trim_args}
    """
}
