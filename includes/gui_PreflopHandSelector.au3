#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>
#Include <Color.au3>
#Include <Misc.au3>
#include <array.au3>
global const $sLookupCards = StringSplit("AKQJT98765432","")
global const $lookup_All_In =500
global const $lookup_Raise = 400
global const $lookup_Call_Any = 300
global const $lookup_Call_UpTo =250
global const $lookup_Call_Once =200
global const $psimDLLpath = @ScriptDir&"\includes\vendor\psim\psim.dll" ;edit if required
global const $startingHandsINIpath = @ScriptDir&"\data\startinghands.ini" ;edit if required
global const $PocketPairDealtOdds = (4/52) * (3/51) ;don't include the same card twice
global const $UnsuitedDealtOdds = (4/52) * (3/51)*2 ;don't include the suited card - and *2 is AK or KA
global const $SuitedDealtOdds = (4/52) * (1/51)*2 ;don't include the unsited cards - and *2 is AK or KA
if not FileExists ($psimDLLpath) Then
	msgbox (16,"ERROR","Cannot find "&$psimDLLpath)
	exit
endif
if not FileExists ($startingHandsINIpath) Then
	msgbox (16,"ERROR","Cannot find "&$startingHandsINIpath)
	exit
endif

func _SelectPreflopHand($filename)
	local $IniType = _DetectIni($filename)
	$StartingHandArray = _PreFlopHands_LoadFromIni($iniType,$filename)
	if not IsArray($StartingHandArray) then return ;failed to load!
	_frmPreflopHandSelector($iniType,$filename,$StartingHandArray)
EndFunc

func _PreFlopHands_LoadFromIni($iniType,$filename)
	Switch $iniType
		case "zbot 6"
			return _ImportZBot6Ini($filename)
		case "djbarnes 1.0"
			return _ImportdjbarnesIni($filename)
		case Else
			msgbox (16,"ERROR","Sorry the file "&$filename&" is of an unsupported Ini format ("&$IniType&")")
			return
	EndSwitch
EndFunc

func _PreFlopHands_SaveToIni($IniType,$filename,$StartingHandArray)
	Switch $iniType
		case "zbot 6"
			return _ExportZBot6Ini($filename,$StartingHandArray)
		case "djbarnes 1.0"
			return _ExportdjbarnesIni($filename,$StartingHandArray)
	EndSwitch
EndFunc

func _ImportdjbarnesIni($filename)
	;TODO
EndFunc

func _ExportdjbarnesIni($filename,$StartingHandArray)
	;TODO
EndFunc


func _ImportZBot6Ini($filename)
	local $startingHandArray[170]
	$allIn = StringSplit(IniRead($filename,"Preflop_hands","all_in","")," ")
	_StartingHandArray_Add($startingHandArray,$allIn,$lookup_All_In)
	$raise = StringSplit(IniRead($filename,"Preflop_hands","raise","")," ")
	_StartingHandArray_Add($startingHandArray,$raise,$lookup_Raise)
	$call_any = StringSplit(IniRead($filename,"Preflop_hands","call_any","")," ")
	_StartingHandArray_Add($startingHandArray,$call_any,$lookup_Call_Any)
	$call_upto = StringSplit(IniRead($filename,"Preflop_hands","call_upto","")," ")
	_StartingHandArray_Add($startingHandArray,$call_upto,$lookup_Call_UpTo)
	$call_once = StringSplit(IniRead($filename,"Preflop_hands","call_once","")," ")
	_StartingHandArray_Add($startingHandArray,$call_once,$lookup_Call_Once)
	$suitedallIn = StringSplit(IniRead($filename,"Suited_hands","all_in","")," ")
	_StartingHandArray_AddSuited($startingHandArray,$suitedallIn,$lookup_All_In)
	$suitedraise = StringSplit(IniRead($filename,"Suited_hands","raise","")," ")
	_StartingHandArray_AddSuited($startingHandArray,$suitedraise,$lookup_Raise)
	$suitedcall_any = StringSplit(IniRead($filename,"Suited_hands","call_any","")," ")
	_StartingHandArray_AddSuited($startingHandArray,$suitedcall_any,$lookup_Call_Any)
	$suitedcall_upto = StringSplit(IniRead($filename,"Suited_hands","call_upto","")," ")
	_StartingHandArray_AddSuited($startingHandArray,$suitedcall_upto,$lookup_Call_UpTo)
	$suitedcall_once = StringSplit(IniRead($filename,"Suited_hands","call_once","")," ")
	_StartingHandArray_AddSuited($startingHandArray,$suitedcall_once,$lookup_Call_Once)
	return $startingHandArray
EndFunc

func _StartingHandArray_Add(byref $startingHandArray, $aStartingcards,$value)
	for $i = 1 to $aStartingcards[0]
		$HandID = _LookupHandID($aStartingcards[$i]&"o")
		$startingHandArray[$HandID] =$value
	next
	;now add them to the suited list too :)
	return _StartingHandArray_AddSuited($startingHandArray,$aStartingcards,$value)
EndFunc

func _StartingHandArray_AddSuited(byref $startingHandArray,$aStartingcards,$value)
	for $i = 1 to $aStartingcards[0]
		$HandID = _LookupHandID($aStartingcards[$i]&"s")
		$startingHandArray[$HandID] =$value
	next
EndFunc

func _ExportZBot6Ini($filename,$StartingHandArray)
	$allin = _getHandString ($StartingHandArray,$lookup_All_In)
	IniWrite($filename,"Preflop_hands","all_in",$allIn[0])
	IniWrite($filename,"Suited_hands","all_in",$allIn[1])
	$raise = _getHandString ($StartingHandArray,$lookup_Raise)
	IniWrite($filename,"Preflop_hands","raise",$raise[0])
	IniWrite($filename,"Suited_hands","raise",$raise[1])
	$call_any = _getHandString ($StartingHandArray,$lookup_Call_Any)
	IniWrite($filename,"Preflop_hands","call_any",$call_any[0])
	IniWrite($filename,"Suited_hands","call_any",$call_any[1])
	$call_upto = _getHandString ($StartingHandArray,$lookup_Call_UpTo)
	IniWrite($filename,"Preflop_hands","call_upto",$call_upto[0])
	IniWrite($filename,"Suited_hands","call_upto",$call_upto[1])
	$call_once = _getHandString ($StartingHandArray,$lookup_Call_Once)
	IniWrite($filename,"Preflop_hands","call_once",$call_once[0])
	IniWrite($filename,"Suited_hands","call_once",$call_once[1])
EndFunc

func _getHandString(ByRef $handArray,$value)
	local $nonSuited = ""
	local $Suited = ""
	local $tempSuited
	for $iCard1 = 1 to 13
		for $iCard2 = 1 to 13
			$id = (($iCard1-1)*13) + $iCard2
			if $handArray[$id] = $value then
				if $iCard1 <$iCard2 then ;unsuited, 1 is ace, 13 is 2
					$sTempHand= _lookupCard($iCard1)&_lookupCard($iCard2)
					$tempSuited = false
				elseif $iCard1 > $iCard2 then ;suited
					$sTempHand =_lookupCard($iCard2)&_lookupCard($iCard1)
					$tempSuited = true
				else ;pocket pair
					$sTempHand =_lookupCard($iCard1)&_lookupCard($iCard2)
					$tempSuited = false
				endif
				if $tempSuited Then
					$Suited &=$sTempHand&" "
				Else
					$nonSuited &=$sTempHand&" "
				endif
				$handArray[$id] = 0 ;remove from array as we have now processed them (suited and unsuited)
			endif
		Next
	next
	local $returnarray[2]
	$returnarray[0] = StringStripWS($nonSuited,2)
	$returnarray[1] = StringStripWS($suited,2)
	return $returnarray
EndFunc

func _frmPreflopHandSelector($iniType,$filename,byref $StartingHandArray)
	local $sHandIndex[13*13+1] ;there are 13x13 starting hands (A-2 x A-2)
	local $btnHandIndex[13*13+1] ;the buttons that correspond with the above
	local $winOddsIndex[13*13+1] ;the chance of winning vs 3 people

	$SelectedAction = 0
	$title = IniRead(@ScriptDir&"\settings.ini", "General", "PreFlopHandSelectorWindowTitle","Pokerbot: Preflop Hand Selector")
	$frmPreFlopHandSelector = GUICreate ($title,600,350)

	ProgressOn("Loading Card Odds","hand 0/169:","0 %",-1,-1,18)
	$Progresstimer = TimerInit()
	for $iCard1 = 1 to 13
		for $iCard2 = 1 to 13
			$tip = ""
			if $iCard1 <$iCard2 then ;unsuited, 1 is ace, 13 is 2
				$tip = _lookupCard($iCard1)&_lookupCard($iCard2)&" offsuit"
				$sTempHand= _lookupCard($iCard1)&_lookupCard($iCard2)&"o"
			elseif $iCard1 > $iCard2 then ;suited
				$tip = _lookupCard($iCard2)&_lookupCard($iCard1)&" suited"
				$sTempHand =_lookupCard($iCard2)&_lookupCard($iCard1)&"s"
			else ;pocket pair
				$tip = "Pocket "&_lookupCard($iCard1)&_lookupCard($iCard1)
				$sTempHand =_lookupCard($iCard1)&_lookupCard($iCard2)
			endif
			$id = (($iCard1-1)*13) + $iCard2
			$sHandIndex[$id] =$sTempHand ;put it in the array
			if TimerDiff($Progresstimer) > 25 then
				$Progresstimer = TimerInit()
				$percent =round(100/169*$id)
				ProgressSet($percent,$percent&"%","hand "&$id&"/169: "&$sTempHand)
			endif
			$btnHandIndex[$id] = GUICtrlCreateButton ($sTempHand,($iCard1-1)*27,($iCard2-1)*27,26,26)
			$winOddsIndex[$id] = _StartingCardsWinOdds($sHandIndex[$id])
			GUICtrlSetTip(-1,"Win Odds "&round($winOddsIndex[$id]*100,2)&"% vs 3 Opponents",$tip&" odds",1,1)
			_ColorButton($id,$sHandIndex,$btnHandIndex,$winOddsIndex,$StartingHandArray)
		Next
	next
	$lblSelected = GUICtrlCreateInput ("Select:",360,7,70,25, $ES_READONLY)
	$lblOdds = GUICtrlCreateLabel ("Odds of being Dealt",435,7,70,25,$ES_READONLY)
	$lblOddsAllIn = GUICtrlCreateInput ("0 %",435,35,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from this group")
	$lblOddsRaise = GUICtrlCreateInput ("0 %",435,60,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from this group")
	$lblOddsCallAny = GUICtrlCreateInput ("0 %",435,85,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from this group")
	$lblOddsCallUpTo = GUICtrlCreateInput ("0 %",435,110,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from this group")
	$lblOddsCallOnce = GUICtrlCreateInput ("0 %",435,135,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from this group")
	$lblOddstotal = GUICtrlCreateInput ("0 %",435,160,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will be dealt a card from the groups above")

	$lblWinOdds = GUICtrlCreateLabel ("Win Chance",510,7,70,25,$ES_READONLY)
	$lblWinOddsAllIn = GUICtrlCreateInput ("0 %",510,35,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will win with a hand from this group VS 3 Opponents")
	$lblWinOddsRaise = GUICtrlCreateInput ("0 %",510,60,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will win with a hand from this group VS 3 Opponents")
	$lblWinOddsCallAny = GUICtrlCreateInput ("0 %",510,85,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will win with a hand from this group VS 3 Opponents")
	$lblWinOddsCallUpTo = GUICtrlCreateInput ("0 %",510,110,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will win with a hand from this group VS 3 Opponents")
	$lblWinOddsCallOnce = GUICtrlCreateInput ("0 %",510,135,70,25, $ES_READONLY)
	GUICtrlSetTip(-1,"The Odds that you will win with a hand from this group VS 3 Opponents")


	$btnAllIn = GUICtrlCreateButton ("All In",360,35,70,25)
	$btnRaise = GUICtrlCreateButton ("Raise",360,60,70,25)
	$btnCallAny = GUICtrlCreateButton ("Call Any",360,85,70,25)
	$btnCallUpTo = GUICtrlCreateButton ("Call UpTo",360,110,70,25)
	$btnCallOnce = GUICtrlCreateButton ("Call Once",360,135,70,25)
	$btnClear = GUICtrlCreateButton ("Clear",360,160,70,25)

	$btnClearAll = GUICtrlCreateButton ("Clear All",360,195,70,25)

	$btnSave = GUICtrlCreateButton ("Save",360,315,70,25)
	$btnRevert = GUICtrlCreateButton ("Revert",440,315,70,25)
	$btnClose = GUICtrlCreateButton ("Close",520,315,70,25)

	GUICtrlSetBkColor($btnAllIn, _lookupValueToColor($lookup_All_In))
	GUICtrlSetBkColor($lblOddsAllIn, _lookupValueToColor($lookup_All_In))
	GUICtrlSetBkColor($lblWinOddsAllIn, _lookupValueToColor($lookup_All_In))
	GUICtrlSetBkColor($btnRaise, _lookupValueToColor($lookup_Raise))
	GUICtrlSetBkColor($lblOddsRaise, _lookupValueToColor($lookup_Raise))
	GUICtrlSetBkColor($lblWinOddsRaise, _lookupValueToColor($lookup_Raise))
	GUICtrlSetBkColor($btnCallAny, _lookupValueToColor($lookup_Call_Any))
	GUICtrlSetBkColor($lblOddsCallAny, _lookupValueToColor($lookup_Call_Any))
	GUICtrlSetBkColor($lblWinOddsCallAny, _lookupValueToColor($lookup_Call_Any))
	GUICtrlSetBkColor($btnCallUpTo, _lookupValueToColor($lookup_Call_UpTo))
	GUICtrlSetBkColor($lblOddsCallUpTo, _lookupValueToColor($lookup_Call_UpTo))
	GUICtrlSetBkColor($lblWinOddsCallUpTo, _lookupValueToColor($lookup_Call_UpTo))
	GUICtrlSetBkColor($btnCallOnce, _lookupValueToColor($lookup_Call_Once))
	GUICtrlSetBkColor($lblOddsCallOnce, _lookupValueToColor($lookup_Call_Once))
	GUICtrlSetBkColor($lblWinOddsCallOnce, _lookupValueToColor($lookup_Call_Once))

	$DealtOdds = _CalculateDealtOdds($lookup_All_In,$StartingHandArray)
	$WinOdds =_CalculateWinOdds($lookup_All_In,$winOddsIndex,$DealtOdds,$startingHandArray)
	GUICtrlSetData($lblOddsAllIn,round($DealtOdds,1)&" %")
	GUICtrlSetData($lblWinOddsAllIn,round($WinOdds,1)&" %")
	$DealtOdds = _CalculateDealtOdds($lookup_Raise,$StartingHandArray)
	$WinOdds =_CalculateWinOdds($lookup_Raise,$winOddsIndex,$DealtOdds,$startingHandArray)
	GUICtrlSetData($lblOddsRaise,round($DealtOdds,1)&" %")
	GUICtrlSetData($lblWinOddsRaise,round($WinOdds,1)&" %")
	$DealtOdds = _CalculateDealtOdds($lookup_Call_Any,$StartingHandArray)
	$WinOdds =_CalculateWinOdds($lookup_Call_Any,$winOddsIndex,$DealtOdds,$startingHandArray)
	GUICtrlSetData($lblOddsCallAny,round($DealtOdds,1)&" %")
	GUICtrlSetData($lblWinoddsCallAny,round($WinOdds,1)&" %")
	$DealtOdds = _CalculateDealtOdds($lookup_Call_UpTo,$StartingHandArray)
	$WinOdds =_CalculateWinOdds($lookup_Call_UpTo,$winOddsIndex,$DealtOdds,$startingHandArray)
	GUICtrlSetData($lblOddsCallUpTo,round($DealtOdds,1)&" %")
	GUICtrlSetData($lblWinoddsCallUpTo,round($WinOdds,1)&" %")
	$DealtOdds = _CalculateDealtOdds($lookup_Call_Once,$StartingHandArray)
	$WinOdds =_CalculateWinOdds($lookup_Call_Once,$winOddsIndex,$DealtOdds,$startingHandArray)
	GUICtrlSetData($lblOddsCallOnce,round($DealtOdds,1)&" %")
	GUICtrlSetData($lblWinoddsCallOnce,round($WinOdds,1)&" %")

	$totalOdds =StringTrimRight(GUICtrlRead($lblOddsAllIn),2)+StringTrimRight(GUICtrlRead($lblOddsRaise),2)+StringTrimRight(GUICtrlRead($lblOddsCallAny),2)+StringTrimRight(GUICtrlRead($lblOddsCallUpTo),2)+StringTrimRight(GUICtrlRead($lblOddsCallOnce),2)
	GUICtrlSetData($lblOddsTotal,$totalOdds&" %")

	ProgressOff()

	 GUISetState(@SW_SHOW)
	;_ArrayDisplay ($sHandIndex)
	$cycle = 0.5
	$cc = 0.05
	$UpdateColor = TimerInit()
	$dll = DllOpen("user32.dll")
	While 1
		$msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE or $msg = $btnClose Then
			switch MsgBox (32+3,"Save Ini settings","Do you wish to save changes to "&$filename&"?")
				case 6 ;yes
					_PreFlopHands_SaveToIni($IniType,$filename,$StartingHandArray)
					DllClose($dll)
					ExitLoop
				case 7 ;no
					DllClose($dll)
					ExitLoop
				case 2 ;cancel
			EndSwitch

		endif
		for $id = 1 to 169
			if $msg = $btnHandIndex[$id] then
				;toggle
				if $StartingHandArray[$id] = $SelectedAction then
					$old = 0
					$StartingHandArray[$id] = 0
				Else
					$old = $StartingHandArray[$id]
					$StartingHandArray[$id] = $SelectedAction
				endif
				_ColorButton($id,$sHandIndex,$btnHandIndex,$winOddsIndex,$StartingHandArray)
				if $old <> 0 then
					$DealtOdds = _CalculateDealtOdds($old,$StartingHandArray)
					$WinOdds =_CalculateWinOdds($old,$winOddsIndex,$DealtOdds,$startingHandArray)
					switch $old
						case $lookup_All_In
							GUICtrlSetData($lblOddsAllIn,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsAllIn,round($WinOdds,1)&" %")
						case $lookup_Raise
							GUICtrlSetData($lblOddsRaise,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblwinOddsRaise,round($WinOdds,1)&" %")
						case $lookup_Call_Any
							GUICtrlSetData($lblOddsCallAny,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallAny,round($WinOdds,1)&" %")
						case $lookup_Call_UpTo
							GUICtrlSetData($lblOddsCallUpTo,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallUpTo,round($WinOdds,1)&" %")
						case $lookup_Call_Once
							GUICtrlSetData($lblOddsCallOnce,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallOnce,round($WinOdds,1)&" %")
					EndSwitch
				endif
				$DealtOdds = _CalculateDealtOdds($SelectedAction,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($SelectedAction,$winOddsIndex,$DealtOdds,$startingHandArray)
					switch $SelectedAction
						case $lookup_All_In
							GUICtrlSetData($lblOddsAllIn,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsAllIn,round($WinOdds,1)&" %")
						case $lookup_Raise
							GUICtrlSetData($lblOddsRaise,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblwinOddsRaise,round($WinOdds,1)&" %")
						case $lookup_Call_Any
							GUICtrlSetData($lblOddsCallAny,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallAny,round($WinOdds,1)&" %")
						case $lookup_Call_UpTo
							GUICtrlSetData($lblOddsCallUpTo,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallUpTo,round($WinOdds,1)&" %")
						case $lookup_Call_Once
							GUICtrlSetData($lblOddsCallOnce,round($DealtOdds,1)&" %")
							GUICtrlSetData($lblWinOddsCallOnce,round($WinOdds,1)&" %")
					EndSwitch
				$totalOdds =StringTrimRight(GUICtrlRead($lblOddsAllIn),2)+StringTrimRight(GUICtrlRead($lblOddsRaise),2)+StringTrimRight(GUICtrlRead($lblOddsCallAny),2)+StringTrimRight(GUICtrlRead($lblOddsCallUpTo),2)+StringTrimRight(GUICtrlRead($lblOddsCallOnce),2)
				GUICtrlSetData($lblOddsTotal,$totalOdds&" %")
			endif
		next

		if $msg = $btnAllIn or _IsPressed (31,$dll) then
				$SelectedAction = $lookup_All_In
				GUICtrlSetData($lblSelected,"All In")
				GUICtrlSetBkColor($lblSelected,_lookupValueToColor($lookup_All_In))
		elseif $msg = $btnRaise or _IsPressed (32,$dll) then
				$SelectedAction = $lookup_Raise
				GUICtrlSetData($lblSelected,"Raise")
				GUICtrlSetBkColor($lblSelected,_lookupValueToColor($lookup_Raise))
		elseif $msg =  $btnCallAny or _IsPressed (33,$dll) then
				$SelectedAction = $lookup_Call_Any
				GUICtrlSetData($lblSelected,"Call Any")
				GUICtrlSetBkColor($lblSelected,_lookupValueToColor($lookup_Call_Any))
		elseif $msg = $btnCallUpTo or _IsPressed (34,$dll) then
				$SelectedAction = $lookup_Call_UpTo
				GUICtrlSetData($lblSelected,"Call UpTo")
				GUICtrlSetBkColor($lblSelected,_lookupValueToColor($lookup_Call_UpTo))
		elseif $msg = $btnCallOnce or _IsPressed (35,$dll) then
				$SelectedAction = $lookup_Call_Once
				GUICtrlSetData($lblSelected,"Call Once")
				GUICtrlSetBkColor($lblSelected,_lookupValueToColor($lookup_Call_Once))
		elseif $msg =  $btnClear or _IsPressed (43,$dll) then
				$SelectedAction = 0
				GUICtrlSetData($lblSelected,"Clear")
				GUICtrlSetBkColor($lblSelected,dec("888888"))
		elseif $msg = $btnRevert Then
			if MsgBox (32+4,"Revert to Ini settings","This will restore the original Ini settings. Are you sure this is what you want?") = 6 then
				$StartingHandArray = _PreFlopHands_LoadFromIni($iniType,$filename)
				for $id = 1 to 169
					_ColorButton($id,$sHandIndex,$btnHandIndex,$winOddsIndex,$StartingHandArray)
				next
				$DealtOdds = _CalculateDealtOdds($lookup_All_In,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($lookup_All_In,$winOddsIndex,$DealtOdds,$startingHandArray)
				GUICtrlSetData($lblOddsAllIn,round($DealtOdds,1)&" %")
				GUICtrlSetData($lblWinOddsAllIn,round($WinOdds,1)&" %")
				$DealtOdds = _CalculateDealtOdds($lookup_Raise,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($lookup_Raise,$winOddsIndex,$DealtOdds,$startingHandArray)
				GUICtrlSetData($lblOddsRaise,round($DealtOdds,1)&" %")
				GUICtrlSetData($lblWinOddsRaise,round($WinOdds,1)&" %")
				$DealtOdds = _CalculateDealtOdds($lookup_Call_Any,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($lookup_Call_Any,$winOddsIndex,$DealtOdds,$startingHandArray)
				GUICtrlSetData($lblOddsCallAny,round($DealtOdds,1)&" %")
				GUICtrlSetData($lblWinoddsCallAny,round($WinOdds,1)&" %")
				$DealtOdds = _CalculateDealtOdds($lookup_Call_UpTo,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($lookup_Call_UpTo,$winOddsIndex,$DealtOdds,$startingHandArray)
				GUICtrlSetData($lblOddsCallUpTo,round($DealtOdds,1)&" %")
				GUICtrlSetData($lblWinoddsCallUpTo,round($WinOdds,1)&" %")
				$DealtOdds = _CalculateDealtOdds($lookup_Call_Once,$StartingHandArray)
				$WinOdds =_CalculateWinOdds($lookup_Call_Once,$winOddsIndex,$DealtOdds,$startingHandArray)
				GUICtrlSetData($lblOddsCallOnce,round($DealtOdds,1)&" %")
				GUICtrlSetData($lblWinoddsCallOnce,round($WinOdds,1)&" %")

				$totalOdds =StringTrimRight(GUICtrlRead($lblOddsAllIn),2)+StringTrimRight(GUICtrlRead($lblOddsRaise),2)+StringTrimRight(GUICtrlRead($lblOddsCallAny),2)+StringTrimRight(GUICtrlRead($lblOddsCallUpTo),2)+StringTrimRight(GUICtrlRead($lblOddsCallOnce),2)
				GUICtrlSetData($lblOddsTotal,$totalOdds&" %")
			endif
		elseif $msg = $btnSave Then
				_PreFlopHands_SaveToIni($IniType,$filename,$StartingHandArray)
		elseif $msg = $btnClearAll then
			for $id = 1 to 169
				$StartingHandArray[$id] = 0
				_ColorButton($id,$sHandIndex,$btnHandIndex,$winOddsIndex,$StartingHandArray)
			next
			GUICtrlSetData($lblOddsAllIn,"0 %")
			GUICtrlSetData($lblOddsRaise,"0 %")
			GUICtrlSetData($lblOddsCallAny,"0 %")
			GUICtrlSetData($lblOddsCallUpTo,"0 %")
			GUICtrlSetData($lblOddsCallOnce,"0 %")
			GUICtrlSetData($lblOddsTotal,"0 %")
			GUICtrlSetData($lblWinOddsAllIn,"0 %")
			GUICtrlSetData($lblWinOddsRaise,"0 %")
			GUICtrlSetData($lblWinOddsCallAny,"0 %")
			GUICtrlSetData($lblWinOddsCallUpTo,"0 %")
			GUICtrlSetData($lblWinOddsCallOnce,"0 %")
		endif
	WEnd
	GUIDelete($frmPreFlopHandSelector)
EndFunc


func _lookupCard($iCard)
	return $sLookupCards[$iCard]
EndFunc

func _lookupCardID($iCard)
	for $i = 1 to $sLookupCards[0]
		if $sLookupCards[$i] = $iCard then return $i
	next
	return -1
EndFunc


func _DetectIni($filename)
	$iniVersion = IniRead ($filename,"general","IniVersion","")
	if $iniVersion <> "" then return $iniVersion

	if _DetectIni_Zbot_6($filename) then
		$iniVersion = "zbot 6"
	endif
	IniWrite ($filename,"general","IniVersion",$iniVersion)
	return $iniVersion
EndFunc

Func _DetectIni_Zbot_6($filename)
	;test for zbot 6
	$pfh = IniReadSection ($filename,"PREFLOP_HANDS")
	$sh = IniReadSection ($filename,"Suited_Hands")
	$required = StringSplit("all_in,raise,call_any,call_upto,call_once",",")
	if _DetectIni_VerifyValidSection($pfh,$required) then
		if _DetectIni_VerifyValidSection($sh,$required) then
			return true
		endif
	endif
EndFunc

func _DetectIni_VerifyValidSection($section,$Required)
	if not IsArray($section) then return false
	for $i = 1 to $section[0][0]
		for $iRequired = 1 to $required[0]
			if $section[$i][0] = $required[$iRequired] then $required[$iRequired] = "" ;no longer required
		Next
	next
	for $iRequired = 1 to $required[0]
		if $required[$iRequired] <> "" then return false ;something is still missing from this section
	next
	return true ;valid ini section
EndFunc

func _LookupHandID($startinghand)
	$Suited = false
	if StringRight($startinghand,1) = "s" then
		$Suited= true
	endif
	$startinghand = StringSplit($startinghand,"")
	if $startinghand[0] >= 2 then
		$card1 = _lookupCardID($startinghand[1])
		$card2 = _lookupCardID($startinghand[2])
		if $card2 < $card1 Then ;switch the cards so they are eg. AK instead of KA
			$tmpCard = $card1
			$card1 = $card2
			$card2 = $tmpCard
		endif
		if $card1 = $card2 then ;pocket pairs can't be suited
			$Suited = false
		endif
	Else
		return false
	endif

	if $Suited Then
		;switch them, as suited cards appear on the top left
		$tmpCard = $card1
		$card1 = $card2
		$card2 = $tmpCard
	endif
	return (($card1-1)*13) + $card2
EndFunc

func _lookupValueToColor($value)
	switch $value
		case $lookup_All_In
			return dec("30ce17")
		case $lookup_Raise
			return dec("20a506")
		case $lookup_Call_Any
			return dec("69a5c2")
		case $lookup_Call_UpTo
			return dec("496fe5")
		case $lookup_Call_Once
			return dec("5050a5")
	EndSwitch
EndFunc

func _StartingCardsWinOdds($StartingCards)
	$value = IniRead($startingHandsINIpath,"rating",$StartingCards,0)
	;ConsoleWrite ($StartingCards &" = " &$value&@CRLF)
	return $value
EndFunc


func _ColorButton($id,byref $sHandIndex,byref $btnHandIndex,byref $winOddsIndex,byref $StartingHandArray)
	if $StartingHandArray[$id] <> 0 then
		GUICtrlSetBkColor($btnHandIndex[$id], _lookupValueToColor($StartingHandArray[$id]))
	Else
		$winOdds = int($winOddsIndex[$id] * 398 );1 -> 255
		GUICtrlSetBkColor($btnHandIndex[$id], dec(hex(255-$winOdds,2)&"9977"))
	endif
EndFunc

func _CalculateDealtOdds($SelectedAction,$handArray)
	local $DealtOdds
	local $tempSuited
	for $iCard1 = 1 to 13
		for $iCard2 = 1 to 13
			$id = (($iCard1-1)*13) + $iCard2
			if $handArray[$id] = $SelectedAction then
				if $iCard1 <$iCard2 then ;unsuited, 1 is ace, 13 is 2
					$DealtOdds += $UnsuitedDealtOdds
				elseif $iCard1 > $iCard2 then ;suited
					$DealtOdds += $SuitedDealtOdds
				else ;pocket pair
					$DealtOdds +=$PocketPairDealtOdds
				endif
			endif
		Next
	next
	return ($DealtOdds*100)
EndFunc

func _CalculateWinOdds($SelectedAction,$winOddsIndex,$DealtOdds,$handArray)
	if $DealtOdds = 0 then return 0
	$winOddsTotal = 0
	for $iCard1 = 1 to 13
		for $iCard2 = 1 to 13
			$id = (($iCard1-1)*13) + $iCard2
			if $handArray[$id] = $SelectedAction then
				if $iCard1 <$iCard2 then ;unsuited, 1 is ace, 13 is 2
					$winOddsTotal += $winOddsIndex[$id]*$UnsuitedDealtOdds
				elseif $iCard1 > $iCard2 then ;suited
					$winOddsTotal += $winOddsIndex[$id]*$SuitedDealtOdds
				else ;pocket pair
					$winOddsTotal += $winOddsIndex[$id]*$PocketPairDealtOdds
				endif
			endif
		Next
	next
	return 10000/$DealtOdds*$winOddsTotal
EndFunc
