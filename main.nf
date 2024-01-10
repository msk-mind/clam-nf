#!/usr/bin/env nextflow

params.outdir = "results"
params.check_slides_exist = false
params.samples_csv = null

include { GET_SLIDES } from './modules/extract'
include { CLAM } from './modules/clam'

workflow {
    ch_slides = Channel.empty()

    if (params.samples_csv) {
        ch_slides = Channel.fromPath(params.samples_csv).splitCsv()
    } else {
        ch_slides = GET_SLIDES \
            | splitCsv(header: true) \
            | map { [it.slide_id, file(it.path, checkIfExists: params.check_slides_exist)] }
    }

    if (params.test) {
        ch_slides = ch_slides.take(5)
    }

    CLAM(ch_slides)
}

