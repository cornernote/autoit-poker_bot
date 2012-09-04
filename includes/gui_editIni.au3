#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <gui_PreflopHandSelector.au3>
#Include <GuiSlider.au3>
#Region ### START Koda GUI section ### Form=c:\pokerbot\pokerbot\frmeditini.kxf
Global $cAmountPF
Global $cAmountF
Global $cAmountT
Global $cAmountR
Global $rAmountPF
Global $rAmountF
Global $rAmountT
Global $rAmountR
Global $iBank
Global $all_in_Bank
Global $raises_Bank
Global $iLobby
Global $iSuit_raise
Global $iSuit_any
Global $iSuit_upto
Global $iSuit_once
Global $iHand_raise
Global $iHand_any
Global $iHand_upto
Global $iHand_once
global $sFlopScoreAllIn,$sFlopScoreRaise,$sFlopScorecall,$sFlopScorecallupto
global $sturnScoreAllIn,$sturnScoreRaise,$sturnScorecall,$sturnScorecallupto
global $sriverScoreAllIn,$sriverScoreRaise,$sriverScorecall,$sriverScorecallupto

func _frmEditIni($sPlayerinifile)
	local $SliderHeight = 17
	$title = IniRead(@ScriptDir&"\settings.ini", "General", "EditPlayerSettingsWindowTitle","Pokerbot: Edit Player Settings")
	$frm_editIni = GUICreate("Pokerbot: Edit Player Settings", 594, 380, 277, 180)
	GUICtrlCreateGroup("Preflop", 8, 8, 281, 81)
	$btnEditPreflopHands = GUICtrlCreateButton("Edit Preflop Hands...", 24, 26, 150, 25)
	$offsetX = 24
	$offsetY = -44
	GUICtrlCreateLabel("Call (blinds)", $offsetX, $offsetY+103+4, 57, 17)
	$InputPreflopCallBlinds = GUICtrlCreateInput("", $offsetX+62, $offsetY+103, 49, 21)
	GUICtrlCreateLabel("Raise (blinds)", $offsetX+128, $offsetY+103+4, 67, 17)
	$InputPreflopRaiseBlinds = GUICtrlCreateInput("", $offsetX+200, $offsetY+103, 49, 21)

	GUICtrlCreateGroup("Flop", 8, 96, 281, 153)
	GUICtrlCreateGroup("Turn", 304, 8, 281, 153)
	GUICtrlCreateGroup("River", 304, 167, 281, 153)
	GUICtrlCreateGroup("", 8, 253, 281, 121)
	;group flop:
	$offsetX = 24
	$offsetY =112
	GUICtrlCreateLabel("call upto", $offsetX, $offsetY+4, 47, 17)
	GUICtrlCreateLabel("call",$offsetX, $offsetY+24+4, 47,17)
	GUICtrlCreateLabel("raise", $offsetX, $offsetY+48+4, 40, 17)
	GUICtrlCreateLabel("All In", $offsetX, $offsetY+72+4, 27, 17)
	$inputFlopcallupto = GUICtrlCreateInput("", $offsetX+48, $offsetY, 41, 21)
	$inputFlopcall = GUICtrlCreateInput("", $offsetX+48, $offsetY+24, 41, 21)
	$inputFlopRaise = GUICtrlCreateInput("", $offsetX+48,  $offsetY+48, 41, 21)
	$inputFlopAllIn = GUICtrlCreateInput("", $offsetX+48, $offsetY+72, 41, 21)
	$sliderFlopcallupto = GUICtrlCreateSlider($offsetX+94, $offsetY, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$Sliderflopcall = GUICtrlCreateSlider($offsetX+94, $offsetY+24, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$sliderFlopRaise = GUICtrlCreateSlider($offsetX+94, $offsetY+48, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$SliderFlopAllIn = GUICtrlCreateSlider($offsetX+94, $offsetY+72, 161,$SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlCreateLabel("Call (blinds)", $offsetX, $offsetY+103+4, 57, 17)
	$InputFlopCallBlinds = GUICtrlCreateInput("", $offsetX+62, $offsetY+103, 49, 21)
	GUICtrlCreateLabel("Raise (blinds)", $offsetX+128, $offsetY+103+4, 67, 17)
	$InputFlopRaiseBlinds = GUICtrlCreateInput("", $offsetX+200, $offsetY+103, 49, 21)
	;group turn:
	$offsetX = 320
	$offsetY =25
	GUICtrlCreateLabel("call upto", $offsetX, $offsetY+4, 47, 17)
	GUICtrlCreateLabel("call",$offsetX, $offsetY+24+4, 47,17)
	GUICtrlCreateLabel("raise", $offsetX, $offsetY+48+4, 40, 17)
	GUICtrlCreateLabel("All In", $offsetX, $offsetY+72+4, 27, 17)
	$inputturncallupto = GUICtrlCreateInput("", $offsetX+48, $offsetY, 41, 21)
	$inputturncall = GUICtrlCreateInput("", $offsetX+48, $offsetY+24, 41, 21)
	$inputturnRaise = GUICtrlCreateInput("", $offsetX+48,  $offsetY+48, 41, 21)
	$inputturnAllIn = GUICtrlCreateInput("", $offsetX+48, $offsetY+72, 41, 21)
	$sliderturncallupto = GUICtrlCreateSlider($offsetX+94, $offsetY, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$Sliderturncall = GUICtrlCreateSlider($offsetX+94, $offsetY+24, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$sliderturnRaise = GUICtrlCreateSlider($offsetX+94, $offsetY+48, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$SliderturnAllIn = GUICtrlCreateSlider($offsetX+94, $offsetY+72, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlCreateLabel("Call (blinds)", $offsetX, $offsetY+103+4, 57, 17)
	$InputturnCallBlinds = GUICtrlCreateInput("", $offsetX+62, $offsetY+103, 49, 21)
	GUICtrlCreateLabel("Raise (blinds)", $offsetX+128, $offsetY+103+4, 67, 17)
	$InputturnRaiseBlinds = GUICtrlCreateInput("", $offsetX+200, $offsetY+103, 49, 21)

	;group river
	$offsetX = 320
	$offsetY =180
	GUICtrlCreateLabel("call upto", $offsetX, $offsetY+4, 47, 17)
	GUICtrlCreateLabel("call",$offsetX, $offsetY+24+4, 47,17)
	GUICtrlCreateLabel("raise", $offsetX, $offsetY+48+4, 40, 17)
	GUICtrlCreateLabel("All In", $offsetX, $offsetY+72+4, 27, 17)
	$inputrivercallupto = GUICtrlCreateInput("", $offsetX+48, $offsetY, 41, 21)
	$inputrivercall = GUICtrlCreateInput("", $offsetX+48, $offsetY+24, 41, 21)
	$inputriverRaise = GUICtrlCreateInput("", $offsetX+48,  $offsetY+48, 41, 21)
	$inputriverAllIn = GUICtrlCreateInput("", $offsetX+48, $offsetY+72, 41, 21)
	$sliderrivercallupto = GUICtrlCreateSlider($offsetX+94, $offsetY, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$Sliderrivercall = GUICtrlCreateSlider($offsetX+94, $offsetY+24, 161,$SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$sliderriverRaise = GUICtrlCreateSlider($offsetX+94, $offsetY+48, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	$SliderriverAllIn = GUICtrlCreateSlider($offsetX+94, $offsetY+72, 161, $SliderHeight)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlCreateLabel("Call (blinds)", $offsetX, $offsetY+103+4, 57, 17)
	$InputriverCallBlinds = GUICtrlCreateInput("", $offsetX+62, $offsetY+103, 49, 21)
	GUICtrlCreateLabel("Raise (blinds)", $offsetX+128, $offsetY+103+4, 67, 17)
	$InputriverRaiseBlinds = GUICtrlCreateInput("", $offsetX+200, $offsetY+103, 49, 21)

	$btnSave = GUICtrlCreateButton("Save", 400, 346, 89, 25)
	$btnCancel = GUICtrlCreateButton("Cancel", 496, 346, 89, 25)
	$btnOk = GUICtrlCreateButton("Ok", 304, 346, 89, 25)
	$fixY = 32
	GUICtrlCreateLabel("Go to a new room after", 16, 304-$fixY, 112, 17)
	GUICtrlCreateLabel("Bank after", 16, 328-$fixY, 53, 17)
	$InputForceRoom = GUICtrlCreateInput("", 136, 300-$fixY, 49, 21)
	$InputBankHands = GUICtrlCreateInput("", 72, 324-$fixY, 49, 21)
	$InputBankRaises = GUICtrlCreateInput("", 72, 348-$fixY, 49, 21)
	$InputBankAllIn = GUICtrlCreateInput("", 72, 372-$fixY, 49, 21)
	GUICtrlCreateLabel("Bank after", 16, 352-$fixY, 53, 17)
	GUICtrlCreateLabel("Bank after", 16, 376-$fixY, 53, 17)
	GUICtrlCreateLabel("hands", 192, 304-$fixY, 33, 17)
	GUICtrlCreateLabel("hands", 128, 328-$fixY, 33, 17)
	GUICtrlCreateLabel("raises", 128, 352-$fixY, 31, 17)
	GUICtrlCreateLabel("all ins", 128, 376-$fixY, 30, 17)
	#EndRegion ### END Koda GUI section ###

	_gui_editini_load($sPlayerinifile) ;process the ini
	;update gui
	guictrlsetdata ($inputFlopAllIn,$sFlopScoreAllIn)
	guictrlsetdata ($inputFlopRaise,$sFlopScoreRaise)
	guictrlsetdata ($inputFlopcall,$sFlopScorecall)
	guictrlsetdata ($inputFlopcallupto,$sFlopScorecallupto)
	guictrlsetdata ($SliderFlopAllIn,$sFlopScoreAllIn*100)
	guictrlsetdata ($sliderFlopRaise,$sFlopScoreRaise*100)
	guictrlsetdata ($sliderFlopcall,$sFlopScorecall*100)
	guictrlsetdata ($sliderFlopcallupto,$sFlopScorecallupto*100)
	guictrlsetdata ($inputturnAllIn,$sturnScoreAllIn)
	guictrlsetdata ($inputturnRaise,$sturnScoreRaise)
	guictrlsetdata ($inputturncall,$sturnScorecall)
	guictrlsetdata ($inputturncallupto,$sturnScorecallupto)
	guictrlsetdata ($SliderturnAllIn,$sturnScoreAllIn*100)
	guictrlsetdata ($sliderturnRaise,$sturnScoreRaise*100)
	guictrlsetdata ($sliderturncall,$sturnScorecall*100)
	guictrlsetdata ($sliderturncallupto,$sturnScorecallupto*100)
	guictrlsetdata ($inputriverAllIn,$sriverScoreAllIn)
	guictrlsetdata ($inputriverRaise,$sriverScoreRaise)
	guictrlsetdata ($inputrivercall,$sriverScorecall)
	guictrlsetdata ($inputrivercallupto,$sriverScorecallupto)
	guictrlsetdata ($SliderriverAllIn,$sriverScoreAllIn*100)
	guictrlsetdata ($sliderriverRaise,$sriverScoreRaise*100)
	guictrlsetdata ($sliderrivercall,$sriverScorecall*100)
	guictrlsetdata ($sliderrivercallupto,$sriverScorecallupto*100)

	guictrlsetdata ($InputPreflopCallBlinds,$cAmountPF)
	guictrlsetdata ($InputPreflopRaiseBlinds,$rAmountPF)
	guictrlsetdata ($InputflopCallBlinds,$cAmountF)
	guictrlsetdata ($InputflopRaiseBlinds,$rAmountF)
	guictrlsetdata ($InputturnCallBlinds,$cAmountT)
	guictrlsetdata ($InputturnRaiseBlinds,$rAmountT)
	guictrlsetdata ($InputriverCallBlinds,$cAmountR)
	guictrlsetdata ($InputriverRaiseBlinds,$rAmountR)
	guictrlsetdata ($InputForceRoom,$iLobby)
	guictrlsetdata ($InputBankHands,$iBank)
	guictrlsetdata ($InputBankAllIn,$all_in_Bank)
	guictrlsetdata ($InputBankRaises,$raises_Bank)

	;show gui
	GUISetState(@SW_SHOW)

	While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	case  $GUI_EVENT_CLOSE, $btnOk
		switch MsgBox (32+3,"Save Ini settings","Do you wish to save changes to "&$sPlayerinifile&"?")
			case 6 ;yes
				_gui_editini_save($sPlayerinifile,$InputPreflopCallBlinds,$InputFlopCallBlinds,$InputturnCallBlinds,$InputriverCallBlinds, _
				$InputPreflopRaiseBlinds,$InputflopRaiseBlinds,$InputTurnRaiseBlinds,$InputriverRaiseBlinds,$InputBankHands,$InputBankAllIn,$InputBankRaises,$InputForceRoom)
				_SaveScoreSection($sPlayerinifile,"FlopScore",guictrlread($inputFlopAllIn),guictrlread($inputFlopRaise),guictrlread($inputFlopcall),guictrlread($inputFlopcallupto))
				_SaveScoreSection($sPlayerinifile,"turnScore",guictrlread($inputturnAllIn),guictrlread($inputturnRaise),guictrlread($inputturncall),guictrlread($inputturncallupto))
				_SaveScoreSection($sPlayerinifile,"RiverScore",guictrlread($inputRiverAllIn),guictrlread($inputRiverRaise),guictrlread($inputRivercall),guictrlread($inputRivercallupto))
				ExitLoop
			case 7 ;no
				ExitLoop
			case 2 ;cancel
		EndSwitch

	Case $btnEditPreflopHands
		GUISetState (@SW_DISABLE,$frm_editIni)
		_SelectPreFlopHand ($sPlayerinifile)
		GUISetState (@SW_ENABLE,$frm_editIni)
		WinActivate($frm_editIni)
	Case $inputFlopcallupto
		_updatesliders("call_upto",GUICtrlRead($inputFlopcallupto),$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $inputFlopcall
		_updatesliders("call",GUICtrlRead($inputFlopcall),$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $inputFlopRaise
		_updatesliders("raise",GUICtrlRead($inputFlopRaise),$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $InputFlopAllIn
		_updatesliders("all_in",GUICtrlRead($InputFlopAllIn),$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $sliderFlopcallupto
		_updatesliders("call_upto",GUICtrlRead($sliderFlopcallupto)/100,$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $Sliderflopcall
		_updatesliders("call",GUICtrlRead($Sliderflopcall)/100,$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $sliderFlopRaise
		_updatesliders("raise",GUICtrlRead($sliderFlopRaise)/100,$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $SliderFlopAllIn
		_updatesliders("all_in",GUICtrlRead($SliderFlopAllIn)/100,$inputFlopcallupto,$sliderFlopcallupto,$inputFlopcall,$sliderFlopcall,$inputFlopRaise,$sliderFlopRaise,$InputFlopAllIn,$SliderFlopAllIn)
	Case $inputturncallupto
		_updatesliders("call_upto",GUICtrlRead($inputturncallupto),$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $inputturncall
		_updatesliders("call",GUICtrlRead($inputturncall),$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $inputturnRaise
		_updatesliders("raise",GUICtrlRead($inputturnRaise),$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $InputturnAllIn
		_updatesliders("all_in",GUICtrlRead($InputturnAllIn),$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $sliderturncallupto
		_updatesliders("call_upto",GUICtrlRead($sliderturncallupto)/100,$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $Sliderturncall
		_updatesliders("call",GUICtrlRead($Sliderturncall)/100,$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $sliderturnRaise
		_updatesliders("raise",GUICtrlRead($sliderturnRaise)/100,$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $SliderturnAllIn
		_updatesliders("all_in",GUICtrlRead($SliderturnAllIn)/100,$inputturncallupto,$sliderturncallupto,$inputturncall,$sliderturncall,$inputturnRaise,$sliderturnRaise,$InputturnAllIn,$SliderturnAllIn)
	Case $inputrivercallupto
		_updatesliders("call_upto",GUICtrlRead($inputrivercallupto),$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $inputrivercall
		_updatesliders("call",GUICtrlRead($inputrivercall),$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $inputriverRaise
		_updatesliders("raise",GUICtrlRead($inputriverRaise),$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $InputriverAllIn
		_updatesliders("all_in",GUICtrlRead($InputriverAllIn),$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $sliderrivercallupto
		_updatesliders("call_upto",GUICtrlRead($sliderrivercallupto)/100,$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $Sliderrivercall
		_updatesliders("call",GUICtrlRead($Sliderrivercall)/100,$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $sliderriverRaise
		_updatesliders("raise",GUICtrlRead($sliderriverRaise)/100,$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $SliderriverAllIn
		_updatesliders("all_in",GUICtrlRead($SliderriverAllIn)/100,$inputrivercallupto,$sliderrivercallupto,$inputrivercall,$sliderrivercall,$inputriverRaise,$sliderriverRaise,$InputriverAllIn,$SliderriverAllIn)
	Case $btnSave
		_gui_editini_save($sPlayerinifile,$InputPreflopCallBlinds,$InputFlopCallBlinds,$InputturnCallBlinds,$InputriverCallBlinds, _
		$InputPreflopRaiseBlinds,$InputflopRaiseBlinds,$InputTurnRaiseBlinds,$InputriverRaiseBlinds,$InputBankHands,$InputBankAllIn,$InputBankRaises,$InputForceRoom)
		_SaveScoreSection($sPlayerinifile,"FlopScore",guictrlread($inputFlopAllIn),guictrlread($inputFlopRaise),guictrlread($inputFlopcall),guictrlread($inputFlopcallupto))
		_SaveScoreSection($sPlayerinifile,"turnScore",guictrlread($inputturnAllIn),guictrlread($inputturnRaise),guictrlread($inputturncall),guictrlread($inputturncallupto))
		_SaveScoreSection($sPlayerinifile,"RiverScore",guictrlread($inputRiverAllIn),guictrlread($inputRiverRaise),guictrlread($inputRivercall),guictrlread($inputRivercallupto))
	Case $btnCancel
		ExitLoop
	EndSwitch
	WEnd
	GUIDelete($frm_editIni)
EndFunc

func _gui_editini_save($sPlayerinifile,$InputPreflopCallBlinds,$InputFlopCallBlinds,$InputturnCallBlinds,$InputriverCallBlinds, _
	$InputPreflopRaiseBlinds,$InputflopRaiseBlinds,$InputTurnRaiseBlinds,$InputriverRaiseBlinds,$InputBankHands,$InputBankAllIn,$InputBankRaises,$InputForceRoom)
	$xamount = GUICtrlRead($InputPreflopCallBlinds)
	IniWrite($sPlayerinifile, "call", "preflopcallamount", $xamount)
	$xamountriver= GUICtrlRead($InputFlopCallBlinds)
	IniWrite($sPlayerinifile, "call", "flopcallamount", $xamountriver)
	$yamountriver= GUICtrlRead($InputturnCallBlinds)
	IniWrite($sPlayerinifile, "call", "turncallamount", $yamountriver)
	$zamountriver= GUICtrlRead($InputriverCallBlinds)
	IniWrite($sPlayerinifile, "call", "rivercallamount", $zamountriver)
	$ramount = GUICtrlRead($InputPreflopRaiseBlinds)
	IniWrite($sPlayerinifile, "raise", "preflopraiseamount", $ramount)
	$framount = GUICtrlRead($InputflopRaiseBlinds)
	IniWrite($sPlayerinifile, "raise", "flopraiseamount", $framount)
	$tramount = GUICtrlRead($InputTurnRaiseBlinds)
	IniWrite($sPlayerinifile, "raise", "turnraiseamount", $tramount)
	$rramount = GUICtrlRead($InputriverRaiseBlinds)
	IniWrite($sPlayerinifile, "raise", "riverraiseamount", $rramount)

	$iBank = guictrlread ($InputBankHands)
	IniWrite($sPlayerinifile, "ForceBank", "hands", $iBank)
	$all_in_Bank = GUICtrlRead($InputBankAllIn)
	IniWrite($sPlayerinifile, "ForceBank", "all_ins", $all_in_Bank)
	$raises_Bank = guictrlread($InputBankRaises)
	IniWrite($sPlayerinifile, "ForceBank", "raises", $raises_Bank)
	$iLobby = guictrlread($InputForceRoom)
	IniWrite($sPlayerinifile, "ForceNewRoom", "hands", $iLobby)

	;0.0-0.49 =check
	$sFlopScoreSection = IniReadSection($sPlayerinifile, "FlopScore")
	$sTurnScoreSection = IniReadSection($sPlayerinifile, "TurnScore")
	$sRiverScoreSection = IniReadSection($sPlayerinifile, "RiverScore")
	global $sFlopScoreAllIn,$sFlopScoreRaise,$sFlopScorecall,$sFlopScorecallupto,$sFlopScoreCheck
	global $sturnScoreAllIn,$sturnScoreRaise,$sturnScorecall,$sturnScorecallupto,$sturnScoreCheck
	global $sriverScoreAllIn,$sriverScoreRaise,$sriverScorecall,$sriverScorecallupto,$sriverScoreCheck
	_ProcessScoreSection($sFlopScoreSection,$sFlopScoreAllIn,$sFlopScoreRaise,$sFlopScorecall,$sFlopScorecallupto)
	_ProcessScoreSection($sturnScoreSection,$sturnScoreAllIn,$sturnScoreRaise,$sturnScorecall,$sturnScorecallupto)
	_ProcessScoreSection($sriverScoreSection,$sriverScoreAllIn,$sriverScoreRaise,$sriverScorecall,$sriverScorecallupto)
EndFunc

func _gui_editini_load($sPlayerinifile)
	Global $cAmountPF = IniRead($sPlayerinifile, "call", "preflopcallamount", "Doh")
	Global $cAmountF = IniRead($sPlayerinifile, "call", "flopcallamount", "Doh")
	Global $cAmountT = IniRead($sPlayerinifile, "call", "turncallamount", "Doh")
	Global $cAmountR = IniRead($sPlayerinifile, "call", "rivercallamount", "Doh")
	Global $rAmountPF = IniRead($sPlayerinifile, "raise", "preflopraiseamount", "Doh")
	Global $rAmountF = IniRead($sPlayerinifile, "raise", "flopraiseamount", "Doh")
	Global $rAmountT = IniRead($sPlayerinifile, "raise", "turnraiseamount", "Doh")
	Global $rAmountR = IniRead($sPlayerinifile, "raise", "riverraiseamount", "Doh")
	Global $iBank = IniRead($sPlayerinifile, "ForceBank", "hands", "Doh")
	Global $all_in_Bank = IniRead($sPlayerinifile, "ForceBank", "all_ins", "Doh")
	Global $raises_Bank = IniRead($sPlayerinifile, "ForceBank", "raises", "Doh")
	Global $iLobby = IniRead($sPlayerinifile, "ForceNewRoom", "hands", "Doh")

	;0.0-0.49 =check
	$sFlopScoreSection = IniReadSection($sPlayerinifile, "FlopScore")
	$sTurnScoreSection = IniReadSection($sPlayerinifile, "TurnScore")
	$sRiverScoreSection = IniReadSection($sPlayerinifile, "RiverScore")
	global $sFlopScoreAllIn,$sFlopScoreRaise,$sFlopScorecall,$sFlopScorecallupto,$sFlopScoreCheck
	global $sturnScoreAllIn,$sturnScoreRaise,$sturnScorecall,$sturnScorecallupto,$sturnScoreCheck
	global $sriverScoreAllIn,$sriverScoreRaise,$sriverScorecall,$sriverScorecallupto,$sriverScoreCheck
	_ProcessScoreSection($sFlopScoreSection,$sFlopScoreAllIn,$sFlopScoreRaise,$sFlopScorecall,$sFlopScorecallupto)
	_ProcessScoreSection($sturnScoreSection,$sturnScoreAllIn,$sturnScoreRaise,$sturnScorecall,$sturnScorecallupto)
	_ProcessScoreSection($sriverScoreSection,$sriverScoreAllIn,$sriverScoreRaise,$sriverScorecall,$sriverScorecallupto)
EndFunc

func _ProcessScoreSection($sScoreSection,byref $sScoreAllIn,byref $sScoreRaise,byref $sScorecall,byref $sScorecallupto)
	$sScoreAllIn = 999
	$sScoreRaise = 999
	$sScorecall = 999
	$sScorecallupto = 999
	for $i = 1 to $sScoreSection[0][0]
		$tmp = StringSplit($sScoreSection[$i][0],"-")
		$RangeMin = $tmp[1]
		$RangeMax = $tmp[2]
		switch $sScoreSection[$i][1]
			case "all_in"
				if $RangeMin <$sScoreAllIn then $sScoreAllIn = $RangeMin
			case "raise"
				if $RangeMin <$sScoreRaise then $sScoreRaise = $RangeMin
			case "call"
				if $RangeMin <$sScorecall then $sScorecall = $RangeMin
			case "call_upto"
				if $RangeMin <$sScorecallupto then $sScorecallupto = $RangeMin
		EndSwitch
	next
	if 	$sScoreRaise > $sScoreAllIn then $sScoreRaise = $sScoreAllIn
	if 	$sScorecall > $sScoreRaise then $sScorecall = $sScoreRaise
	if 	$sScorecallupto > $sScorecall then $sScorecallupto = $sScorecall
EndFunc

func _SaveScoreSection($sPlayerinifile,$sectionName ,$iScoreAllIn, $iScoreRaise, $iScorecall, $iScorecallupto)
	local $ScoreSection[6][2]
	$ScoreSection[0][0] = 5
	$ScoreSection[1][0] = "0-"&($iScorecallupto-0.01)
	$ScoreSection[1][1] = "check"
	$ScoreSection[2][0] = $iScorecallupto&"-"&($iScorecall-0.01)
	$ScoreSection[2][1] = "call_upto"
	$ScoreSection[3][0] = $iScorecall&"-"&($iScoreRaise-0.01)
	$ScoreSection[3][1] = "call"
	$ScoreSection[4][0] = $iScoreRaise&"-"&($iScoreAllIn-0.01)
	$ScoreSection[4][1] = "raise"
	$ScoreSection[5][0] = $iScoreAllIn&"-999"
	$ScoreSection[5][1] = "all_in"
	$sScoreCheck = ($iScorecallupto)
	IniWriteSection ($sPlayerinifile,$sectionName,$ScoreSection)
EndFunc

func _updatesliders($sActionType,$newValue,byref $inputcallupto,byref $slidercallupto,byref $inputcall,byref $slidercall,byref $inputRaise,byref $sliderRaise,byref $inputAllIn,byref $SliderAllIn)
	switch $sActionType
		case "call_upto"
			GUICtrlSetData($inputcallupto,$newValue)
			GUICtrlSetData($slidercallupto,$newValue*100)
		case "call"
			GUICtrlSetData($inputcall,$newValue)
			GUICtrlSetData($slidercall,$newValue*100)
		case "raise"
			GUICtrlSetData($inputRaise,$newValue)
			GUICtrlSetData($sliderRaise,$newValue*100)
		case "all_in"
			GUICtrlSetData($inputAllIn,$newValue)
			GUICtrlSetData($SliderAllIn,$newValue*100)
	EndSwitch
	if GUICtrlRead($inputcall) <GUICtrlRead($inputcallupto) Then
		GUICtrlSetData($inputcall,GUICtrlRead($inputcallupto))
		GUICtrlSetData($slidercall,GUICtrlRead($inputcallupto)*100)
	endif
	if GUICtrlRead($inputRaise) <GUICtrlRead($inputcall) Then
		GUICtrlSetData($inputRaise,GUICtrlRead($inputcall))
		GUICtrlSetData($sliderRaise,GUICtrlRead($inputcall)*100)
	endif
	if GUICtrlRead($inputAllIn) <GUICtrlRead($inputRaise) Then
		GUICtrlSetData($inputAllIn,GUICtrlRead($inputRaise))
		GUICtrlSetData($SliderAllIn,GUICtrlRead($inputRaise)*100)
	endif

#CS 	if GUICtrlRead($inputcallupto) >GUICtrlRead($inputcall) Then
		GUICtrlSetData($inputcallupto,GUICtrlRead($inputcall))
		GUICtrlSetData($slidercallupto,GUICtrlRead($inputcall)*100)
	endif
		if GUICtrlRead($inputcall) >GUICtrlRead($inputRaise) Then
		GUICtrlSetData($inputcall,GUICtrlRead($inputRaise))
		GUICtrlSetData($slidercall,GUICtrlRead($sliderRaise)*100)
	endif
		if GUICtrlRead($inputRaise) >GUICtrlRead($inputAllIn) Then
		GUICtrlSetData($inputRaise,GUICtrlRead($inputAllIn))
		GUICtrlSetData($sliderRaise,GUICtrlRead($inputAllIn)*100)
	endif
	#CE
EndFunc
