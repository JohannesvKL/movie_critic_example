nextflow.enable.dsl=2

// Define default parameter
params.input = "input.txt"
params.outdir = "results/good"  // default output directory


process good_shuffle {
    publishDir params.outdir, mode: 'copy'

    input:
    path input_file

    output:
    path "good_shuffled.txt"

    script:
    """
    # Deterministic shuffling with fixed seed — good!
    shuf --random-source=<(yes 42) ${input_file} > good_shuffled.txt
    """
}

workflow {
    // Use the parameter for input file
    input_ch = Channel.fromPath(params.input)

    good = good_shuffle(input_ch)

    //compare_outputs(bad.out, good.out)
}