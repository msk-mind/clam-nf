params.outdir = "results"

process SEG_AND_PATCH {
    label "bigTask"
    label "clamTask"

    input:
    tuple val(slide_id), path(slide)

    output:
    tuple val(slide_id), path(slide), path("${slide_id}.h5")

    """
    ${params.clam_path}/run_seg_and_patch.py \
        slide_path=${slide} \
        output_prefix=${slide_id}
    """
}

process EXTRACT_FEATURES {
    publishDir params.outdir

    label "bigTask"
    label "clamTask"
    label "gpuTask"
    label "parallelTask"

    input:
    tuple val(slide_id), path(slide), path(h5, stageAs: 'input.h5')

    output:
    tuple val(slide_id), path("${slide_id}.h5"), path("${slide_id}.pt")

    """
    ${params.clam_path}/run_extract_features.py \
        num_workers=${task.cpus} \
        model_name=ctranspath \
        use_gpu=true \
        slide_path=${slide} \
        h5_path=${h5} \
        output_prefix=${slide_id}
    """
}


workflow CLAM {
    take:
        slides_ch

    main:
        slides_ch | SEG_AND_PATCH | EXTRACT_FEATURES

    emit:
        EXTRACT_FEATURES.out
}
