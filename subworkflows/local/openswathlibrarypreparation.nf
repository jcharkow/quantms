//
// MODULE: Local to the pipeline
//
include { TARGETEDFILECONVERTER } from '../../modules/local/openms/targetedfileconverter/main'
include { OPENSWATHASSAYGENERATOR } from '../../modules/local/openms/openswathassaygenerator/main'
include { OPENSWATHDECOYGENERATOR } from '../../modules/local/openms/openswathdecoygenerator/main'

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//

workflow OPENSWATHLIBRARYPREPARATION {
    take:

    ch_emperical_library
    
    main:

    TARGETEDFILECONVERTER(ch_emperical_library)

    OPENSWATHASSAYGENERATOR(TARGETEDFILECONVERTER.out.empirical_library_out)

    OPENSWATHDECOYGENERATOR(OPENSWATHASSAYGENERATOR.out.empirical_library_out)

}
