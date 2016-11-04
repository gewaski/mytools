BACKUP_DIR=/backup/
NFS_DIR=/aliyun-disk/

pushd ${BACKUP_DIR};

alllist=tmpalllist
find ${NFS_DIR} -type f > $alllist

cat $alllist | grep -E \/h2db\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF);if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w1

cat $alllist | grep -E \/data\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF);if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w2

cat $alllist | grep -E \/h2db\.[0-9]{10}\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF); dirname=dirname""substr(basename,1,15); basename=substr(basename,16,15); if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w3

cat $alllist | grep -E \/data\.[0-9]{10}\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF); dirname=dirname""substr(basename,1,15); basename=substr(basename,16,15); if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w4

find ${NFS_DIR} -type f -mtime -30 > w5

cat w1 w2 w3 w4 w5 | sort -u > wall
cat $alllist | sort -u > all
grep -vF -f wall all > backup

tar -vzcf statistic-nfs.`date +'%Y%m%d%H%M%S'`.tgz -T backup

cat backup | xargs -I{} echo {}

popd

# find /statistic/ -type f | grep -vE csv$\|html\|xls\|csvdata_[0-9]{2}$\|h2db\.[0-9]{14}$\|data\.[0-9]{14}$\|h2db\.[0-9]{10}\.[0-9]{14}\|data\.[0-9]{10}\.[0-9]{14}
