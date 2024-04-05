//
// MODULE: Local to the pipeline
//
include {  OPENSWATHWORKFLOW } from '../../modules/local/openms/openswathworkflow/main'

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//

workflow OPENSWATHPYPROPHETWORKFLOW {
    take:
    
    ch_database_wdecoy

    main:

    ch_software_versions = Channel.empty()

    //
    // MODULE: OPENSWATHWORKFLOW
    //
    OPENSWATHWORKFLOW(ch_file_preparation_results, ch_database_wdecoy)
    ch_software_versions = ch_software_versions.mix(OPENSWATHWORKFLOW.out.version.ifEmpty(null))

}
