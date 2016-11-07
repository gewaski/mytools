# wei.zhang@weimob.com

BACKUP_DIR=/backup/
NFS_DIR=/aliyun-disk/

tt=`date +'%Y%m%d%H%M%S'`

pushd ${BACKUP_DIR};

alllist=tmpalllist.${tt}
find ${NFS_DIR} -type f > $alllist

cat $alllist | grep -E \/h2db\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF);if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w1.${tt}

cat $alllist | grep -E \/data\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF);if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w2.${tt}

cat $alllist | grep -E \/h2db\.[0-9]{10}\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF); dirname=dirname""substr(basename,1,15); basename=substr(basename,16,15); if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w3.${tt}

cat $alllist | grep -E \/data\.[0-9]{10}\.[0-9]{14}$ | sort -r | awk -F"/" 'BEGIN{curDir=""; usedDir=""; start = 0;} {dirname=substr($0,1,length($0)-length($(NF)));basename=$(NF); dirname=dirname""substr(basename,1,15); basename=substr(basename,16,15); if(start == 1 && usedDir == dirname) {print $0; curDir = dirname; start = 0;}  if(dirname!=curDir) {start=0; print $0;start++; usedDir = dirname;}}' > w4.${tt}

find ${NFS_DIR} -type f -mtime -30 > w5.${tt}

cat w1.${tt} w2.${tt} w3.${tt} w4.${tt} w5.${tt} | sort -u > wall.${tt}
cat $alllist | sort -u > all.${tt}
comm -2 -3 all.${tt} wall.${tt} > backup.${tt}

tar -vzcf statistic-nfs.`date +'%Y%m%d%H%M%S'`.tgz -T backup.${tt}

cat backup.${tt} | xargs -I{} echo {}

popd

