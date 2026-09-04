include { MAFFT } from '../modules/local/mafft'
include { MUSCLE } from '../modules/local/muscle'
include { TRIMAL } from '../modules/local/trimal'

workflow ALIGN {
    take:
    clean_fasta

    main:
    ch_mafft_params = Channel.of(
        [id: 'mafft_auto', args: '--auto'],
        [id: 'mafft_linsi', args: '--localpair --maxiterate 1000']
    )
    ch_mafft_in = ch_mafft_params.combine(clean_fasta)
    MAFFT(ch_mafft_in)

    ch_muscle_params = Channel.of(
        [id: 'muscle_default', args: '']
    )
    ch_muscle_in = ch_muscle_params.combine(clean_fasta)
    MUSCLE(ch_muscle_in)

    ch_all_alignments = MAFFT.out.alignment.mix(MUSCLE.out.alignment)

    ch_trimal_params = Channel.of(
        [trim_id: 'gappyout', trim_args: '-gappyout'],
        [trim_id: 'strict', trim_args: '-strict']
    )

    ch_trim_in = ch_all_alignments.combine(ch_trimal_params)
        .map { meta, aln, trim_meta -> 
            def new_meta = meta.clone()
            new_meta.trim_id = trim_meta.trim_id
            new_meta.trim_args = trim_meta.trim_args
            new_meta.id = "${meta.id}_${trim_meta.trim_id}"
            [new_meta, aln] 
        }

    TRIMAL(ch_trim_in)

    emit:
    alignments = TRIMAL.out.trimmed
}
