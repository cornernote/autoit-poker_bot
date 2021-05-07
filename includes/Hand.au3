;=================================================================
; Hand Evaluation Functions
;=================================================================
#include-once


Func _Hand()
   Local $hand
   If ($cards[0][0]<>False And $cards[1][0]<>False) Or ($cards[2][0]<>False) Then
      If $cards[0][0]<>False And $cards[1][0]<>False Then
         $hand = $cards[0][0] & $cards[0][1] & ' ' & $cards[1][0] & $cards[1][1]
      Else
         $hand = '-- --'
      EndIf
      If $cards[2][0]<>False And $cards[3][0]<>False And $cards[4][0]<>False Then
         $hand = $hand & ' ' & $cards[2][0] & $cards[2][1] & ' ' & $cards[3][0] & $cards[3][1] & ' ' & $cards[4][0] & $cards[4][1]
         If $cards[5][0]<>False Then
            $hand = $hand & ' ' & $cards[5][0] & $cards[5][1]
            If $cards[6][0]<>False Then
               $hand = $hand & ' ' & $cards[6][0] & $cards[6][1]
            EndIf
         EndIf
      EndIf
   EndIf
   Return $hand
EndFunc


Func _HandEval($hand, $nopponents)
   If Not $hand Then Return 0
   If $hand=='' Then Return 0
   If StringInStr($hand,'-') Then Return 0
   Local $path = @ScriptDir & '\data\hand'
   Local $filename = $path&'\'&StringReplace($hand,' ','-')&'_'&$nopponents&'.txt'
   If FileExists($filename) Then Return FileRead($filename)
   $dll = DllOpen ("includes/vendors/PSIM/psim.dll")
   If $dll = -1 Then Return False
   $simResultsStruct = "float win; float tie; float lose; float winSd; float tieSd; float loseSd; float d94; float d90; int evaluations"
   $simResults = DllStructCreate($simResultsStruct)
   $result = DllCall($dll, "none", "SimulateHandMulti", "str", $hand, "ptr", DllStructGetPtr($simResults), "uint", 600, "uint", 400, "uint", $nopponents)
   DllClose($dll)
      DirCreate($path)
   If @error <> 0 then
      FileWrite($filename,0)
      Return 0
   Endif
   $score = Round(DllStructGetData($simResults, "winSd") + DllStructGetData($simResults, "tieSd"),2)
   FileWrite($filename, $score)
   Return $score
EndFunc