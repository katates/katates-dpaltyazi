Option Explicit
Const conForReading = 1
Dim objFSO, contents, result

    result = 1

    Set objFSO = CreateObject("Scripting.FileSystemObject")

    If objFSO.GetFile("%tmp%\list2.txt").Size > 0 Then 

        contents = objFSO.OpenTextFile("%tmp%\list2.txt", 1, False).ReadAll

        If MsgBox ("Link" & contents & "",vbYesNo+vbExclamation+vbSystemModal,"Divxplanet açýlsýn mý?") = vbYes Then
            result = 0
        End If 

    End If  

    WScript.Quit result