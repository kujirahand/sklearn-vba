import sys, os
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import pickle

import skl_utils as utils

def show_usage():
    print("[USAGE]")
    print("skl train in=xxx.csv out=xxx.pkl")
    print("Options:")
    print("     algo=" + utils.get_algo())
    print("     delimiter=(,|tab|;)")
    print("     idcol=1 ... class id column")
    quit()

def exec(args):
    # parse parameters
    if not "in" in args:
        show_usage()
        return
    if not "out" in args:
        show_usage()
        return

    # load
    in_file = args["in"]
    y, x = utils.load_csv(in_file)
    # train
    clf = utils.get_class()
    clf.fit(x, y)
    # save
    out_file = args["out"]
    with open(out_file, 'wb') as file:
        pickle.dump(clf, file)
    print("ok")






        
    

