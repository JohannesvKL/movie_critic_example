## Random Shuffle Pipeline

This pipeline outputs a randomly shuffled list of entries from a `.txt` file.  

**Parameters:**
- `--input`: Path to the input text file.  
- `--N`: Number of lines to read from the file.  

**Usage:**
```bash
nextflow run main.nf --input input.txt --N 5
