# CUTRUN
## Usage
```
# download picard.jar, samtools, and Trimmomatic
bash download.sh
# download the mm10 index files
bash download_index.sh
# build the apptainer
srun --pty -p day -t 2:00:00 --mem=4G bash
# change `~/docker/src` in `build.sh` to the `src` directory created by the above scripts
bash build.sh
```
