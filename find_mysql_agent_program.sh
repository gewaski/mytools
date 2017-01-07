mysqlip="xx.xx.xx.xx:3306"
pss=`netstat -anp | grep ${mysqlip} | awk '{print $7}' | grep -v "-" | awk -F"/" '{print $1}'`

for p in $pss;do
  readlink /proc/$p/cwd
  cat /proc/$p/cmdline
  echo -e "\n"
done
