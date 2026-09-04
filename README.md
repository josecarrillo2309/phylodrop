# 🧬 Phylodrop

Phylodrop is a fully automated, scalable Nextflow pipeline designed for processing raw genetic sequences and generating highly curated, publication-ready annotated phylogenetic trees.

## 🚀 Features

- **Automated Metadata Extraction:** Mines `.gb` (GenBank) files directly to extract taxonomic and biological metadata.
- **Smart ID Formatting:** Standardizes and renames complex FASTA headers into safe, phylogenetic-software-compatible formats (`Accession_Species`).
- **Combinatorial Alignment & Curation:** Processes sequences simultaneously through MAFFT and MUSCLE, followed by dynamic gap trimming with TrimAl.
- **Automated Evaluation:** Scores all generated alignments and automatically routes the "Top 10" best quality matrices.
- **Conditional Phylogenetic Inference:** Seamlessly runs Maximum Likelihood (IQ-TREE2) or Bayesian Inference (MrBayes).
- **Ready-to-Use Annotations:** Generates Newick/Treefiles alongside fully integrated metadata formatting for [iTOL (Interactive Tree of Life)](https://itol.embl.de/).

## 💻 Installation

You don't need to install any heavy bioinformatics software. Phylodrop uses **Docker** and **Singularity** to handle dependencies via Biocontainers automatically. 

Ensure you have installed:
- [Nextflow](https://www.nextflow.io/) (>= 22.04.0)
- [Docker](https://docs.docker.com/engine/install/) or [Singularity](https://sylabs.io/guides/3.0/user-guide/installation.html)

## 🏃 Usage

Run the pipeline by pointing it to your raw FASTA and GenBank metadata files.

```bash
nextflow run josecarrillo2309/phylodrop -profile docker
```

By default, Phylodrop uses **Maximum Likelihood (IQ-TREE2)**. To use **Bayesian Inference (MrBayes)**, pass the parameter:

```bash
    --inference_method bayesian
```

## 📂 Output

All outputs are neatly categorized inside a `results/` folder (which is ignored by Git to avoid uploading heavy data):
- `results/00_metadata/`: Formatted `metadata.tsv`.
- `results/01_format/`: Sanitized FASTA files and `id_map.tsv`.
- `results/04_trees/`: Raw phylogenetic trees (`.treefile` or `.con.tre`).
- `results/05_annotated_trees/`: Drag-and-drop `itol_dataset.txt` files for instant mapping in iTOL.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
