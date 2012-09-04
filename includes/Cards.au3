;=================================================================
; Read the Cards
;=================================================================
#include-once
#Include "vendor/ScreenCapture/ScreenCaptureFixed.au3"
#Include "Table.au3"

Global $logScreenCard = Int(IniRead(@ScriptDir & "\settings.ini","Log","log_screen_card", 0))
;Global $oCardDictionary = ObjCreate("Scripting.Dictionary")
;Global $oSuitDictionary = ObjCreate("Scripting.Dictionary")
Global $aTop[2]
Global $ahcc[145][2] = [["2", "2"],[4292041286, "2"],[4155727196, "2"],[4145698108, "2"],[3225901287, "2"],[2490846646, "2"],[2062835569, "2"], _
		[2490126641, "2"],[2008111062, "2"],[691030608, "2"],[144851121, "2"],["3", "3"],[4274995851, "3"],[3902297824, "3"],[3195096962, "3"], _
		[2442747790, "3"],[1623936901, "3"],[1279023836, "3"],[1060851021, "3"],[563626629, "3"],[349856163, "3"],[2496814061, "3"],["4", "4"], _
		[3959644167, "4"],[3942343984, "4"],[3803080155, "4"],[3355861158, "4"],[2947441736, "4"],[1601987526, "4"],[614359447, "4"],[279667127, "4"], _
		[324164610, "4"],[2041800783, "4"],["5", "5"],[4213461048, "5"],[4101528128, "5"],[3952169070, "5"],[3878838530, "5"],[3260439770, "5"], _
		[2238665003, "5"],[2214418871, "5"],[1849972985, "5"],[1785946903, "5"],[1425889399, "5"],[184245739, "5"],["6", "6"], _
		[4029963620, "6"],[3573240389, "6"],[3547552145, "6"],[3409333962, "6"],[2330682233, "6"],[1458917432, "6"],[1320245239, "6"], _
		[953769589, "6"],[799038226, "6"],[129589604, "6"],["7", "7"],[3474418830, "7"],[2572898390, "7"],[2470466104, "7"],[2214159759, "7"], _
		[1947429002, "7"],[1480485613, "7"],[1280000936, "7"],[1273326201, "7"],[1181697599, "7"],[262695388, "7"],["8", "8"], _
		[4293873303, "8"],[3901642172, "8"],[3849740441, "8"],[3631696890, "8"],[3244710992, "8"],[2470795357, "8"],[2016499318, "8"], _
		[1756848814, "8"],[1041976248, "8"],[168516961, "8"],["9", "9"],[3286588631, "9"],[3216529027, "9"],[3021889594, "9"], _
		[2857454538, "9"],[2637781123, "9"],[2068798406, "9"],[1442338387, "9"],[928997967, "9"],[209080007, "9"],[106908873, "9"], _
		["T", "T"],[3939327005, "T"],[2934392575, "T"],[2633126600, "T"],[2519092284, "T"],[2281071245, "T"],[1744259892, "T"],[863132974, "T"], _
		[651384341, "T"],[624317925, "T"],[79978616, "T"],["J", "J"],[3579666919, "J"],[3052692398, "J"],[2948949171, "J"],[2751684093, "J"], _
		[1843941291, "J"],[1372349038, "J"],[856057544, "J"],[503472888, "J"],[461593674, "J"],[142825622, "J"],["Q", "Q"], _
		[3920649990, "Q"],[3326499365, "Q"],[2829403957, "Q"],[2338741465, "Q"],[2091537012, "Q"],[1933662963, "Q"],[1827758363, "Q"], _
		[1390236850, "Q"],[824398363, "Q"],[250305334, "Q"],["K", "K"],[641939608, "K"],[4103099030, "K"],[4009314152, "K"],[3610921459, "K"], _
		[3596114244, "K"],[3205849210, "K"],[3089650926, "K"],[1540771179, "K"],[1004756581, "K"],[519920213, "K"],[463099779, "K"], _
		["A", "A"],[3762379904, "A"],[3361431545, "A"],[2937474195, "A"],[2544589679, "A"],[2493933299, "A"],[1989632619, "A"], _
		[1657104095, "A"],[1268539918, "A"],[1079077429, "A"],[1013274209, "A"]]

Global $ahcs[16][2] = [["C", "C"],[1719343027, "c"],[2455775269, "c"],["D", "D"],[2498901370, "d"],[3275902104, "d"],["H", "H"], _
		[2495230642, "h"],[3866447638, "h"],["S", "S"],[1384652630, "s"],[4204726204, "s"]]




Func _Cards($iSeat)
	Local $aCards[7], $aSuits[7]

	If $aTop[0] == False Then
		Return False
	EndIf
	If $iSeat < 1 Then
		Return False
	EndIf

	; table card locations
	Local $aTableCard1_XY[2]
	Local $aTableCard2_XY[2]
	Local $aTableCard3_XY[2]
	Local $aTableCard4_XY[2]
	Local $aTableCard5_XY[2]

	; seat card locations
	Local $aSeatCard1_XY[9][2]
	Local $aSeatCard2_XY[9][2]

	; seat 1
	$aSeatCard1_XY[0][0] = 527
	$aSeatCard1_XY[0][1] = 33
	$aSeatCard2_XY[0][0] = 552
	$aSeatCard2_XY[0][1] = 33

	; seat 2
	$aSeatCard1_XY[1][0] = 637
	$aSeatCard1_XY[1][1] = 83
	$aSeatCard2_XY[1][0] = 662
	$aSeatCard2_XY[1][1] = 83

	; seat 3
	$aSeatCard1_XY[2][0] = 647
	$aSeatCard1_XY[2][1] = 205
	$aSeatCard2_XY[2][0] = 672
	$aSeatCard2_XY[2][1] = 205

	; seat 4
	$aSeatCard1_XY[3][0] = 527
	$aSeatCard1_XY[3][1] = 278
	$aSeatCard2_XY[3][0] = 552
	$aSeatCard2_XY[3][1] = 278

	; seat 5
	$aSeatCard1_XY[4][0] = 402
	$aSeatCard1_XY[4][1] = 283
	$aSeatCard2_XY[4][0] = 427
	$aSeatCard2_XY[4][1] = 283

	; seat 6
	$aSeatCard1_XY[5][0] = 182
	$aSeatCard1_XY[5][1] = 277
	$aSeatCard2_XY[5][0] = 207
	$aSeatCard2_XY[5][1] = 277

	; seat 7
	$aSeatCard1_XY[6][0] = 62
	$aSeatCard1_XY[6][1] = 205
	$aSeatCard2_XY[6][0] = 87
	$aSeatCard2_XY[6][1] = 205

	; seat 8
	$aSeatCard1_XY[7][0] = 61
	$aSeatCard1_XY[7][1] = 82
	$aSeatCard2_XY[7][0] = 86
	$aSeatCard2_XY[7][1] = 82

	; seat 9
	$aSeatCard1_XY[8][0] = 182
	$aSeatCard1_XY[8][1] = 33
	$aSeatCard2_XY[8][0] = 207
	$aSeatCard2_XY[8][1] = 33

	; table card 1
	$aTableCard1_XY[0] = 287
	$aTableCard1_XY[1] = 134

	; table card 2
	$aTableCard2_XY[0] = 327
	$aTableCard2_XY[1] = 134

	; table card 3
	$aTableCard3_XY[0] = 367
	$aTableCard3_XY[1] = 134

	; table card 4
	$aTableCard4_XY[0] = 407
	$aTableCard4_XY[1] = 134

	; table card 5
	$aTableCard5_XY[0] = 447
	$aTableCard5_XY[1] = 134

	; get the numbers
	$aCards[0] = _CardNumber($aTop[0]+$aSeatCard1_XY[$iSeat-1][0],$aTop[1]+$aSeatCard1_XY[$iSeat-1][1])
	$aCards[1] = _CardNumber($aTop[0]+$aSeatCard2_XY[$iSeat-1][0],$aTop[1]+$aSeatCard2_XY[$iSeat-1][1])
	$aCards[2] = _CardNumber($aTop[0]+$aTableCard1_XY[0],$aTop[1]+$aTableCard1_XY[1])
	$aCards[3] = _CardNumber($aTop[0]+$aTableCard2_XY[0],$aTop[1]+$aTableCard2_XY[1])
	$aCards[4] = _CardNumber($aTop[0]+$aTableCard3_XY[0],$aTop[1]+$aTableCard3_XY[1])
	$aCards[5] = _CardNumber($aTop[0]+$aTableCard4_XY[0],$aTop[1]+$aTableCard4_XY[1])
	$aCards[6] = _CardNumber($aTop[0]+$aTableCard5_XY[0],$aTop[1]+$aTableCard5_XY[1])

	; get the suits
	$aSuits[0] = _CardSuit($aTop[0]+$aSeatCard1_XY[$iSeat-1][0],$aTop[1]+$aSeatCard1_XY[$iSeat-1][1])
	$aSuits[1] = _CardSuit($aTop[0]+$aSeatCard2_XY[$iSeat-1][0],$aTop[1]+$aSeatCard2_XY[$iSeat-1][1])
	$aSuits[2] = _CardSuit($aTop[0]+$aTableCard1_XY[0],$aTop[1]+$aTableCard1_XY[1])
	$aSuits[3] = _CardSuit($aTop[0]+$aTableCard2_XY[0],$aTop[1]+$aTableCard2_XY[1])
	$aSuits[4] = _CardSuit($aTop[0]+$aTableCard3_XY[0],$aTop[1]+$aTableCard3_XY[1])
	$aSuits[5] = _CardSuit($aTop[0]+$aTableCard4_XY[0],$aTop[1]+$aTableCard4_XY[1])
	$aSuits[6] = _CardSuit($aTop[0]+$aTableCard5_XY[0],$aTop[1]+$aTableCard5_XY[1])

	; convert to card string
	$sCards = _CardString($aCards,$aSuits)

	Return $sCards
EndFunc


Func _CardNumber($x, $y)
	Local $iChecksum = PixelChecksum($x - 2, $y - 2 + 14, $x + 10, $y + 14)
	Local $iChecksum2 = PixelChecksum($x - 2, $y, $x + 10, $y + 2)
	Local $sCard
	For $i = 0 To UBound($ahcc) - 1
		If $iChecksum = $ahcc[$i][0] Then
			$sCard = $ahcc[$i][1]
		EndIf
	Next
	For $i = 0 To UBound($ahcc) - 1
		If $iChecksum2 = $ahcc[$i][0] Then
			$sCard = $ahcc[$i][1]
		EndIf
	Next
	Return $sCard

	; unknown card
	If $logScreenCard <> 0 Then
		$sImageFilename = $sLogPath & '\card\' & $iChecksum
		_ScreenCapture_Capture($sImageFilename & '.tif', $x - 2, $y - 2, $x + 10, $y + 14, False)
	EndIf

;	If IsObj($oCardDictionary) Then
;		$oCardDictionary.Add($iChecksum, False)
;	EndIf
	Return False
EndFunc   ;==>_CardNumber

; get a suit based on a x/y location
Func _CardSuit($x, $y)
	Local $iChecksum = PixelChecksum($x, $y + 20, $x + 6, $y + 20 + 6)
	Local $sSuit
	For $i = 0 To UBound($ahcs) - 1
		If $iChecksum = $ahcs[$i][0] Then
			$sSuit = $ahcs[$i][1]
		EndIf
	Next

	Return $sSuit

	; unknown suit
	If $logScreenCard <> 0 Then
		$sImageFilename = $sLogPath & '\suit\' & $iChecksum
		_ScreenCapture_Capture($sImageFilename & '.tif', $x - 10, $y + 20 - 10, $x + 6 + 10, $y + 20 + 6 + 10, False)
	EndIf

EndFunc   ;==>_CardSuit

Func _CardString($aCards,$aSuits)
	Local $sCards
	If ($aCards[0]<>False And $aCards[1]<>False) Or ($aCards[2]<>False) Then
		If $aCards[0]<>False And $aCards[1]<>False Then
			$sCards = $aCards[0] & $aSuits[0] & ' ' & $aCards[1] & $aSuits[1]
		Else
			$sCards = '-- --'
		EndIf
		If $aCards[2]<>False And $aCards[3]<>False And $aCards[4]<>False Then
			$sCards = $sCards & ' ' & $aCards[2] & $aSuits[2] & ' ' & $aCards[3] & $aSuits[3] & ' ' & $aCards[4] & $aSuits[4]
			If $aCards[5]<>False Then
				$sCards = $sCards & ' ' & $aCards[5] & $aSuits[5]
				If $aCards[6]<>False Then
					$sCards = $sCards & ' ' & $aCards[6] & $aSuits[6]
				EndIf
			EndIf
		EndIf
	EndIf
	Return $sCards
EndFunc

Func _CardNumbersArray($sCards)
	Local $aCards[7]
	Local $aCardsTmp = StringSplit($sCards,' ',1)
	For $i = 0 To UBound($aCardsTmp)-1
		If $i>0 Then
			$aCards[$i-1] = StringLeft($aCardsTmp[$i],1)
		EndIf
	Next
	Return $aCards
EndFunc

Func _CardSuitsArray($sCards)
	Local $aSuits[7]
	Local $aSuitsTmp = StringSplit($sCards,' ',1)
	For $i = 0 To UBound($aSuitsTmp)-1
		If $i>0 Then
			$aSuits[$i-1] = StringRight($aSuitsTmp[$i],1)
		EndIf
	Next
	Return $aSuits
EndFunc
