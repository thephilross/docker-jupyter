read -r -d '' INSTALL << EOM
source('http://bioconductor.org/biocLite.R');
biocLite(ask=FALSE);
biocLite(c(
    'ballgown',
    'CAGEr',
    'ShortRead',
    'Rsamtools',
    'GenomicAlignments',
    'GenomicFeatures',
    'Biostrings',
    'BSgenome',
    'ggbio',
    'seqLogo',
    'GenomicRanges',
    'BiocStyle',
    'ChIPseeker',
    'msa'),
ask=FALSE);
EOM

Rscript -e $INSTALL