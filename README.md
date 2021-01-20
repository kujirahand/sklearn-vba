# sklearn-vba
scikit-learn for Excel VBA(Windows) 

scikit-learnを手軽にExcel VBAから使うためのプロジェクト。

## 準備

### [1] Anacondaとpyinstaller のインストール

AnacondaなどでPythonの機械学習環境を一気に構築する。そして、PyInstallerをインストール。

```
pip install pyinstaller
```

### [2] skl.exe を生成

バッチファイル「build-skl.bat」を実行して、skl.exeを生成する

```
build-skl.bat
```

### [3] Excel VBAにskl.basを取り込みskl.exeを配置

skl.basをVBAプロジェクトに取り込みます。そして、binフォルダを作り、そこにskl.exeをコピーします。





