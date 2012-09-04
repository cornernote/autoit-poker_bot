#include-once
#AutoIt3Wrapper_plugin_funcs = MD5Hash
#include "../CompInfo/CompInfo.au3"
;===============================================================================
;
; Description:      Generates a unique hash for your computer.
; Syntax:           _GenHHash ()
; Parameter(s):     None
; Requirement(s):   MD5Hash.dll and CompInfo UDF
; Return Value(s):  On Success - Returns a unique hash
;                   On Failure - Return 0 and sets error
; Author(s):        Chip
; Note(s):          On failure, Error is set to 1 when the CompInfo UDF cannot 
;					read out information and set to 2 when it cannot find MD5Hash.dll.
;
;===============================================================================
Func _GenHHash ()
	Local $I_Pro, $I_BIOS
	_ComputerGetBios ($I_BIOS)
	_ComputerGetProcessors($I_Pro)
	If @error Then Return SetError(1, 0, 0)
	$Str = $I_BIOS[1][3] & $I_BIOS[1][24] & $I_Pro[1][30] & $I_Pro[1][22]
	If FileExists("includes/vendor/MD5Hash/MD5Hash.dll") = 0 Then Return SetError(2, 0, 0)
	Local $plH = PluginOpen("includes/vendor/MD5Hash/MD5Hash.dll")
	Local $ret = MD5Hash ($Str, 2, True)
	PluginClose($plH)
	Return $ret
EndFunc

;===============================================================================
;
; Description:      Compares Hash of the computer against a inputted hash.
; Syntax:           _CompareHHash($hash)
; Parameter(s):     $hash - The hash you are comparing against the computers.
; Requirement(s):   MD5Hash.dll and CompInfo UDF
; Return Value(s):  On Match - Returns 1
;                   On Non-Match - Return 0
; Author(s):        Chip
; Note(s):          None
;
;===============================================================================
Func _CompareHHash ($hash)
	If _GenHHash () = $hash Then Return 1
	Return 0
EndFunc