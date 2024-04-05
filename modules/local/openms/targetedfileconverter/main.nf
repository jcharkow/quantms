process TARGETEDFILECONVERTER {
    label 'process_low'
    label 'openms'

    conda "bioconda::openms-thirdparty=3.1.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/openms-thirdparty:3.1.0--h9ee0642_1' :
        'biocontainers/openms-thirdparty:3.1.0--h9ee0642_1' }"


    input:

    file(empirical_library_in)

    output:
    path("${empirical_library_in.baseName}.pqp"), emit: empirical_library_out
    path "versions.yml", emit: version

    script:
   
    """
    TargetedFileConverter \
        -in ${empirical_library_in} \
        -out ${empirical_library_in.baseName}.pqp \
        -out_type 'pqp' 2>&1 | tee ${empirical_library_in.baseName}_targetedFileConverter.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        TargetedFileConverter: \$(TargetedFileConverter 2>&1 | grep -E '^Version(.*)' | sed 's/Version: //g' | cut -d ' ' -f 1)
    END_VERSIONS
    """
}
