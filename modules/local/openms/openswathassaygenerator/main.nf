process OPENSWATHASSAYGENERATOR {
    label 'process_low'
    label 'openms'

    conda "bioconda::openms-thirdparty=3.1.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/openms-thirdparty:3.1.0--h9ee0642_1' :
        'biocontainers/openms-thirdparty:3.1.0--h9ee0642_1' }"


    input:

    path(empirical_library_in)

    output:
    path("${empirical_library_in.baseName}_prepared.${empirical_library_in.extension}"), emit: empirical_library_out
    path "versions.yml", emit: version

    script:
   
    """
    OpenSwathAssayGenerator \
        -in ${empirical_library_in} \
        -out ${empirical_library_in.baseName}_prepared.${empirical_library_in.extension} 2>&1 | tee ${empirical_library_in.baseName}_openswath.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        OpenSwathWorkflow: \$(OpenSwathWorkflow 2>&1 | grep -E '^Version(.*)' | sed 's/Version: //g' | cut -d ' ' -f 1)
    END_VERSIONS
    """
}
