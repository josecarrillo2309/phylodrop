#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Import subworkflows and modules
include { EXTRACT } from './modules/local/extract'
include { FORMAT  } from './subworkflows/format'
include { ALIGN   } from './subworkflows/align'
include { EVALUATE} from './subworkflows/evaluate'
include { INFER   } from './subworkflows/infer'
include { ANNOTATE} from './subworkflows/annotate'

workflow {
    ch_fasta = Channel.fromPath(params.input_fasta, checkIfExists: true)
    ch_gb    = Channel.fromPath(params.input_gb, checkIfExists: true)

    // 0. Extraer
    EXTRACT(ch_gb)

    // 1. Formatear
    FORMAT(ch_fasta, EXTRACT.out.metadata)

    // 2. Alinear
    ALIGN(FORMAT.out.clean_fasta)

    // 3. Evaluar
    EVALUATE(ALIGN.out.alignments)
    ch_top10 = EVALUATE.out.top10

    // 4. Inferir
    INFER(ch_top10, params.inference_method)

    // 5. Anotar
    ANNOTATE(
        INFER.out.trees,
        FORMAT.out.id_map,
        EXTRACT.out.metadata
    )
}
