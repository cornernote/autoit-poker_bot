#include-once
#include <StringConstants.au3>

Func _Ocr($filename)
   Local $path = @ScriptDir & "\data\ocr"
   If Not FileExists($path & "\" & $filename & ".txt") Then
	  DirCreate($path)
	  Local $tesseract = IniRead(@ScriptDir & "\settings.ini","executable","tesseract","tesseract.exe")
	  Local $process = Run('"'&$tesseract&'"' & " " & '"'&$path&"\"&$filename&'"' & " " & '"'&$path&"\"&$filename&'"' & " ", "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	  ProcessWaitClose($process)
	  If Not FileExists($path & "\" & $filename & ".txt") Then
		 FileWrite($path & "\" & $filename & ".txt", '-')
	  EndIf
   EndIf
   Local $string = FileRead($path & "\" & $filename & ".txt")
   $string = StringReplace($string, "", "")
   $string = StringStripWS($string, $STR_STRIPTRAILING)
   Return $string
EndFunc