Attribute VB_Name = "initApp"
'-----------------------------------------
Public myobject As New ApplicationEvent

'-------main----------
Public Sub InitializeApplication()'{{{
	Debug.Print "InitializeApplication"
	Call SetAppEvent
	Call AllKeyToAssesKeyFunc
	Call SpecialMapping
	Call OpenRegisterBook()
	If Workbooks.Count = 1 Then
		Workbooks.Add
	End If
	Application.Cursor = xlNorthwestArrow
End Sub'}}}

'------supplimental functions-------------
Public Sub SpecialMapping()'{{{
	'ここで指定した関数はkeystroke.basが不具合でも働く｡mapping.txtを上書く
	' Application.OnKey "{f11}", "'updateModules ""VimX"", 0'"
	Application.OnKey "{f11}", "'updateModulesOfBook """", False'"
End Sub'}}}

Private Sub OpenRegisterBook()'{{{
	Application.ScreenUpdating = False
	Workbooks.Open FileName:=ThisWorkbook.Path & "\data\register.xlsx", ReadOnly:=True
	Windows("register.xlsx").Visible = False
End Sub'}}}

Public Sub SetAppEvent()'{{{
	Debug.Print "Called SetAppEvent"
	Set myobject.appevent = Application
End Sub'}}}
