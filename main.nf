nextflow.enable.dsl=2

// Define default parameter
params.input = "input.txt"
params.outdir = "results/bad"  // default output directory

process bad_shuffle {
    publishDir params.outdir, mode: 'copy'

    input:
    path input_file

    output:
    path "bad_shuffled.txt"

    script:
    """
    # Non-deterministic shuffling — bad!
    shuf ${input_file} > bad_shuffled.txt
    """
}

workflow {
    // Use the parameter for input file
    input_ch = Channel.fromPath(params.input)

    bad = bad_shuffle(input_ch)

    //compare_outputs(bad.out, good.out)
}
