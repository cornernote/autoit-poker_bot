#include-once

; ensure classifier is running to convert filenames to cards/suits
Func _ClassifyCheck()
   If ProcessExists("python.exe") Then Return
   Local $python = IniRead(@ScriptDir & "\settings.ini","executable","python","python.exe")
   Run('"'&$python&'"' & " classify.py ", @ScriptDir & "\includes\vendors\CardClassify", "", $STDERR_CHILD + $STDOUT_CHILD)
EndFunc   ;==>_Classify

Func _ClassifyClose()
   If ProcessExists("python.exe") Then
	  ProcessClose("python.exe")
   EndIf
EndFunc   ;==>_ClassifyClose

Func _ClassifyInit()
   _ClassifyClose() ; close any stray process
EndFunc   ;==>_ClassifyInit