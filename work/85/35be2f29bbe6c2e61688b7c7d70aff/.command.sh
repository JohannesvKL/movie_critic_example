#!/bin/bash -ue
# Deterministic shuffling with fixed seed (42) — good!
gshuf --random-source=<(yes 42) input.txt > good_shuffled.txt
