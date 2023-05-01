# download K562 raw Hi-C data
export hicFileName=GSM1551620_HIC071.hic
wget "https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1551nnn/GSM1551620/suppl/${hicFileName}"

# convert to cooler format (50kb resolution) using HiCExplorer
conda activate ../venv
hicConvertFormat -m $hicFileName -o K562.cool --inputFormat hic --outputFormat cool --resolutions 50000

# download reference chromosomes lengths from the UCSC genome browser. TODO modify according to my needs & upload to server
export refLenFname=hg19.chrom.sizes
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/${refLenFname}

# convert from Cooler format to HiSV format
export hiSvDataDir=$(pwd)/hiSvInput
export hiSvDir=../HiSV
python ${hiSvDir}/convert_type/hiccovert.py -o $hiSvDataDir -m K562_50000.cool -t cool

# run HiSV
python ${hiSvDir}/HiSV_code/HiSV.py -o $(pwd)/hiSvOutput -l $(pwd)/${refLenFname} -f $hiSvDataDir
