# skl_utils.py
import csv, re
from sklearn.metrics import accuracy_score

from sklearn.svm import SVC
from sklearn.svm import LinearSVC
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import LinearRegression
from sklearn.isotonic import IsotonicRegression
# 暗黙的なインポート
import sklearn.utils._weight_vector
import sklearn.neighbors._typedefs
import sklearn.neighbors._quad_tree

args = {}

def init(args):
    args.clear()
    args["command"] = ""
    args["algo"] = ""
    args["args"] = []
    args["delimiter"] = ","
    args["idcol"] = "1"

def csv_reader(file_path):
    # check delimiter
    delimiter = args["delimiter"]
    if delimiter == "tab": delimiter = "\t"
    if delimiter == "comma": delimiter = ","
    # get fp and reader
    fp = open(file_path, "rt", encoding="utf-8")
    return fp, csv.reader(fp, delimiter=delimiter)

def conv_float(v):
    if v == "": return ""
    try:
        return float(v)
    except:
        return v

def load_csv_data(file_path):
    x = []
    # read
    fp, reader = csv_reader(file_path)
    for row in reader:
        if len(row) == 0: continue
        row = [conv_float(v) for v in row] # データを実数に変換
        x.append(row)
    fp.close()
    return x

def load_csv(file_path):
    y = []
    x = []
    # column
    if args["idcol"].isnumeric():
        idcol = int(args["idcol"]) - 1
    # read
    fp, reader = csv_reader(file_path)
    for row in reader:
        if (len(row) < idcol): continue
        lbl = row.pop(idcol)
        y.append(lbl) # sklearnではラベルは文字列も許容される
        row = [conv_float(v) for v in row] # その他のデータは実数に変換
        x.append(row)
        # print("# ", row)
    fp.close()
    return y, x

def get_algo():
    return "(svm|LinearSVC|MLP|RandomForest|LinearRegression|IsotonicRegression)"

def get_class():
    name = args["algo"].lower()
    if name == "svm":
        clf = SVC()
    elif name == "linearsvc":
        clf = LinearSVC()
    elif name == "mlp":
        clf = MLPClassifier()
    elif name == "randomforest":
        clf = RandomForestClassifier()
    elif name == "sgd":
        clf = SGDClassifier()
    elif name == "LinearRegression":
        clf = LinearRegression(normalize=True)
    elif name == "IsotonicRegression":
        clf = IsotonicRegression(out_of_bounds="clip")
    else:
        clf = SVC()
    return clf
