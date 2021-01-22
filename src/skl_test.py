import sys, os
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

import skl_utils as utils

def show_usage():
    print("[USAGE]")
    print("skl test in=xxx.csv")
    print("Options:")
    print("     algo=" + utils.get_algo())
    print("     count=10 ... try count")
    print("     delimiter=(,|tab|;)")
    print("     idcol=1 ... class id column")
    quit()

def exec(args):
    # parse parameters
    if not "in" in args:
        show_usage()
        return
    if not "count" in args:
        args["count"] = "10"

    # test
    in_file = args["in"]
    y, x = utils.load_csv(in_file)
    # try 10 count
    i_count = int(args["count"])
    total = 0
    for _ in range(i_count):
        # split
        x_train, x_test, y_train, y_test = train_test_split(
            x, y,
            test_size=0.3,
            train_size=0.7,
            shuffle = True)
        # train
        clf = utils.get_class()
        clf.fit(x_train, y_train)
        # eval
        y_pred = clf.predict(x_test)
        score = accuracy_score(y_test, y_pred)
        total += score
    score_ave = total / i_count
    print(score_ave)






        
    

