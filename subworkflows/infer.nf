include { IQTREE2 } from '../modules/local/iqtree2'
include { MRBAYES } from '../modules/local/mrbayes'

workflow INFER {
    take:
    ch_top10
    inference_method

    main:
    if (inference_method == 'bayesian') {
        MRBAYES(ch_top10)
        trees = MRBAYES.out.tree
    } else {
        IQTREE2(ch_top10)
        trees = IQTREE2.out.tree
    }

    emit:
    trees
}
