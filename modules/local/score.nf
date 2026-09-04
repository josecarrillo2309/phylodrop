process SCORE {
    tag "${meta.id}"

    input:
    tuple val(meta), path(alignment)

    output:
    tuple val(meta), path(alignment), path("score.txt"), emit: scored_alignment

    script:
    """
    tr -d '\\n>' < ${alignment} | tr -d '-' | wc -c > score.txt
    """
}
