;=================================================================
; Botage Poker Bot
; Copyright © 2009 Brett O'Donnell
;=================================================================
;
; This file is part of Botage Poker Bot.
;
; Botage Poker Bot is free software: you can redistribute it 
; and/or modify it under the terms of the GNU General Public 
; License as published by the Free Software Foundation, 
; either version 3 of the License, or (at your option) any 
; later version.
;
; Botage Poker Bot is distributed in the hope that it will 
; be useful, but WITHOUT ANY WARRANTY; without even the 
; implied warranty of MERCHANTABILITY or FITNESS FOR A 
; PARTICULAR PURPOSE.  See the GNU General Public License 
; for more details.
;
; You should have received a copy of the GNU General Public 
; License along with Botage Poker Bot.  If not, see 
; <http://www.gnu.org/licenses/>.
;
; This program is distributed under the terms of the GNU 
; General Public License.
;
;=================================================================

;=================================================================
; Optical Character Recognition
;=================================================================
#include-once

Func OCRGet($Image)
	OCRGetModi($Image)
EndFunc

Func OCRGetModi($Image)
    Local $sArray[1], $oWord
    
    Local $miDoc = ObjCreate("MODI.Document")
    $miDoc.Create($Image)
    If @error Then Return SetError(1)
    
    $miDoc.Ocr(9, True, False)
    If @error Then Return SetError(2)
    
    For $oWord In $miDoc.Images(0).Layout.Words
        ReDim $sArray[UBound($sArray)+1]
        $sArray[UBound($sArray)-1] = $oWord.Text
    Next
    $sArray[0] = UBound($sArray)-1
    Return $sArray
EndFunc

Func OCRGetTesseract($Image)
	;ShellExecuteWait("C:\Program Files\tesseract\tesseract.exe", $Image&" c:\text")
EndFunc