import sys, os

exe = os.path.abspath(sys.argv[0])
exe_dir = os.path.dirname(exe)

print("exe:",exe)
print("dir:", exe_dir)

print(sys.argv)

