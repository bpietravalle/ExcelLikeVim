Attribute VB_Name = "EditOperation"
Sub InteriorColor(number) '{{{
        Selection.Interior.ColorIndex = number
End Sub '}}}

Sub FontColor(number) '{{{
	Debug.Print "FontColor"
	Selection.Font.ColorIndex = number
End Sub '}}}

Sub SetRuledLines() '{{{
        Selection.Borders.LineStyle = xlContinuous
End Sub '}}}

Sub UnsetRuledLines() '{{{
        Selection.Borders.LineStyle = xlLineStyleNone
End Sub '}}}

Sub merge() '{{{
        Selection.merge
End Sub '}}}

Sub unmerge() '{{{
        Selection.unmerge
End Sub '}}}

Sub ex_up() '{{{
        Application.ScreenUpdating = False
        cur_row = ActiveCell.Row
        Rows(cur_row).Copy
        'target_rowの選択
        Dim i As Long
        i = 1
        Do Until ActiveCell.Offset(-i, 0).EntireRow.Hidden = False
                i = i + 1
        Loop
        target_row = ActiveCell.Offset(-i, 0).Row
        target_column = ActiveCell.Offset(-i, 0).Column

        Rows(target_row).Select
        Selection.Insert

        '移動前のセルを削除
        Rows(cur_row + 1).Delete
        '処理後の選択セルを自然に
        cells(target_row, target_column).Select
End Sub '}}}

Sub ex_below() '{{{
        Application.ScreenUpdating = False
        cur_row = ActiveCell.Row
        Rows(cur_row).Copy
        'target_rowの選択
        Dim i As Long
        i = 1
        Do Until ActiveCell.Offset(i, 0).EntireRow.Hidden = False
                i = i + 1
        Loop
        target_row = ActiveCell.Offset(i, 0).Row
        target_column = ActiveCell.Offset(i, 0).Column

        Rows(target_row + 1).Select
        Selection.Insert
        Rows(cur_row).Delete

        '処理後の選択セルを自然に
        cells(target_row, target_column).Select
End Sub '}}}

Sub ex_right() '{{{
        Application.ScreenUpdating = False
        cur_col = ActiveCell.Column
        Columns(cur_col).Copy
        'target_rowの選択
        Dim i As Long
        i = 1
        Do Until ActiveCell.Offset(0, i).EntireColumn.Hidden = False
                i = i + 1
        Loop
        target_row = ActiveCell.Offset(0, i).Row
        target_column = ActiveCell.Offset(0, i).Column

        Columns(target_column + 1).Select
        Selection.Insert
        Columns(cur_col).Delete

        '処理後の選択セルを自然に
        cells(target_row, target_column).Select
End Sub '}}}

Sub ex_left() '{{{
        Application.ScreenUpdating = False
        cur_col = ActiveCell.Column
        Columns(cur_col).Copy
        'target_rowの選択
        Dim i As Long
        i = 1
        Do Until ActiveCell.Offset(0, -i).EntireColumn.Hidden = False
                i = i + 1
        Loop
        target_row = ActiveCell.Offset(0, -i).Row
        target_column = ActiveCell.Offset(0, -i).Column

        Columns(target_column).Select
        Selection.Insert
        Columns(cur_col + 1).Delete

        '処理後の選択セルを自然に
        cells(target_row, target_column).Select
End Sub '}}}

Sub ZoomInWindow() '{{{
        ActiveWindow.Zoom = ActiveWindow.Zoom + 5
End Sub '}}}

Sub ZoomOutWindow() '{{{
        ActiveWindow.Zoom = ActiveWindow.Zoom - 5
End Sub '}}}

Sub MouseNormal() '{{{
        Application.Cursor = xlDefault
End Sub '}}}

Sub SetSeqNumber(Optional destRange As Range = Nothing) '{{{
        Application.ScreenUpdating = False
        If destRange Is Nothing Then
                Set destRange = Selection
        End If
        Set destRange = destRange.SpecialCells(xlCellTypeVisible)
    n = 1
        For Each r In destRange
                r.value = n
                'Selection.NumberFormatLocal = "G/標準"
                Selection.NumberFormatLocal = "0_);[赤](0)"
                n = n + 1
    Next
End Sub '}}}

Sub SortCurrentColumn() '{{{
        Application.ScreenUpdating = False
        Set targetRange = Selection.CurrentRegion

        With ActiveSheet.Sort
                With .SortFields
                        .Clear
                        .Add _
                                Key:=Columns(ActiveCell.Column), _
                                SortOn:=xlSortOnValues, _
                                Order:=xlAscending, _
                                DataOption:=xlSortNormal
                End With
                        .SetRange targetRange
                        .Header = xlYes '見出し行の有無の判断｡xlGuessはExcelに任せる｡
                        .MatchCase = False
                        .Orientation = xlTopToBottom
                        .SortMethod = xlPinYin
                        .Apply
        End With
End Sub '}}}

'--------sheet_move-------------------
Sub ActivateLeftSheet() '{{{
	sendkeys "^{PGDN}"
End Sub '}}}

Sub ActivateRightSheet() '{{{
	sendkeys "^{PGUP}"
End Sub '}}}

Sub ActivateFirstSheet(Optional where As String) '{{{
	With ActiveWorkbook
		.WorkSheets(1).Activate
	End With
End Sub '}}}

Sub ActivateLastSheet(Optional where As String) '{{{
	With ActiveWorkbook
		.WorkSheets(.WorkSheets.Count).Activate
	End With
End Sub '}}}

'---------auto_filter-----------------
Sub focusFromScratch() '{{{
	Application.ScreenUpdating = False
	cur_row = ActiveCell.Row
	cur_col = ActiveCell.Column
	buf = cells(cur_row, cur_col).value
	If ActiveSheet.FilterMode Then
		ActiveSheet.ShowAllData
	End If
	Range("B3").AutoFilter cur_col, buf
End Sub '}}}

Sub focus() '{{{
	Application.ScreenUpdating = False
	cur_row = ActiveCell.Row
	cur_col = ActiveCell.Column
	buf = cells(cur_row, cur_col).value
	Range("B3").AutoFilter cur_col, buf
End Sub '}}}

Sub exclude()'{{{
	Application.ScreenUpdating = False
	Dim filterCondition As Variant
	Dim buf As String

	buf = cells(ActiveCell.Row ,ActiveCell.Column).value

	Debug.Print Cells(Rows.Count, ActiveCell.Column).End(xlUp).Row
	Set targetColumnRange = Range(Cells(2, ActiveCell.Column), Cells(Rows.Count, ActiveCell.Column).End(xlUp))
	Set targetColumnRange = targetColumnRange.SpecialCells(xlCellTypeVisible)

	Set showedValueCollection = CreateObject("Scripting.Dictionary")
	On Error Resume Next
		For Each c in targetColumnRange
			If c.Value <> buf Then
				showedValueCollection.Add "_" & c.Value, c.Value
			End If
		Next c
	On Error GoTo 0

	filterCondition = showedValueCollection.Keys

	'空文字列がEmptyになっているので､stringの""に戻す｡
	For e = 0 to Ubound(filterCondition)
		filterCondition(e) = Mid(filterCondition(e),2)
	Next e

	Range("B3").AutoFilter field:= ActiveCell.Column, Criteria1:=filterCondition, Operator:=xlFilterValues
End Sub'}}}

Sub filterOff() '{{{
	Application.ScreenUpdating = False
	Range("B3").AutoFilter ActiveCell.Column
End Sub '}}}

Function smallerFonts() '{{{
  Dim currentFontSize As Long
  On Error GoTo ERROR01
  currentFontSize = Selection.Font.Size
  Selection.Font.Size = currentFontSize - 1
  period_buff = ">"
ERROR01:
End Function '}}}

Function biggerFonts() '{{{
  Dim currentFontSize As Long
  On Error GoTo ERROR01
  currentFontSize = Selection.Font.Size
  Selection.Font.Size = currentFontSize + 1
  period_buff = "<"
ERROR01:
End Function '}}}

Sub sp(Optional clearFilterdRowValue = 0) '{{{ smartpaste
	'Todo コピー元のデータを消去する｡(Cut mode)

	Application.ScreenUpdating = False

	'Microsoft Forms 2.0 Object Library に参照設定要
	Dim V As Variant    'クリップボードのデータ全体
	Dim A As Variant    'その内の一行


	Set destRange = Range(ActiveCell, cells(Rows.count, ActiveCell.Column)) 'ActiveCellから一番下まで
	Set destRange = destRange.SpecialCells(xlCellTypeVisible)   '可視セルのみを取得

	'clipboardからデータを取得し変数Vに2次元配列として格納'{{{
	Dim Dobj As DataObject
	Set Dobj = New DataObject
	With Dobj
		.GetFromClipboard
		On Error Resume Next
		V = .GetText
		On Error GoTo 0
	End With'}}}

	If Not IsEmpty(V) Then    'クリップボードからテキストが取得できた時のみ実行
		V = Split(CStr(V), vbCrLf) '行を要素としたstring配列

		'フィルターで隠れている行のデータを削除する｡'{{{
		If clearFilterdRowValue = 1 Then
			referencRangeHeight = UBound(V) + 1
			referencRangeWidth = UBound(Split(CStr(V(0)), vbTab)) + 1
			Debug.Print referencRangeHeight
			Debug.Print referencRangeWidth
			For Each c in ActiveCell.Resize(referencRangeHeight, referencRangeWidth)
				c.Value = ""
			Next c
		End If'}}}

		'元データ削除 TODO
		If Application.CutCopyMode = xlCut Then
			'srcからdstを除いた部分をClearContents
			Set srcRange = GetCopiedRange(ActiveSheet.Name)
			For Each c in srcRange
				c.Value = ""
			Next c

			Application.CutCopyMode = False
		End If

		'貼り付け'{{{
		Dim i As Integer: i = 0
		Dim r As Range
		For Each r In destRange
			If V(i) <> "" Then
				A = Split(CStr(V(i)), vbTab) 'i行目
				For j = 0 to Ubound(A)
					If Cstr(Val(A(j))) = A(j) Then 'A(j)が元は数値
						r.Offset(0, j).Value = Val(A(j))
					Else
						r.Offset(0, j).Value = A(j)
					End If
				Next j
			End If
			i = i + 1
			If i >= UBound(V) Then
				Exit For
			End If
		Next'}}}
	End If

	Set Dobj = Nothing
	Set r = Nothing
End Sub '}}}

Sub sp2(Optional clearFilterdRowValue = 0) '{{{ smartpaste
	'書式もコピー出来るようにする｡
End Sub '}}}

'---------diff-----------------
Sub diffsh(targetsh As Worksheet, fromsh As Worksheet)
	'TODO prompt
	For Each c in fromsh.UsedRange
		If c.Value <> targetsh.Cells(c.Row, c.Column).Value Then
			targetsh.Cells(c.Row, c.Column).Interior.ColorIndex = 29
		End If
	Next c
End Sub

Sub diffRange(targetRange As Range, fromRange As Range)
	'TODO
End Sub
