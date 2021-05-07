#include-once
#include <AutoItConstants.au3>

Func _IniInit()
   Local $filename = @ScriptDir & "\settings.ini"
   Local $sectionNames = IniReadSectionNames($filename)
   For $i=1 To $sectionNames[0]
	  Local $sectionVars = IniReadSection($filename, $sectionNames[$i])
	  For $j=1 To $sectionVars[0][0]
		 Assign('ini_'&$sectionNames[$i]&'_'&$sectionVars[$j][0], $sectionVars[$j][1], $ASSIGN_FORCEGLOBAL)
	  Next
   Next
EndFunc

