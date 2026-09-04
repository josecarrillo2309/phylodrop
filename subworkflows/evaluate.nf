include { SCORE } from '../modules/local/score'

workflow EVALUATE {
    take:
    alignments

    main:
    SCORE(alignments)

    SCORE.out.scored_alignment
        .map { meta, aln, score_file -> 
            def score = score_file.text.trim().toInteger()
            [ score, meta, aln ] 
        }
        .toSortedList { a, b -> b[0] <=> a[0] }
        .flatMap { list -> list.take(10) }
        .map { score, meta, aln -> 
            [meta, aln] 
        }
        .set { ch_top10 }

    emit:
    top10 = ch_top10
}
