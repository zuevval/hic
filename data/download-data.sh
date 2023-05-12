# download K562 raw Hi-C data
export hicFileName=GSM1551620_HIC071.hic
wget "https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1551nnn/GSM1551620/suppl/${hicFileName}"

# convert to cooler format (50kb resolution) using HiCExplorer
conda activate ../venv
hicConvertFormat -m $hicFileName -o K562.cool --inputFormat hic --outputFormat cool --resolutions 50000

# download reference chromosomes lengths from the UCSC genome browser.
export refLenFname=hg19.chrom.sizes
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/${refLenFname}

# filter chromosome names: only chr1-chr22 + X, Y (this can be easily done by hand, but for the sake of convenience we do it in a script)
export filteredRefLenFname=hg19.filtered.chrom.sizes
head -n 24 $refLenFname > $filteredRefLenFname

# convert from Cooler format to HiSV format
export hiSvDataDir=$(pwd)/hiSvInput
export hiSvDir=../HiSV
python ${hiSvDir}/convert_type/hiccovert.py -o $hiSvDataDir -m K562_50000.cool -t cool

# rename files
export intraDir=${hiSvDataDir}/Intra_matrix
export interDir=${hiSvDataDir}/Inter_matrix
for i in {1..22} X Y; do
  oldnameIntra="${intraDir}/sample_50kb_${i}_${i}_matrix.txt"
  newnameIntra="${hiSvDataDir}/chr${i}.txt"
  mv "$oldnameIntra" "$newnameIntra"
  for j in {1..22} X Y; do
    if ["$j" -le "$i"]; then
      continue
    fi
    oldnameInter="${interDir}/sample_50kb_${i}_${j}_matrix.txt"
    newnameInter="${hiSvDataDir}/chr${i}_chr${j}.txt"
    mv "$oldnameInter" "$newnameInter"
  done
done

# run HiSV
python ${hiSvDir}/HiSV_code/HiSV.py -o $(pwd)/hiSvOutput -l $(pwd)/$filteredRefLenFname -f $hiSvDataDir -c 0.2

# Download features for two chromosomes in K562 and GM12878
wget https://zenodo.org/record/3525510/files/K562.tgz
tar -xvzf K562.tgz

wget https://zenodo.org/record/3525432/files/Gm12878.tgz
tar -xvzf GM12878.tgz
