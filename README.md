# CLAM-NF pipeline

A pipeline for generating pathology slide embeddings using CLAM.

## Requirements

* Unix-like operating system
* Java 11

## Quickstart

1. Install docker

2. Install nextflow:
```
curl -s https://get.nextflow.io | bash
```

3. Launch the pipeline execution using docker
```
./nextflow run msk-mind/clam-nf -profile standard,docker --samples_csv samples.csv
```
`samples.csv` is a csv file where the first column is the slide ID and the second is the path to the slide.

4. When the execution completes, results will be in the `results` directory


