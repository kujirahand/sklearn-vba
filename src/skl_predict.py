from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import pickle,csv
import sys, os

import skl_utils as utils

def show_usage():
    print("[USAGE]")
    print("skl predict model=xxx.pkl in=xxx.csv")
    print("Options:")
    print("     algo=" + utils.get_algo())
    print("     delimiter=(,|tab|;)")
    quit()

def exec(args):
    # parse parameters
    if not "model" in args:
        show_usage()
        return
    if not "in" in args:
        show_usage()
        return
    # files
    model_file = args["model"]
    in_file = args["in"]
    # load model
    with open(model_file, 'rb') as file:
        model = pickle.load(file)
    # in file
    data = utils.load_csv_data(in_file)
    # predict
    out = model.predict(data)
    for v in out:
        print(v)






        
    

