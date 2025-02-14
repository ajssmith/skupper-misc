# generate binary downloads
1. Create staging directory
2. Clone this repo
3. Get generate-download.sh
4. ./generate-download 1.5.5 1
5. ./release-chechsum 1.5.5.GA
6. cat *.md5
7. Submit SPMM ticket to post to download site with checksums in ticket


rsync -rlp --info=progress2 RHSI-1.5.3.GA spmm-util:staging/rhsi/
ssh spmm-util ls /staging/rhsi/RHSI-1.5.3.GA
ssh spmm-util rm -rf /staging/rhsi/RHSI-1.5.3.GA