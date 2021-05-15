# sklearn-vba - scikit-learn for Excel VBA(Windows) 

Pythonの人気機械学習ライブラリ『scikit-learn』をPythonなしで手軽にExcel VBAから使うためのプロジェクト。
ワークシートにデータを書いて、ラベル列を指定するだけで、機械学習のデータセットが作れます。VBAだけで機械学習が実践できます。

- このライブラリは、書籍『プログラマーの本気がExcelを覚醒させる 超絶ExcelVBA』のために作成したライブラリです。書籍の中で詳しい使い方を紹介しています。
 - [→プログラマーの本気がExcelを覚醒させる 超絶ExcelVBA](https://github.com/kujirahand/chozetu-excel-vba)


## 準備 - バイナリをダウンロードする場合

 - (1) [こちら](https://github.com/kujirahand/sklearn-vba/releases)から最新の「dist.zip」をダウンロード。
 - (2) 上記のZIPを解凍。skl.basがあるフォルダと同じところに、マクロ有効ブックを作成。
 - (3) ブックで[Alt]+[F11]でVBエディタを起動。
 - (4) メニューの[ファイル] > [ファイルのインポート]でskl.basを追加。
 - (5) ブックと同じフォルダに「skl」があることを確認する。なお、sklフォルダ以下にはたくさんのファイルがある。

## 試してみよう

付属のサンプルブック「sample.xlsm」を起動して、Sheet1に書かれているマクロをいろいろ試してみよう。

```
Sub TestSKL()
    ' Sheet1にあるデータでMLPのアルゴリズムが何パーセント有効かテスト
    MsgBox SKLTest(Sheet1, sklMLP, 5, 3)
End Sub

Sub TrainAndPredict()
    Sheet2.Activate

    ' Sheet1にあるデータをMLPのアルゴリズムで学習モデルを作成
    ModelFile = ThisWorkbook.Path & "test.pkl"
    Debug.Print SKLTrain(Sheet1, sklMLP, 5, ModelFile)

    ' 作成したモデルを使って、Sheet2の内容を分類！
    MsgBox SKLPredict(Sheet2, ModelFile)
End Sub
```


## 自分でコンパイルする場合

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


## デバッグに便利な環境変数

 - 環境変数「SKLEARN_VBA_EXE」を指定しておけば、その環境変数にある実行ファイルかPythonファイルを使って機械学習を実行する。


