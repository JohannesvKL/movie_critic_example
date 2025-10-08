nextflow.enable.dsl=2

// Define default parameter
params.input = "input.txt"

process bad_shuffle {
    publishDir "results/bad2", mode: 'copy'

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

process good_shuffle {
    publishDir "results/good2", mode: 'copy'

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

process compare_outputs {
    publishDir "results/compare", mode: 'copy'

    input:
    path bad
    path good

    output:
    path "comparison.txt"

    script:
    """
    echo "Comparing bad and good shuffles..." > comparison.txt
    diff ${bad} ${good} >> comparison.txt || echo "They differ!" >> comparison.txt
    """
}

workflow {
    // Use the parameter for input file
    input_ch = Channel.fromPath(params.input)

    bad = bad_shuffle(input_ch)
    good = good_shuffle(input_ch)

    //compare_outputs(bad.out, good.out)
}
