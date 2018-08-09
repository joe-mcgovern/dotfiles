import sys
import sh

branch = 'master'
if len(sys.argv) > 1:
    branch = sys.argv[1]

try:
    output = sh.git.pull('upstream', branch)
except:
    output = sh.git.pull('origin', branch)

print(output)
