;=================================================================
; Read Raise Functions
; Revised by djrage
; December 20, 2009
; modified by kozkon
;=================================================================
#include-once
#include <EditConstants.au3>
#include <GUIConstants.au3>
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#include "vendor/HardwareHash/HHash.au3"
#include "Table.au3"
#include "Debug.au3"

Global $rResize = Int(IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Resize", "raise", "Doh"))

Global $oRaiseDictionary = ObjCreate("Scripting.Dictionary")
Global $sDataPath = @ScriptDir&'\data'
Global $iRaiseStartX = 382
Global $iRaiseStartY = 408
Global $iRaiseEndX = $iRaiseStartX + 118
Global $iRaiseEndY = $iRaiseStartY + 18
Global $deletertxt = True


Func _rageRaise()
	Local $iChecksum, $sFilename, $sImageFilename
	$iChecksum = _rageRaiseChecksum()

	;Initialize directory if neccessary
	If FileExists($sDataPath&'\raise') <> 1 Then
		DirCreate($sDataPath&'\raise')
	Endif  
	;Delete txt files once
	If $deletertxt Then
		Filedelete($sDataPath&'\raise\*.txt')
		$deletertxt = False
	EndIf

	;==== Check if we already know what the image says
	If IsObj($oRaiseDictionary) And $oRaiseDictionary.Exists($iChecksum) Then
		Return $oRaiseDictionary($iChecksum)
	EndIf
	$sFilename = $sDataPath&'\raise\'&$iChecksum
	If FileExists($sFilename&'.txt') Then
		$iRaise = FileRead($sFilename&'.txt')
		If IsObj($oRaiseDictionary) Then
			$oRaiseDictionary.Add($iChecksum,$iRaise)
		EndIf
		Return $iRaise
	EndIf

	;==== Figure out what the image says
	_Log('WARNING - raise not found for checksum '& $iChecksum)
	$sImageFilename = $sDataPath&'\raise\'&$iChecksum
	;==== Capture, Read, and Save Results
	_ScreenCapture_SetTIFCompression(1);Turn off compresssion for OCR
	_ScreenCapture_Capture($sImageFilename&'raw.tif',$aTop[0]+$iRaiseStartX,$aTop[1]+$iRaiseStartY,$aTop[0]+$iRaiseEndX,$aTop[1]+$iRaiseEndY,False)
	;Resize 4X to help OCR  
	_rageImageResize($sImageFilename&'raw.tif',$sImageFilename&'.tif',($iRaiseEndX-$iRaiseStartX), ($iRaiseEndY-$iRaiseStartY),$rResize)
	$iRaise = _rageRaiseOCR($iChecksum)   
	;==== Add to Dictionary
	If IsObj($oRaiseDictionary) Then
		$oRaiseDictionary.Add($iChecksum,$iRaise)
	EndIf
	;==== Save for next Time
	_rageRaiseSave($iChecksum,$iRaise)
	;Delete pic files
	Filedelete($sDataPath&'\raise\*.tif')
	;Delete orc files
	Filedelete($sDataPath&'\raise\*_ocr.txt')
	;Delete txt files once
	;If $deletertxt Then
		;Filedelete($sDataPath&'\raise\*.txt')
		;$deletertxt = False
	;EndIf
  
	;==== Return Value
	Return $iRaise
	
EndFunc

Func _rageImageResize($sInImage, $sOutImage, $iW, $iH, $iScale)
    ; Initialize GDI+ library
    _GDIPlus_Startup ()
    ; Load image
    $oldImage = _GDIPlus_ImageLoadFromFile ($sInImage)
    ; Create New image
    $GC = _GDIPlus_ImageGetGraphicsContext($oldImage)
    $newBmp = _GDIPlus_BitmapCreateFromGraphics($iW*$iScale, $iH*$iScale, $GC)
    $newGC = _GDIPlus_ImageGetGraphicsContext($newBmp)
    ;Draw
    _GDIPlus_GraphicsDrawImageRect($newGC, $oldImage, 0, 0, $iW*$iScale, $iH*$iScale)
    ; Save image
	$newHBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($newBmp)
	$newImage = _GDIPlus_BitmapCreateFromHBITMAP($newHBmp)
	$tParams = _GDIPlus_ParamInit(2)
	$tData = DllStructCreate("int ColorDepth;int Compression")
	DllStructSetData($tData, "ColorDepth", 24)
	DllStructSetData($tData, "Compression", $GDIP_EVTCOMPRESSIONNONE)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth"))
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
	If IsDllStruct($tParams) Then $pParams = DllStructGetPtr($tParams)
	$sCLSID = _GDIPlus_EncodersGetCLSID('TIF')
	$iResult = _GDIPlus_ImageSaveToFileEx($newImage, $sOutImage, $sCLSID, $pParams)
	; Clean up resources
    _GDIPlus_GraphicsDispose($GC)
    _GDIPlus_GraphicsDispose($newGC)
    _GDIPlus_ImageDispose($oldImage)
    _GDIPlus_BitmapDispose($newBmp)
    _GDIPlus_Shutdown()	
EndFunc

Func _rageRaiseChecksum()
   Return PixelChecksum($aTop[0]+$iRaiseStartX,$aTop[1]+$iRaiseStartY,$aTop[0]+$iRaiseEndX,$aTop[1]+$iRaiseEndY)
EndFunc

Func _rageRaiseSave($iChecksum,$iRaise)
   Local $sFilename
   $sFilename = $sDataPath&'\raise\'&$iChecksum
   If FileExists($sFilename&'.txt') Then
      Return
   EndIf
   FileWrite($sFilename&'.txt',$iRaise)
EndFunc

Func _rageRaiseOCR($iChecksum)
	$filename = @ScriptDir&'\data\raise\'&$iChecksum
	$imgFilename=$filename&'.tif'
	$ocrFilename=$filename&'_ocr'
	
	$rtn=ShellExecuteWait(@ScriptDir&"\includes\vendor\tesseract\tesseract.exe", '"'&$imgFilename&'" "'&$ocrFilename&'"',"","",@SW_HIDE)
	If FileExists($ocrFilename&".txt") Then
		$amount = FileRead($ocrFilename&".txt")
		;$amount = StringReplace($amount, ',', '')  ; remove commas
		;$amount = StringReplace($amount, '.', '')  ; remove commas
		;$amount = StringReplace($amount, '$', '')  ; remove $
		$amount = StringRegExpReplace($amount, "\D", "") ;<----- will strip everything except numbers
		$amount = StringReplace($amount, 'Z', '2') 
	Else
	    $amount = '9999999999';
	EndIf
	Return $amount
EndFunc
