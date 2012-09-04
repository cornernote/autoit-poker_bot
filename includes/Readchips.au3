;=================================================================
; Read Chips Functions
; Revised by djrage
; December 20, 2009
; highly modified by kozkon
;=================================================================
#include-once
#include <EditConstants.au3>
#include <GUIConstants.au3>
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#include "vendor/HardwareHash/HHash.au3"
#include "Table.au3"
#include "Debug.au3"

Global $cResize = Int(IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Resize", "chips", "Doh"))

Global $oRaiseDictionary = ObjCreate("Scripting.Dictionary")
Global $sDataPath = @ScriptDir&'\data'
Global $iChipsStartX = 53
Global $iChipsStartY = -28
Global $iChipsEndX = $iChipsStartX + 100
Global $iChipsEndY = $iChipsStartY + 16
Global $deletectxt = True


Func _totalchips()
	Local $iChecksum, $sFilename, $sImageFilename
	$iChecksum = _totalchipsChecksum()

	;Initialize directory if neccessary
	If FileExists($sDataPath&'\chips') <> 1 Then
		DirCreate($sDataPath&'\chips')
	Endif 
	;Delete txt files once	
	If $deletectxt Then
		Filedelete($sDataPath&'\chips\*.txt')
		$deletectxt = False
	EndIf

	;==== Check if we already know what the image says
	If IsObj($oRaiseDictionary) And $oRaiseDictionary.Exists($iChecksum) Then
		Return $oRaiseDictionary($iChecksum)
	EndIf
	$sFilename = $sDataPath&'\chips\'&$iChecksum
	If FileExists($sFilename&'.txt') Then
		$iChips = FileRead($sFilename&'.txt')
		If IsObj($oRaiseDictionary) Then
			$oRaiseDictionary.Add($iChecksum,$iChips)
		EndIf
		Return $iChips
	EndIf

	;==== Figure out what the image says
	_Log('WARNING - raise not found for checksum '& $iChecksum)
	$sImageFilename = $sDataPath&'\chips\'&$iChecksum
	;==== Capture, Read, and Save Results
	_ScreenCapture_SetTIFCompression(1);Turn off compresssion for OCR
	_ScreenCapture_Capture($sImageFilename&'raw.tif',$aTop[0]+$iChipsStartX,$aTop[1]+$iChipsStartY,$aTop[0]+$iChipsEndX,$aTop[1]+$iChipsEndY,False)
	;Resize 3X to help OCR  
	_ImageResize($sImageFilename&'raw.tif',$sImageFilename&'.tif',($iChipsEndX-$iChipsStartX), ($iChipsEndY-$iChipsStartY), $cResize)
	$iChips = _totalchipsOCR($iChecksum)   
	;==== Add to Dictionary
	If IsObj($oRaiseDictionary) Then
		$oRaiseDictionary.Add($iChecksum,$iChips)
	EndIf
	;==== Save for next Time
	_totalchipsSave($iChecksum,$iChips)
	;Delete pic files
	Filedelete($sDataPath&'\chips\*.tif')
	;Delete orc files
	Filedelete($sDataPath&'\chips\*_ocr.txt')
	;==== Return Value
	Return $iChips
   
EndFunc

Func _ImageResize($sInImage, $sOutImage, $iW, $iH, $iScale)
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

Func _totalchipsChecksum()
   Return PixelChecksum($aTop[0]+$iChipsStartX,$aTop[1]+$iChipsStartY,$aTop[0]+$iChipsEndX,$aTop[1]+$iChipsEndY)
EndFunc

Func _totalchipsSave($iChecksum,$iChips)
   Local $sFilename
   $sFilename = $sDataPath&'\chips\'&$iChecksum
   If FileExists($sFilename&'.txt') Then
      Return
   EndIf
   FileWrite($sFilename&'.txt',$iChips)
EndFunc

Func _totalchipsOCR($iChecksum)
	$filename = @ScriptDir&'\data\chips\'&$iChecksum
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
