# download K562 raw Hi-C data
export hicFileName=GSM1551620_HIC071.hic
wget "https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1551nnn/GSM1551620/suppl/${hicFileName}"

# convert to cooler format (50kb resolution) using HiCExplorer
conda activate ../venv
hicConvertFormat -m $hicFileName -o K562.cool --inputFormat hic --outputFormat cool --resolutions 50000

# extract pixels to TSV (TODO: extract a single chromosome)
cooler dump K562_50000.cool &> K562_50000.tsv

