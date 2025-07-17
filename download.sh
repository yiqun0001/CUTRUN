mkdir src
wget -P ./src https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar 
wget -P ./src https://github.com/usadellab/Trimmomatic/files/5854848/Trimmomatic-0.36.zip
unzip ./src/Trimmomatic-0.36.zip -d ./src
wget -P ./src https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2
tar -xvf ./src/samtools-1.17.tar.bz2 -C ./src
