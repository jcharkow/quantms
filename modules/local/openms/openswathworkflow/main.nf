process OPENSWATHWORKFLOW {
    label 'process_high'
    label 'openms'

    conda "bioconda::openms-thirdparty=3.1.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/openms-thirdparty:3.1.0--h9ee0642_1' :
        'biocontainers/openms-thirdparty:3.1.0--h9ee0642_1' }"


    input:

    path(mzml_file)
    path(empirical_library)
    path(irt_linear)
    path(irt_nonlinear)
    val(meta)

    output:
    path path("${mzml_file.baseName}.osw"), emit: osw_out
    path "versions.yml", emit: version

    tuple val(meta), path(consus_file)

    script:
   
    OUTCHROM = params.outputChromatograms ? "-out_chrom ${mzml_file.baseName}.sqMass" : ""

    EXTRACTION_WINDOW="""
    -mz_extraction_window ${meta['fragmentmasstolerance']} \
    -mz_extraction_window_unit ${meta['fragmentmasstoleranceunit'].toLowerCase()} \
    -mz_extraction_window_ms1 ${meta['precursormasstolerance']} \ 
    -mz_extraction_window_ms1_unit ${meta['precursormasstoleranceunit'].toLowerCase()} \
    -im_extraction_window 0.05 \
    -rt_extraction_window 600  \
    -pasef
    """

    MZ_CALIBRATION="""
    -mz_correction_function quadratic_regression_delta_ppm \
    -irt_mz_extraction_window ${meta['fragmentmasstolerance'] * 2} \
    -irt_mz_extraction_window_unit ${meta['fragmentmasstoleranceunit'].toLowerCase()} 
    """

    RT_CALIBRATION="""
    -RTNormalization:alignmentMethod lowess \
    -RTNormalization:lowess:span 0.01 \
    -RTNormalization:NrRTBins 8 \
    -RTNormalization:MinBinsFilled 4 \
    -RTNormalization:estimateBestPeptides \
    -min_coverage 0.1
    """

    IM_CALIBRATION="""
    -irt_im_extraction_window 0.1"""

    SCORING="""
    -Scoring:TransitionGroupPicker:min_peak_width 5.0 \
    -Scoring:stop_report_after_feature 5 \
    -Scoring:Scores:use_ion_mobility_scores
    """

    PERFORMANCE="""
    -batchSize 250 \
    -readOptions cacheWorkingInMemory \
    -tempDirectory ./ \
    -threads $task.cpus \
    -outer_loop_threads 2
    """
 
    ADDITIONAL_PARAM=$openswath_additionalparam

    DEBUG="-debug 0"

    """
    OpenSwathWorkflow \
        -in ${mzml_file} \
        -tr ${empirical_library} \
        -tr_irt ${irt_linear} \
        -tr_irt_nonlinear ${irt_nonlinear} \
        -out_osw ${mzml_file.baseName}.osw \
        -enable_ipf false \
        $OUTCHROM \
        $EXTRACTION_WINDOW \
        $MZ_CALIBRATION \
        $RT_CALIBRATION \
        $IM_CALIBRATION \
        $SCORING \
        $PERFORMANCE \
        $ADDITIONAL_PARAM \
        -debug 0 2&1 | tee ${mzml_file.baseName}_openswath.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        OpenSwathWorkflow: \$(OpenSwathWorkflow 2>&1 | grep -E '^Version(.*)' | sed 's/Version: //g' | cut -d ' ' -f 1)
    END_VERSIONS
    """
}
