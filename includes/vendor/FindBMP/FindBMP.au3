;===============================================================================
; Function Name:    findBMP
; Description:    Finds a bitmap (.BMP) in another BMP file (other formats BMP, GIF, JPEG, PNG, TIFF, Exif, WMF, and EMF should work but not tested)
; Syntax:          findBMP($BMP1, $BMP2, $MatchType=TRUE)
;
; Parameter(s):  $BMP1           = Filename of bitmap to search in
;                  $BMP2             = Filename of bitmap to search for
;                  $MatchType       = c24RGBFullMatch, c24RGBPartialMatch, c16RGBFullMatch, c16RGBPartialMatch
;
; Return Value(s):  On Success:   = Returns Array List
;                  On Failure:   = @error 1 (Control was found but there was an error with the DLLCall)
;
; Author(s):        JunkEW
;
; Note(s):
;               * Its never an exact match even with TRUE as last few bits are disposed in algorithm and lines below
;                are not checked under assumption that those are 99.99% of the time correct
;              * locking bits overview http://www.bobpowell.net/lockingbits.htm
; ToDo:
;               * Transparency (when search letters on a different background) http://www.winprog.org/tutorial/transparency.html
;               * Match quicker by doing a bitblt with srcinvert when first line is found (instead of checking line by line)
;               * $BMP1 and $BMP2 to be HBITMAP handle as input instead of filenames (will make searching within partial screen easier)
; Example(s):
;
;===============================================================================
#include-once
#include <GDIPlus.au3>
#Include "../ScreenCapture/ScreenCaptureFixed.au3"
_GDIPlus_Startup()

Const $c24RGBFullMatch = 1 ;Load as 24 bits and full match
Const $c24RGBPartialMatch = 2 ;Load as 24 bits and partial match
Const $c16RGBFullMatch = 3 ;Load as 16 bits and full match
Const $c16RGBPartialMatch = 4 ;Load as 16 bits and partial match

Func _FindBMP($BMP1, $BMP2, $MatchType = $c24RGBFullMatch)
	Dim $fLine[1];Line number of found line(s), redimmed when second picture size is known
	Dim $BMP1Data = "", $BMP1Width = 0, $BMP1Height = 0, $BMP1LineWidth = 0;
	Dim $BMP2Data = "", $BMP2Width = 0, $BMP2Height = 0, $BMP2LineWidth = 0
	Dim $foundAt = "", $matchPossible = False, $matchedLines = 0, $foundAtLeft = -1, $foundAtTop = -1
	Dim $bestMatchLine = -1, $HighestMatchingLines = -1; For knowing when no match is found where best area is
	Dim $iPos = 1;
	Dim $imgBytes;

	Local $iFuzzyDist, $searchFor, $iAbove, $bMatchPossible, $aboveLine
	Local $j, $imgBits

	If ($MatchType = $c24RGBFullMatch) Or ($MatchType = $c24RGBPartialMatch) Then
		$imgBytes = 3
	Else
		$imgBytes = 2
	EndIf

	; Load the bitmap to search in
	_GetImage($BMP1, $BMP1Data, $BMP1Width, $BMP1Height, $BMP1LineWidth, $imgBytes)
	$BMP1Data = BinaryToString($BMP1Data)

	; Load the bitmap to find
	_GetImage($BMP2, $BMP2Data, $BMP2Width, $BMP2Height, $BMP2LineWidth, $imgBytes)
	;Make it strings to be able to use string functions for searching
	$BMP2Data = BinaryToString($BMP2Data)

	;For reference of line where in BMP2FindIn a line of BMP2Find was found
	If $BMP2Height = 0 Then
		SetError(1, 0, 0)
		Return False
	EndIf

	ReDim $fLine[$BMP2Height]

	;If exact match check every 1 line else do it more fuzzy (as most likely other lines are unique)
	If ($MatchType = $c24RGBFullMatch) Or ($MatchType = $c16RGBFullMatch) Then
		$iFuzzyDist = 1
	Else
		;Check fuzzy every 10% of lines
		$iFuzzyDist = Ceiling(($BMP2Height * 0.1))
	EndIf

	$begin = TimerInit()
	;Look for each line of the bitmap if it exists in the bitmap to find in
	For $i = 0 To $BMP2Height - 1
		;Minus imgbytes as last bits are padded with unpredictable bytes (24 bits image assumption) or 2 when 16 bits
		$searchFor = StringMid($BMP2Data, 1 + ($i * $BMP2LineWidth), ($BMP2LineWidth - $imgBytes))
		$iPos = StringInStr($BMP1Data, $searchFor, 2, 1, $iPos)
		;       $iPos = StringInStr($BMP1Data, $searchFor)


		;Look for all lines above if there is also a match
		;Not doing it for the lines below as speed is more important and risk of mismatch on lines below is small
		$iAbove = 1
		If $iPos > 0 Then
			$bMatchPossible = True
			$matchedLines = 1;As first found line is matched we start counting
			;Location of the match
			$foundAtTop = Int($iPos / $BMP1LineWidth) - $i
			$foundAtLeft = Int(Mod($iPos, $BMP1LineWidth) / $imgBytes)
		Else
			$bMatchPossible = False
			ExitLoop
		EndIf

		While (($i + $iAbove) <= ($BMP2Height - 1)) And ($bMatchPossible = True)
			$searchFor = StringMid($BMP2Data, 1 + (($i + $iAbove) * $BMP2LineWidth), ($BMP2LineWidth - $imgBytes))
			$aboveLine = StringMid($BMP1Data, $iPos + ($iAbove * $BMP1LineWidth), ($BMP2LineWidth - $imgBytes))

			If $aboveLine <> $searchFor Then
				$bMatchPossible = False
				;To remember the area with the best match
				If $matchedLines >= $HighestMatchingLines Then
					$HighestMatchingLines = $matchedLines

					;Best guess of location
;~                  $foundAtTop = $fline[$i] + $i - $BMP2Height
					$foundAtTop = Int($iPos / $BMP1LineWidth);+ $i - $BMP2Height
					$bestMatchLine = Int($iPos / $BMP1LineWidth)
				EndIf
				ExitLoop
			EndIf
			$matchedLines = $matchedLines + 1
			$iAbove = $iAbove + $iFuzzyDist
		WEnd

		;If bMatchPossible is still true most likely we have found the bitmap
		If $bMatchPossible = True Then
;~          ConsoleWrite("Could match top: " & $foundAtTop & " left: " & $foundAtLeft & " in " & TimerDiff($begin) / 1000 & "  seconds" & @LF)
			;           MouseMove($foundatleft,$foundatTop)
			ExitLoop
		Else
;~          consolewrite("i not matched " & $ipos & " " & $matchedlines & @crlf )
		EndIf

	Next

	;For some debugging of time
	;   if $bMatchPossible = True Then
	;       ConsoleWrite("Searching took " & TimerDiff($begin) / 1000 & "  seconds " & @LF)
	;   Else
	;       ConsoleWrite("NOT FOUND Searching took " & TimerDiff($begin) / 1000 & "  seconds" & @LF)
	;   endif

	;Return an error if not found else return an array with all information
	If $bMatchPossible = False Then
		SetError(1, 0, 0)
	EndIf
	Return StringSplit($bMatchPossible & ";" & $matchedLines & ";" & $foundAtLeft & ";" & $foundAtTop & ";" & $BMP2Width & ";" & $BMP2Height & ";" & $HighestMatchingLines & ";" & $bestMatchLine, ";")
	;Return $bMatchPossible & ";" & $matchedLines & ";" & $foundAtLeft & ";" & $foundAtTop & ";" & $bmp2width & ";" & $BMP2Height & ";" & $HighestMatchingLines & ";" & $bestMatchLine
EndFunc   ;==>_FindBMP

Func _GetImage($BMPFile, ByRef $BMPDataStart, ByRef $Width, ByRef $Height, ByRef $Stride, $imgBytes = 3)
	Local $Scan0, $pixelData, $hbScreen, $pBitmap, $pBitmapCap, $handle

	; Load the bitmap to search in
	If $BMPFile = "SCREEN" Then
		$hbScreen = _ScreenCapture_Capture("", 0, 0, -1, -1, False)
		$pBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hbScreen); returns memory bitmap
	Else
		;try to get a handle
		$handle = WinGetHandle($BMPFile)
		If @error Then
			;Assume its an unknown handle so correct filename should be given
			$pBitmap = _GDIPlus_BitmapCreateFromFile($BMPFile)
		Else
			$hbScreen = _ScreenCapture_CaptureWnd("", $handle, 0, 0, -1, -1, False)
			$pBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hbScreen); returns memory bitmap
		EndIf
	EndIf

	;Get $tagGDIPBITMAPDATA structure
;~  ConsoleWrite("Bitmap Width:    " & _GDIPlus_ImageGetWidth($pBitmap) & @CRLF )
;~  ConsoleWrite("Bitmap Height:      " & _GDIPlus_ImageGetHeight($pBitmap) & @CRLF)

;~  24 bits (3 bytes) or 16 bits (2 bytes) comparison
	If ($imgBytes = 2) Then
		$BitmapData = _GDIPlus_BitmapLockBits($pBitmap, 0, 0, _GDIPlus_ImageGetWidth($pBitmap), _GDIPlus_ImageGetHeight($pBitmap), $GDIP_ILMREAD, $GDIP_PXF16RGB555)
	Else
		$BitmapData = _GDIPlus_BitmapLockBits($pBitmap, 0, 0, _GDIPlus_ImageGetWidth($pBitmap), _GDIPlus_ImageGetHeight($pBitmap), $GDIP_ILMREAD, $GDIP_PXF24RGB)
	EndIf

	If @error Then MsgBox(0, "", "Error locking region " & @error)

	$Stride = DllStructGetData($BitmapData, "Stride");Stride - Offset, in bytes, between consecutive scan lines of the bitmap. If the stride is positive, the bitmap is top-down. If the stride is negative, the bitmap is bottom-up.
	$Width = DllStructGetData($BitmapData, "Width");Image width - Number of pixels in one scan line of the bitmap.
	$Height = DllStructGetData($BitmapData, "Height");Image height - Number of scan lines in the bitmap.
	$PixelFormat = DllStructGetData($BitmapData, "PixelFormat");Pixel format - Integer that specifies the pixel format of the bitmap
	$Scan0 = DllStructGetData($BitmapData, "Scan0");Scan0 - Pointer to the first (index 0) scan line of the bitmap.

	$pixelData = DllStructCreate("ubyte lData[" & (Abs($Stride) * $Height - 1) & "]", $Scan0)
	$BMPDataStart = $BMPDataStart & DllStructGetData($pixelData, "lData")

	_GDIPlus_BitmapUnlockBits($pBitmap, $BitmapData)
	_GDIPlus_ImageDispose($pBitmap)
	_WinAPI_DeleteObject($pBitmap)
	_WinAPI_DeleteObject($hbScreen)

EndFunc   ;==>_GetImage