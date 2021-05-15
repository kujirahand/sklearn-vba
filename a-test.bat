set IN_FILE="data/iris.data"
set ID_COLUMN=5

echo "* randomforest:"
python src/skl.py test randomforest in=%IN_FILE% idcol=%ID_COLUMN% count=30
echo "* svm"
python src/skl.py test svm in=%IN_FILE% idcol=%ID_COLUMN%
echo "* LinearSVC"
python src/skl.py test LinearSVC in=%IN_FILE% idcol=%ID_COLUMN%
echo "* mlp"
python src/skl.py test mlp in=%IN_FILE% idcol=%ID_COLUMN%
echo "* SGD"
python src/skl.py test sgd in=%IN_FILE% idcol=%ID_COLUMN%
echo "* bayes"
python src/skl.py test native_bayes in=%IN_FILE% idcol=%ID_COLUMN%

pause



