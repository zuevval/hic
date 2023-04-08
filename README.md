# Large SVs detection from Hi-C and one-dimensional regulatory signals data

## Pre-requisites
Python3.x + conda + mamba

## Installation

```shell
git clone --recurse-submodules https://github.com/zuevval/hic.git
cd hic

mamba env create -f environment.yml --prefix ./venv
conda activate ./venv
```
This will clone the repository with submodules, create and activate a fresh conda environment with python3.7 and all required libraries.

## Troubleshooting

Feel free to [open an issue](https://github.com/zuevval/hic/issues)

## Additional components
For data processing, we used
* [HiCExplorer](https://hicexplorer.readthedocs.io/) (included as a dependency in `environment.yml` in this repository).
* [cooler](https://cooler.readthedocs.io/) (also included in dependencies)
## How to uninstall
```shell
conda deactivate
conda env remove --prefix ./venv
```

