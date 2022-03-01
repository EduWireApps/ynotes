import base64
import os.path
import re
from os import replace

# README : The goal of this file is to get a list of every files containing a call to Logger.
# We are then able to get a full stacktrace (with file name and line) at each call of Logger.error()
# This script should be runned at each add of a Logger.error()
rootdir=('./lib')


# In this function we will walk into the whole directory to search for Logger.error calls
# Each time we encounter a Logger.error() we add its line and the filename to a dictionnary
def metas():
    pattern = "Logger\.error\(.*\)"
    counter = 0
    dic = {}
    for folder, dirs, files in os.walk(rootdir):
        for file in files:
            if file.endswith('.dart'):
                fullpath = os.path.join(folder, file)
                replacement = ""
                with open(fullpath, 'r', encoding="utf8") as f:
                    line_counter = 0
                    for line in f:
                        line_counter+=1
                        result = re.search(pattern, line)
                        if result:
                            line_bytes = str(counter).encode('ascii')
                            base64_bytes = base64.b64encode(line_bytes)
                            base64_string = base64_bytes.decode('ascii')
                            dic[base64_string] = {"line":line_counter,"file_path": fullpath}
                            changes =  re.sub(pattern, ('Logger.error(e, stackHint:"' + base64_string +'")'), line)
                            replacement = replacement + changes
                            counter += 1 
                        else:
                            replacement = replacement + line 
                fout = open(fullpath, 'w', encoding="utf8")
                fout.write(replacement)
                fout.close()

    return dic    

def stackListExists():
    if os.path.isfile('./lib/logs_stacklist.dart') == False:
        f = open("./lib/logs_stacklist.dart", "w")

def writeInStackList(dic):
    f = open("./lib/logs_stacklist.dart", "w")
    # Lets write our super stack list file
    f.write("Map stackList = " + str(dic) + ";")
stack_dic = metas()
writeInStackList(stack_dic)
stackListExists()

