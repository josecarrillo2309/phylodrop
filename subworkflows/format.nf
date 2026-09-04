include { RENAME } from '../modules/local/rename'

workflow FORMAT {
    take:
    ch_fasta
    ch_metadata

    main:
    RENAME(ch_fasta, ch_metadata)

    emit:
    clean_fasta = RENAME.out.clean_fasta
    id_map = RENAME.out.id_map
}
