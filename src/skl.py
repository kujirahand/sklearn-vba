import sys, os, re

import skl_test, skl_train, skl_predict
import skl_utils as utils

# path
app_path = os.path.abspath(sys.argv[0])
app_dir = os.path.dirname(app_path)

def usage():
    print("[USAGE] skl (test|train|predict) args ...")
    return

def main():
    # init args
    argv = utils.args
    utils.init(argv)
    # parse command line
    if len(sys.argv) == 1:
        usage()
        return
    # argv
    for i, v in enumerate(sys.argv):
        if i == 0: continue
        if i == 1 and re.search('\.py$', v): continue
        if argv["command"] == "":
            argv["command"] = v
            continue
        if "=" in v:
            key, val = v.split("=", 2)
            argv[key] = val
            continue
        argv["args"].append(v)
    # exec command
    cmd = argv["command"]
    if cmd == "test":
        skl_test.exec(argv)
        return
    if cmd == "train":
        skl_train.exec(argv)
        return
    if cmd == "predict":
        skl_predict.exec(argv)
        return
    # command not found
    print("[error] command not found")
    usage()

if __name__ == '__main__':
    main()
