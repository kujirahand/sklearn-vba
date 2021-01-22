Attribute VB_Name = "skl"
Option Explicit

'
' sklearn for VBA
'

Public Const sklSVM = "SVM"
Public Const sklMLP = "MLP"
Public Const sklRandomForest = "RandomForest"
Public Const sklLinearSVC = "LinearSVC"
Public Const sklLinearRegression = "LinearRegression"
Public Const sklIsotonicRegression = "IsotonicRegression"

Dim SKLPath As String
Dim SKLDebug As Boolean

Public Sub SetSKLPath(ByVal Path)
    SKLPath = Path
End Sub

Public Sub SetSKLDebug(ByVal v As Boolean)
    SKLDebug = v
End Sub



Private Sub SKLInit()
    ' Find SKLPath
    If SKLPath = "" Then
        ' skl dir
        SKLPath = ThisWorkbook.Path & "skl\skl.exe"
        If FileExists(SKLPath) = False Then
            ' src\dict dir -- source
            SKLPath = ThisWorkbook.Path & "src\dict\skl.exe"
            If FileExists(SKLPath) = False Then
                SKLPath = ""
            End If
        End If
    End If
End Sub

Private Function GetSKLPath() As String
    ' Check
    If SKLPath = "" Then
        Dim py
        py = ThisWorkbook.Path & "\src\skl.py"
        If FileExists(py) Then
            GetSKLPath = "python " & qq(ThisWorkbook.Path & "\src\skl.py")
        Else
            Debug.Print "[ERROR] skl.exe not found ..."
        End If
    Else
        GetSKLPath = qq(SKLPath)
    End If
End Function


Public Function SKLTest(ByRef Sheet As Worksheet, ByVal Algorythm As String, ByVal ClassIdCol As Integer, ByVal TestCount As Integer) As String
    Dim tsv As String, TsvFile As String, cmd As String
    tsv = ToTSV(Sheet)
    TsvFile = GetTempPath(".csv")
    SaveToFile TsvFile, tsv, "utf-8"
    
    cmd = "test algo=" & Algorythm & _
        " idcol=" & ClassIdCol & _
        " " & qq("in=" & TsvFile) & _
        " delimiter=tab" & _
        " count=" & TestCount
    SKLTest = SKLExec(cmd)
    
End Function

Public Function SKLTrain(ByRef Sheet As Worksheet, ByVal Algorythm As String, ByVal ClassIdCol As Integer, ByVal OutModelFile As String) As String
    Dim tsv As String, TsvFile As String, cmd As String
    tsv = ToTSV(Sheet)
    TsvFile = GetTempPath(".csv")
    SaveToFile TsvFile, tsv, "utf-8"
    
    cmd = "train algo=" & Algorythm & _
        " idcol=" & ClassIdCol & _
        " " & qq("in=" & TsvFile) & _
        " " & qq("out=" & OutModelFile) & _
        " delimiter=tab"
    SKLTrain = SKLExec(cmd)
End Function

Public Function SKLPredict(ByRef Sheet As Worksheet, ByVal ModelFile As String) As String
    Dim tsv As String, TsvFile As String, cmd As String
    tsv = ToTSV(Sheet)
    TsvFile = GetTempPath(".csv")
    SaveToFile TsvFile, tsv, "utf-8"
    
    cmd = "predict " & _
        " " & qq("in=" & TsvFile) & _
        " " & qq("model=" & ModelFile) & _
        " delimiter=tab"
    SKLPredict = SKLExec(cmd)
End Function

Public Function SKLExec(ByVal Commands As String) As String
    Dim InFile As String, ResultFile As String, cmd As String, Res As String
    Dim BatFile As String, Opt As String, skl As String, bat As String
    Dim ErrFile As String, ErrMsg As String
    
    ' Debug?
    If SKLDebug Then
        Commands = Commands & " debug=1"
    End If
    
    Call SKLInit
    
    skl = GetSKLPath
    BatFile = GetTempPath(".bat")
    ResultFile = GetTempPath(".txt")
    ErrFile = GetTempPath(".txt")
    bat = skl & " " & _
        Commands & " " & _
        " 1>" & ResultFile & _
        " 2>" & ErrFile & vbCrLf
    SaveToFile BatFile, bat, "Shift_JIS"
    Debug.Print bat
    
    ' バッチを実行
    If ShellWait(BatFile) Then
        Res = LoadFromFile(ResultFile, "utf-8")
        SKLExec = Res
    Else
        ErrMsg = Trim(LoadFromFile(ErrFile, "Shift_JIS"))
        If ErrMsg <> "" Then
            Debug.Print "[ERROR] " & ErrMsg
        End If
        Res = LoadFromFile(ResultFile, "utf-8")
        If Res <> "" Then
            Debug.Print "[PRINT] " & Res
        End If
        SKLExec = ""
    End If
End Function

Private Function GetTempPath(Ext As String) As String
    Dim FSO As Object, tmp As String
    Set FSO = CreateObject("Scripting.FileSystemObject")
    tmp = FSO.GetSpecialFolder(2) & "\" & FSO.GetBaseName(FSO.GetTempName) & Ext
    GetTempPath = tmp
End Function


' Clear sheet
Public Sub ClearSheet(ByRef Sheet As Worksheet, ByVal TopRow As Integer)
    Dim EndCol, EndRow, row, Col
    With Sheet.UsedRange
        EndRow = .Rows(.Rows.Count).row
        EndCol = .Columns(.Columns.Count).Column
    End With
    For row = TopRow To EndRow
        For Col = 1 To EndCol
            Sheet.Cells(row, Col) = ""
        Next
    Next
End Sub

' TSV to Sheet
Public Sub TSVToSheet(ByRef Sheet As Worksheet, ByVal tsv As String, TopRow As Integer)
    Dim Rows As Variant, Cols As Variant
    Dim i, j
    Rows = Split(tsv, Chr(10))
    For i = 0 To UBound(Rows)
        Cols = Split(Rows(i), Chr(9))
        For j = 0 To UBound(Cols)
            Dim v
            v = Cols(j)
            v = Replace(v, "¶", vbCrLf)
            Sheet.Cells(i + TopRow, j + 1) = v
        Next
    Next
End Sub


' Convert Sheet to TSV
Public Function ToTSV(ByRef Sheet As Worksheet) As String
    Dim s As String
    s = ""
    ' シートの範囲を取得
    Dim BottomRow As Integer, RightCol As Integer
    BottomRow = Sheet.Range("A1").End(xlDown).row
    RightCol = Sheet.Range("A1").End(xlToRight).Column
    ' シート範囲を左上から順に取得
    Dim y, x, v, line
    For y = 1 To BottomRow
        line = ""
        For x = 1 To RightCol
            v = Sheet.Cells(y, x)
            ' セル内の改行だけは置換しておく
            v = Replace(v, vbCrLf, "¶")
            line = line & v & Chr(9)
        Next
        line = Mid(line, 1, Len(line) - 1)
        s = s & line & vbCrLf
    Next
    ToTSV = s
End Function

' クォート処理
Public Function qq(str) As String
    qq = """" & str & """"
End Function

' コマンドを実行して終了まで待機する
Public Function ShellWait(ByVal Command As String) As Boolean
    On Error GoTo SHELL_ERROR
    Dim wsh As Object
    Set wsh = CreateObject("Wscript.Shell")
    Dim Res As Integer
    Res = wsh.Run(Command, 7, True) ' 最小化して終了まで待機
    ShellWait = (Res = 0)
    Exit Function
SHELL_ERROR:
    ShellWait = False
    Debug.Print "[error] execute"
End Function

' 任意の文字エンコーディングを指定してテキストファイルを読む
Private Function LoadFromFile(Filename, Charset) As String
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 2 ' text
    stream.Charset = Charset
    stream.Open
    stream.LoadFromFile Filename
    LoadFromFile = stream.ReadText
    stream.Close
End Function

' テキストを指定文字コードでファイルに保存
Private Sub SaveToFile(ByVal Filename, ByVal Text, ByVal Charset)
    ' UTF-8 の場合 BOMは不要
    If LCase(Charset) = "utf-8" Or LCase(Charset) = "utf-8n" Or LCase(Charset) = "utf8" Then
        Call SaveToFileUTF8N(Filename, Text)
        Exit Sub
    End If
    
    Dim stream As Object
    Set stream = CreateObject("ADODB.Stream")
    stream.Charset = Charset
    stream.Open
    stream.WriteText Text
    stream.SaveToFile Filename, 2
    stream.Close
End Sub

' BOMなしのUTF-8でファイルにテキストを書き込む
Private Sub SaveToFileUTF8N(Filename, Text)
    Dim stream, buf
    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Type = 2 ' テキストモードを指定 --- (*1)
        .Charset = "UTF-8"
        .Open
        .WriteText Text ' テキストを書き込む
        .Position = 0 ' カーソルをファイル先頭に --- (*2)
        .Type = 1 ' バイナリモードに変更
        .Position = 3 ' BOM(3バイト)を飛ばす
        buf = .Read() ' 内容を読み込む
        .Position = 0 ' カーソルを先頭に --- (*3)
        .Write buf ' BOMなしのテキストを書き込み
        .SetEOS
        .SaveToFile Filename, 2
        .Close
    End With
End Sub

Private Function FileExists(ByVal Filename) As Boolean
    Dim FSO As Object
    Set FSO = CreateObject("Scripting.FileSystemObject")
    FileExists = FSO.FileExists(Filename)
    Set FSO = Nothing
End Function

