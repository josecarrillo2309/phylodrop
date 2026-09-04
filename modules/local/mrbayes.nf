process MRBAYES {
    tag "${meta.id}"
    publishDir "${params.outdir}/04_trees", mode: 'copy'

    input:
    tuple val(meta), path(alignment)

    output:
    tuple val(meta), path("*.con.tre"), emit: tree

    script:
    """
    # En un caso real se requeriría convertir a formato Nexus con bloque mrbayes
    # Para fines de estructura, se crea un árbol ficticio o se corre mrbayes con script
    echo "(A,B,(C,D));" > ${alignment.baseName}.con.tre
    """
}
