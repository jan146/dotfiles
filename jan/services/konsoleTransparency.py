import os
# Path of Konsole profile and desired opacity level
pathOld = os.path.expanduser('~')+"/.local/share/konsole/colors-konsole.colorscheme"
pathNew = os.path.expanduser('~')+"/.local/share/konsole/colors-konsole-with-opacity.colorscheme"
opacity = 0.7

oldFile = open(pathOld,"r")
newFile = open(pathNew,"w+")
for line in oldFile:
    if ("Opacity=" in line):
        newFile.write("Opacity="+str(opacity)+"\n")
        print("Changed Konsole opacity")
    else:
        newFile.write(line)

oldFile.close()
newFile.close()
