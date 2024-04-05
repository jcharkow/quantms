/*
========================================================================================
    IMPORT LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/

//
// MODULES: Local to the pipeline
//
include { TARGETEDFILECONVERTER } from '../modules/local/openms/targetedfileconverter/main'

//
// SUBWORKFLOWS: Consisting of a mix of local and nf-core/modules
//
include { OPENSWATHLIBRARYPREPARATION } from '../subworkflows/local/openswathlibrarypreparation'

/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow OPENSWATH {
    take:
    ch_file_preparation_results
    ch_expdesign
    ch_ms_info

    main:


    Channel.fromPath(params.openswath_speclib).set { emperical_library_in}


    //
    // SUBWORKFLOW: OpenSwathLibraryPreparation
    //

    OPENSWATHLIBRARYPREPARATION(emperical_library_in)

}
/*
========================================================================================
    THE END
========================================================================================
*/
