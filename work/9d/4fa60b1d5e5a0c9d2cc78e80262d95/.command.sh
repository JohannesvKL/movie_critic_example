#!/bin/bash -ue
# Deterministic shuffling with fixed seed — good!
shuf --random-source=<(yes 42) input.txt > good_shuffled.txt
