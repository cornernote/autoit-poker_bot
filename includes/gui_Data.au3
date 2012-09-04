#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\pokerbot\pokerbot\GUI_Data.kxf

global $GUIDATA_Moved

$width =280
$height =380
$GUIdata_frmData = GUICreate("djbarnes",$width ,$height, @DesktopWidth-$width-4 ,-5 ,$WS_SYSMENU+$WS_SIZEBOX)
GUISetOnEvent($GUI_EVENT_CLOSE, "_GUI_Data_Close",$GUIdata_frmData)
$Guidata_oIEHand = _IECreateEmbedded()
$GUIdata_IEHand = GUICtrlCreateObj($Guidata_oIEHand, 0, 160, 280, 200)
GUICtrlSetResizing ($GUIdata_IEHand,$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM)
_IENavigate ($Guidata_oIEHand, "about:blank")
;$Guidata_oIEHand.Document.parentwindow.Scroll (0, 14)
;_IEDocWriteHTML($Guidata_oIEHand,"<body bgcolor=""FFFFFF""></body>")

;PASTE BELOW
$Label1 = GUICtrlCreateLabel("Chips:", 0, 4, 33, 17)
$GUIdata_InputChips = GUICtrlCreateInput("", 40, 0, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Stack:", 0, 52, 35, 17)
$GUIdata_InputProfit = GUICtrlCreateInput("", 40, 24, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$GUIdata_InputStack = GUICtrlCreateInput("", 40, 48, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("$/Hour:", 0, 28, 40, 17)
$Label4 = GUICtrlCreateLabel("Blinds:", 0, 124, 40, 17)
$GUIdata_InputBlinds = GUICtrlCreateInput("", 40, 120, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$GUIdata_chkInRoom = GUICtrlCreateCheckbox("InRoom", 188, 0, 80, 17, BitOR($BS_CHECKBOX,$BS_FLAT,$WS_TABSTOP))
$label5 = GUICtrlCreateLabel("Pot:", 0, 76, 40, 17)
$GUIdata_InputPot = GUICtrlCreateInput("", 40, 72, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$GUIdata_chkSitting = GUICtrlCreateCheckbox("Sitting", 188, 20, 80, 17, BitOR($BS_CHECKBOX,$BS_FLAT,$WS_TABSTOP))
$GUIdata_InputMyPot = GUICtrlCreateInput("", 40, 96, 145, 24, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel("MyPot:", 0, 100, 40, 17)
$GUIdata_chkInHand = GUICtrlCreateCheckbox("Cards", 188, 40, 80, 17, BitOR($BS_CHECKBOX,$BS_FLAT,$WS_TABSTOP))
$GUIdata_chkNeedToBank = GUICtrlCreateCheckbox("NeedToBank", 188, 60, 88, 17, BitOR($BS_CHECKBOX,$BS_FLAT,$WS_TABSTOP))
;PASTE ABOVE

WinSetOnTop($GUIdata_frmData,"",true)

;while 1
;WEnd

func _GUI_Data_Move()
	If Not IsHWnd ($GUIdata_frmData) Then Return
	If not $GUIDATA_Moved and $aTablePosition[0] Then
		_browserReposition()
		$iTimeout = 0
		While Not $aTablePosition[0]
			Sleep (100)
			$iTimeout += 1
			_findTable()
			If $iTimeout > 10 Then ExitLoop
		WEnd
		If $aTablePosition[0] Then ;if we can still see the table after moving the browser...
			GUISetState(@SW_SHOW,$GUIdata_frmData)
			$BotTimer = TimerInit()
			$GUIDATA_Moved = true
			if IsHWnd($GUIdata_frmData) Then
				WinMove ($GUIdata_frmData,"",$aTablePosition[0]+758,-4 )
			endif
			if IsHWnd($ConsoleGUI) then
				$guidataPOS = WinGetPos ($GUIdata_frmData)
				$ConsoleGUIPOS = WinGetPos($ConsoleGUI)
				WinMove($ConsoleGUI,"",$aTablePosition[0]+758,$guidataPOS[1]+$guidataPOS[3],@DesktopWidth-$aTablePosition[0]-758,@DesktopHeight-$guidataPOS[1]-$guidataPOS[3])
			endif
		EndIf
	EndIf
EndFunc

Func _GUI_Data_Close()
	Exit
EndFunc


func _GUIData_UpdateStatistics()
	WinSetTitle($GUIdata_frmData,"",_Stringtime(TimerDiff($BotTimer)))
	_OCRTotalChips()
	guictrlsetdata ($GUIdata_InputChips,_stringChips($global_mytotalchips))
	$col = "0x"&_htmlColorGoodOrBad2(_MyProfitPerHour()/$global_Blind,-110,100)
		If $col <> 0 Then GUICtrlSetBkColor ($GUIdata_InputProfit,$col)
	guictrlsetdata ($GUIdata_InputProfit,_stringChips(_MyProfitPerHour()))
	guictrlsetdata ($GUIdata_InputBlinds,_stringChips($global_Blind,1))
	;guictrlsetdata ($GUIdata_lblCurrentHand,$global_hand)
	$html = ""
	if $global_hand <> "" then
		$html &= _htmlhand($global_hand,4) &"<br>"
	endif
	if $aTablePosition[0] Then
		guictrlsetdata ($GUIdata_InputStack,_stringChips($global_myStack))
		GUICtrlSetData ($GUIdata_InputPot,_stringChips(_potLastAction()))
		GUICtrlSetState ( $GUIdata_chkInRoom,$GUI_CHECKED)
	Else
		guictrlsetdata ($GUIdata_InputStack,"")
		GUICtrlSetData ($GUIdata_InputPot,"")
		GUICtrlSetState ( $GUIdata_chkInRoom,$GUI_UNCHECKED)
	endif

	if $global_Seat <> 0 Then
		$seatExt = ""
		If $iseatnumber > 0 Then $seatExt = " ("&$iseatnumber&"/"&$global_Opponents&")"
		GUICtrlSetData ($GUIdata_chkSitting,"Seat "&$global_Seat&$seatext)
		GUICtrlSetState ( $GUIdata_chkSitting,$GUI_CHECKED)
	Else
		GUICtrlSetData ($GUIdata_chkSitting,"Sitting")
		GUICtrlSetState ( $GUIdata_chkSitting,$GUI_UNCHECKED)
	endif

	If _NeedToBank() Then
		GUICtrlSetState ( $GUIdata_chkNeedToBank,$GUI_CHECKED)
	Else
		GUICtrlSetState ( $GUIdata_chkNeedToBank,$GUI_UNCHECKED)
	EndIf

	if $bHandAlive then
		guictrlsetdata ($GUIdata_InputMyPot,_stringChips(_PotContribution(),1))
		$html &= "["&_HandRankToString(_Handrank($global_hand))&"]<br>"
		$html &="Strength: "&round (_handCurrentStrength()*100)&"%<br>"
		$html &="Potential: "&round(_handPotential()*100)&"%<br>"
		$html &="WinOdds:"&round(_handWinOdds()*100)&"%<br>"
		$html &="Position: " &$iseatnumber&"/"&$global_Opponents+1&" ("&round($iseatvalue,2)&")<br>"
		GUICtrlSetState($GUIdata_chkInHand,$GUI_CHECKED)
		guictrlsetdata ($GUIdata_chkInHand,$global_street)
	Else
		guictrlsetdata ($GUIdata_InputMyPot,"")
		$html &= _DebugShowOpponentData(False)
		GUICtrlSetState($GUIdata_chkInHand,$GUI_UNCHECKED)
		guictrlsetdata ($GUIdata_chkInHand,"Cards")
	endif
	_IEBodyWriteHTML($Guidata_oIEHand,$html)
EndFunc

func _stringChips($ChipCount,$hideBlinds=0)
	$ChipCount = Round($ChipCount)
	$negative = ""
	$stmpChipCount = $ChipCount
	if StringLeft($stmpChipCount,1) = "-" then
		$negative = "-"
		$stmpChipCount = StringTrimLeft($stmpChipCount,1)
	endif
	$tmp = ""
	for $i = 1 to Ceiling(stringlen ($stmpChipCount)/3)
		$tmp = "," & StringRight($stmpChipCount,3)&$tmp
		$stmpChipCount = StringTrimRight($stmpChipCount,3)
	next
	$bb = ""
	if $global_Blind > 0 and not $hideBlinds Then
		$bb = " ("&round(($ChipCount/$global_Blind),1)&"bb)"
	endif
	return  $negative& StringTrimLeft($tmp,1)&$bb
EndFunc

Func _Stringtime($timer)
$timer /= 1000 ;convert to seconds
	If $timer < 90 Then
		Return Round($timer) &" seconds"
	ElseIf $timer < 90*60 Then ;mins
		Return Round($timer/60,1) &" minutes"
	Else
		Return Round($timer/60/60,1) &" hours"
	EndIf
EndFunc
