import sys
import subprocess
import datetime
import os
import time

def nowstr():
    t = datetime.datetime.now()
    return [t, t.strftime('%Y%m%d_%H%M%S')]

saveInterval=10
collectInterval=1
dir="result"
startTime=nowstr()
lastSaveTime=None
cmd="""mysql -uroot -pxxx -e "show processlist" | sed -n 2,\$p | awk '{print $3, $4}'"""
target=set(['dataflow',''])

if(False == os.path.exists(dir)):
    os.makedirs(dir)

s = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
lines = s.communicate()[0]
r=set()
while(True):
    time.sleep(collectInterval)
    now=nowstr()
    print "collect " + now[1]
    for line in lines.split("\n"):
        secs = line.split(" ")
        if(len(secs) == 2):
            db = secs[1]
            ip = secs[0].split(":")[0]
            if (db in target):
                k = ip+"."+db
                r.add(k)
    if(lastSaveTime is None or (now[0]-lastSaveTime[0]).seconds > saveInterval):
        fname=dir+"/"+startTime[1]+"---"+now[1]
        print "save " + fname
        lastSaveTime=now
        f = open(fname, 'w')
        f.write("\n".join(r)+"\n")
        f.close()

