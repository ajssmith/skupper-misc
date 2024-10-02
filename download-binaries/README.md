# generate binary downloads
1. Create staging directory
2. Clone this repo
3. Get generate-download.sh
4. ./generate-download 1.5.5 1
6. Submit ticket to post to download site


rsync -rlp --info=progress2 RHSI-1.5.3.GA spmm-util:staging/rhsi/
ssh spmm-util ls /staging/rhsi/RHSI-1.5.3.GA
ssh spmm-util rm -rf /staging/rhsi/RHSI-1.5.3.GA