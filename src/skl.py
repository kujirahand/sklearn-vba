import sys, os

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score

# path
app_path = os.path.abspath(sys.argv[0])
app_dir = os.path.dirname(app_path)
# command
app_args = {
    "command":"",
    "algorythm":"",
    "args":[],
}

def usage():
    print("[USAGE] skl command algorythm args ...")
    quit()
    exit

def main():
    # parse command line
    if len(sys.argv) == 1:
        usage()
        exit
    # argv
    for v in sys.argv:
        if app_args["command"] == "":
            app_args["command"] = v
            continue
        if app_args["algorythm"] == "":
            app_args["algorythm"] = v
            continue
        if "=" in v:
            key, val = v.split("=", 2)
            app_args[key] = val
            continue
        app_args["args"].append(v)
    # exec command
    cmd = app_args["command"]
    if cmd == "test":
        test_data()
        return
    if cmd == "train":
        train_data()
        return
    if cmd == "predict":
        predict_data()
        return
    # command not found
    print("[error] command not found")
    usage()

def test_data_usage():
    print("[USAGE] skl test (algo) in=xxx.csv")
    quit()

def test_data():
    if not "in" in app_args:
        test_data_usage()
        return
    

def train_data():
    pass

def predict_data():
    pass

if __name__ == '__main__':
    main()
