;Blind.au3
;=================================================================
; Read Blind Functions
; Revised by Fredson.
; December 20, 2009
;=================================================================
#include-once
#include <EditConstants.au3>
#include <GUIConstants.au3>
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#include "vendor/HardwareHash/HHash.au3"
#include "Table.au3"
#include "Debug.au3"
Global $oBlindDictionary = ObjCreate("Scripting.Dictionary")
Global $logScreenBlind = Int(IniRead(@ScriptDir & "\settings.ini","Log","log_screen_blind", 0))
Global $sDataPath = '../data'
Global $sLogPath = '../log'
Func _Blind()
   Local $iChecksum, $sFilename, $sImageFilename
   $iChecksum = _BlindChecksum()
   If IsObj($oBlindDictionary) And $oBlindDictionary.Exists($iChecksum) Then
      Return $oBlindDictionary.Item($iChecksum)
   EndIf
   If FileExists($sDataPath&'\blind') <> 1 Then
      DirCreate($sDataPath&'\blind')
   Endif
   $sFilename = $sDataPath&'\blind\'&$iChecksum
   If FileExists($sFilename&'.txt') Then
      $iBlind = FileRead($sFilename&'.txt')
      If IsObj($oBlindDictionary) Then
         $oBlindDictionary.Add($iChecksum,$iBlind)
      EndIf
      Return $iBlind
   EndIf
   _Log('WARNING - blind not found for checksum '& $iChecksum)
   If $logScreenBlind Then
      $sImageFilename = $sLogPath&'\blind\'&$iChecksum
      If FileExists($sLogPath&'\blind') <> 1 Then
         DirCreate($sLogPath&'\blind')
      Endif
      _ScreenCapture_Capture($sImageFilename&'.jpg',$aTop[0]+696,$aTop[1]+305,$aTop[0]+754,$aTop[1]+320,False)
      $iBlind = _BlindChoose($iChecksum)
      If IsObj($oBlindDictionary) Then
         $oBlindDictionary.Add($iChecksum,$iBlind)
      EndIf
      Return $iBlind
   EndIf
   Return 0
EndFunc
Func _BlindChecksum()
   Return PixelChecksum($aTop[0]+696,$aTop[1]+305,$aTop[0]+754,$aTop[1]+320)
EndFunc
Func _BlindSave($iBlind, $iChecksum)
   $sFilename = $sDataPath&'\blind\'&$iChecksum
   If FileExists($sFilename&'.txt') Then
      Return
   EndIf
   FileWrite($sFilename&'.txt',$iBlind)
EndFunc
Func _BlindChoose($iChecksum)
    Local $guiBlind, $guiBlindOptions[3], $msg, $iBlind, $sFilename
   $iBlind = 0
   $sFilename = $sLogPath&'\blind\'&$iChecksum
   $guiBlind = GUICreate("Unknown Blind", 200, 100, @DesktopWidth-250, @DesktopHeight-400)
    $guiBlindOptions[0] = GUICtrlCreatePic ($sFilename&'.jpg', 35, 25, 58, 15)
    $guiBlindOptions[1] = GUICtrlCreateInput ("enter big blind", 35, 45, 120, 20, $ES_NUMBER)
    $guiBlindOptions[2] = GUICtrlCreateButton("Save", 35, 65, 120, 20)
    GUISetState()
   ; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()
      If $msg = $GUI_EVENT_CLOSE Then
         ExitLoop
      EndIf
      If $msg = $guiBlindOptions[2] Then
         $iBlind = GUICtrlRead($guiBlindOptions[1])
         _BlindSave($iBlind, $iChecksum)
         ExitLoop
      EndIf
   WEnd
   GUISetState(@SW_HIDE, $guiBlind)
    GUIDelete()
   Return $iBlind
EndFunc 