include { VISUALIZE } from '../modules/local/visualize'

workflow ANNOTATE {
    take:
    trees
    id_map
    ch_metadata

    main:
    VISUALIZE(trees, id_map.first(), ch_metadata.first())

    emit:
    annotated_trees = VISUALIZE.out.pdf
    itol_files = VISUALIZE.out.itol_files
}
