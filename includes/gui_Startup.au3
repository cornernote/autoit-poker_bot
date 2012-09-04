;=================================================================
; Botage Poker Bot Startup GUI
; to enable easy editing of INI settings
; coded by Dan Barnes - djbarnes
; v1.0  - 16/jan/10 initial version of code
; v1.01 - 16/jan/10 added a countdown, so it will automatically start bot if user does nothing
; v1.02 - 16/jan/10 fixed a bug where it was incorrectly saving the log cards setting
; v1.03 - 17/jan/10 fixed a possible bug where lookupBlindbyID returns a string, which AutoIT then strugges to convert to a number when it does its less than/greater than calculations
; v1.04 - 17/jan/10 changed browser select to a dropdown, and added automatic selection of the browser's exe file.
; v1.05 - 17/jan/10 added a button for simple INI file editing, and added enter hotkey to launch the bot
; v1.1  - 19/jan/10 added Startup Hand editing window
; v1.11 - 21/jan/10 fixed issue with Startup hand window not including unsuited hands.
; v1.2 -  21/jan/10 added another window to enable more editing of the ini
; v1.21 - 26/jan/10 added save/load profile buttons
; v1.22 - 27/jan/10 modified all instances of $Sdatapath to use @scriptdir &"\"& $Sdatapath
; v1.23 - 04/feb/10 added support for all blinds (added 80k, 10m,20m, 40m)
; v1.23a- 04/feb/10 added support for 2k and 4k blinds!
; v1.24 - 05/feb/10 dropped $sdatapath, and replaced with hardcoded @scriptdir &"\data"
; v1.25 - 06/feb/10 removed Opt("GUIOnEventMode", 1) code that is only used by my bot, not Zbot.
;=================================================================
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiSlider.au3>
#Include <Misc.au3>
#include <gui_editini.au3>
global $iAllBlinds = IniRead ("settings.ini","table","Blinds","2|4|10|20|50|200|400|1000|2000|4000|10000|20000|40000|80000|200000|400000|1000000|2000000|10000000|20000000|40000000")
IniWrite ("settings.ini","table","Blinds",$iAllBlinds)
$iAllBlinds = StringSplit($iAllBlinds,"|")


global $TimerCountdown = TimerInit()
global $TimerCountdownLastUpdate = 0
global $StartupWindowTitle = IniRead(@ScriptDir&"\settings.ini", "General", "StartupWindowTitle","Pokerbot: Settings")
global $StartupWindowTimeoutSec = int(IniRead(@ScriptDir&"\settings.ini", "General", "StartupWindowTimeoutSec",60))

#Region ### START Koda GUI section ### Form=C:\Users\Administrator\Documents\Form1.kxf
$frmStart = GUICreate("Pokerbot", 456, 409, -1, -1)
$btStart = GUICtrlCreateButton("Start Bot", 336, 280, 105, 33, 0)
$lblMinBlind = GUICtrlCreateLabel("Min Blind", 24, 120, 120, 17)
$SliderMinBlind = GUICtrlCreateSlider(16, 136, 169, 20,$TBS_AUTOTICKS)
GUICtrlSetLimit(-1, $iAllBlinds[0], 1)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetData(-1, 1)
$lblMaxBlind = GUICtrlCreateLabel("Max Blind", 24, 176, 120, 17)
$SliderMaxBlind = GUICtrlCreateSlider(16, 192, 169, 20, $TBS_AUTOTICKS)
GUICtrlSetLimit(-1, $iAllBlinds[0], 1)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetData(-1, 1)
$groupPlayers = GUICtrlCreateGroup("Players", 8, 240, 185, 137)
$GroupBlinds = GUICtrlCreateGroup("Blinds", 8, 40, 185, 193)
$lblMinPlayers = GUICtrlCreateLabel("Min Players", 24, 264, 120, 17)
$SliderMinPlayers = GUICtrlCreateSlider(16, 288, 169, 20, $TBS_AUTOTICKS+$TBS_TOOLTIPS)
GUICtrlSetLimit(-1, 8,1)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetData(-1, 1)
$lblMaxPlayers = GUICtrlCreateLabel("Max Players", 24, 320, 120, 17)
$SliderMaxPlayers = GUICtrlCreateSlider(16, 336, 169, 20, $TBS_AUTOTICKS+$TBS_TOOLTIPS)
GUICtrlSetLimit(-1, 9, 2)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetData(-1, 1)
$chkSkipWindow = GUICtrlCreateCheckbox("Skip this window next time the bot starts", 8, 384, 233, 17)
$GroupLogging = GUICtrlCreateGroup("Logging", 208, 40, 233, 137)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$checkLogBlinds = GUICtrlCreateCheckbox("Log Blinds", 216, 88, 105, 17)
$checkLogAction = GUICtrlCreateCheckbox("Log Actions", 328, 88, 105, 17)
$checkLogCards = GUICtrlCreateCheckbox("Log Cards", 216, 112, 105, 17)
$checkLogScreen = GUICtrlCreateCheckbox("Take Screenshots", 328, 112, 105, 17)
$checkLogText = GUICtrlCreateCheckbox("Log Text", 216, 64, 105, 17)
$checkLogHandHistory = GUICtrlCreateCheckbox("Log Hand History", 328, 64, 105, 17)
$btExit = GUICtrlCreateButton("Exit", 336, 360, 105, 33, 0)
$GroupBrowser = GUICtrlCreateGroup("Browser", 208, 184, 233, 89)
$lblBrowserTitle = GUICtrlCreateLabel("Browser Title", 216, 211, 65, 17)
$InputBrowserTitle = GUICtrlCreateCombo("", 288, 208, 145, 21)
GUICtrlSetData(-1, "Internet Explorer|Mozilla Firefox|Google Chrome|Opera")
$LblBrowserFile = GUICtrlCreateLabel("Browser File", 216, 243, 61, 17)
$InputBrowserFile = GUICtrlCreateCombo("", 288, 240, 145, 21)
GUICtrlSetData(-1, "iexplore.exe|firefox.exe|chrome.exe|opera.exe")

$btLoadProfile = GUICtrlCreateButton("Load Profile", 212, 281, 105, 33, 0)
$btSaveProfile = GUICtrlCreateButton("Save Profile As", 212, 320, 105, 33, 0)

$btSaveChanges = GUICtrlCreateButton("Save Changes", 336, 320, 105, 33, 0)
$lblBuyIn = GUICtrlCreateLabel("Buy In: blinds", 24, 64, 140, 17)
$SliderBuyIn = GUICtrlCreateSlider(16, 80, 169, 20, $TBS_AUTOTICKS+$TBS_TOOLTIPS)
GUICtrlSetLimit(-1, 200, 10)
_GUICtrlSlider_SetTicFreq(-1, 5)
GUICtrlSetData(-1, 10)
GUICtrlSetTip(-1, "Buy in (in blinds)")
$lblPlayerFile = GUICtrlCreateLabel("Player File:", 8, 11, 55, 17)
$InputPlayerFile = GUICtrlCreateInput("", 64, 8, 105, 21)
$btEdit = GUICtrlCreateButton("...", 168, 8, 20, 22, 0)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$btResetSeatData = GUICtrlCreateButton("Reset Seat Data", 352, 8, 89, 25, 0)
$btDisableAutostart = GUICtrlCreateButton("Stop Autostart", 256, 8, 89, 25, 0)
#EndRegion ### END Koda GUI section ###
GUISetState(@SW_HIDE)

func _frmStart()
	if int(IniRead(@ScriptDir&"\settings.ini", "General", "HideStartupWindow",0)) = 1 then
		return _frmStart_Delete()
	endif
	$StartupWindowTransparent = int(IniRead(@ScriptDir&"\settings.ini", "General", "StartupWindowTransparent",0))
	IniWrite(@ScriptDir&"\settings.ini", "General", "StartupWindowTitle",$StartupWindowTitle)
	IniWrite(@ScriptDir&"\settings.ini", "General", "StartupWindowTransparent",$StartupWindowTransparent)
	IniWrite(@ScriptDir&"\settings.ini", "General", "StartupWindowTimeoutSec",$StartupWindowTimeoutSec)
	if IsHWnd ($frmStart) then
		GUISetState(@SW_SHOW,$frmStart)
		WinSetTitle($frmStart,"",$StartupWindowTitle)
		if $StartupWindowTransparent then WinSetTrans($frmStart,"",220)
	endif
	_frmStart_LoadSettings()
	While 1
		if $TimerCountdown <> 0 then
			$itimer = TimerDiff($TimerCountdown)
			if  $itimer > $StartupWindowTimeoutSec* 1000 Then
				_frmStart_SaveChanges()
				return _frmStart_Delete()
			endif
			if  round ($TimerCountdownLastUpdate/500) < round(TimerDiff($TimerCountdown)/500) then ;update every 500ms
				_updateCountdown()
			endif
		endif
		if _IsPressed("0D") and WinActive($frmStart) then
			_frmStart_SaveChanges()
			return _frmStart_Delete()
		EndIf

		$nMsg = GUIGetMsg()
		Switch $nMsg

		Case $GUI_EVENT_CLOSE
			Exit

		case $btSaveProfile
			_stopCountdown()
			DirCreate (@ScriptDir &"\data\profiles")
			$saveProfileAs = FileSaveDialog ("Save the Current Profile",@ScriptDir &"\data\profiles","Profiles (*.profile)",16,"new",$frmStart)
			if not @error then _SaveProfile($saveProfileAs)
		case $btLoadProfile
			_stopCountdown()
			DirCreate (@ScriptDir &"\data\profiles")
			$loadProfile = FileOpenDialog ("Load a Profile",@ScriptDir &"\data\profiles","Profiles (*.profile)",1,"",$frmStart)
			if not @error then _LoadProfile($loadProfile)
		Case $frmStart
			;close button
			exit
		case $btEdit
			_stopCountdown()
			$sPlayerinifile = @ScriptDir&"\"&GUICtrlRead($InputPlayerFile)&".ini"
			if not FileExists ($sPlayerinifile) then
				$sPlayerinifile = FileOpenDialog ("Select Ini file to edit",@ScriptDir,"Ini Files (*.ini)",1,"",$frmStart)
			endif
			if not @error  then
				if FileExists ($sPlayerinifile) then
					;ShellExecute ($sPlayerinifile)
					GUISetState (@SW_DISABLE,$frmStart)
					_frmEditIni($sPlayerinifile)
					GUISetState (@SW_ENABLE,$frmStart)
					WinActivate($frmStart)
				else
					msgbox (64,"Error","Cannot find file: "&@CRLF& $sPlayerinifile)
				endif
			endif
		Case $btStart
			_frmStart_SaveChanges()
			return _frmStart_Delete()
		Case $btResetSeatData
			$result = msgbox (32+4,"Delete Seat Data","Are you sure you want to delete your seat data?")
			switch $result
				case 6 ;yes
					FileDelete(@ScriptDir &"\data\seat\*.txt")
					msgbox (64,"Delete Seat Data",@ScriptDir &"\data\seat\*.txt"&@CRLF&"Done")
				case 7 ;no
			EndSwitch
			_stopCountdown()
		Case $SliderMinBlind
			_minblindupdate()
			_stopCountdown()
		Case $SliderMaxBlind
			_maxblindupdate()
			_stopCountdown()
		Case $SliderMinPlayers
			_minplayersupdate()
			_stopCountdown()
		Case $SliderMaxPlayers
			_maxplayersupdate()
			_stopCountdown()
		case $SliderBuyIn
			_tablebuyinupdate()
			_stopCountdown()
		case $InputBrowserFile
			_stopCountdown()
			switch GUICtrlRead($InputBrowserFile)
				case "iexplore.exe"
					guictrlsetdata ($InputBrowserTitle,"Internet Explorer")
				case "firefox.exe"
					guictrlsetdata ($InputBrowserTitle,"Mozilla Firefox")
				case "chrome.exe"
					guictrlsetdata ($InputBrowserTitle,"Google Chrome")
				case "opera.exe"
					guictrlsetdata ($InputBrowserTitle,"Opera")
			EndSwitch
		case $InputBrowserTitle
			_stopCountdown()
			switch GUICtrlRead($InputBrowserTitle)
				case "Internet Explorer"
					guictrlsetdata ($InputBrowserFile,"iexplore.exe")
				case "Mozilla Firefox"
					guictrlsetdata ($InputBrowserFile,"firefox.exe")
				case "Google Chrome"
					guictrlsetdata ($InputBrowserFile,"chrome.exe")
				case "Opera"
					guictrlsetdata ($InputBrowserFile,"opera.exe")
			EndSwitch
		Case $btExit
			exit
		Case $btSaveChanges
			_frmStart_SaveChanges()
			_stopCountdown()
		case $btDisableAutostart
			_stopCountdown()
		EndSwitch
	WEnd
EndFunc

func _frmStart_Delete()
	if IsHWnd($frmStart) then GUIDelete ($frmStart)
EndFunc

func _frmStart_SaveChanges()
	;SAVE TO INI
	$iniFile = @ScriptDir & "\settings.ini"
	$BotName = GUICtrlRead($InputPlayerFile)
	IniWrite($iniFile, "player", "player_file", $BotName)

	;log
	if GUICtrlRead($checkLogText) = $GUI_CHECKED Then
		$bLogText = 1
	else
		$bLogText = 0
	endif
	IniWrite($iniFile,  "Log", "log_text",$bLogText)

	if GUICtrlRead($checkLogHandHistory) = $GUI_CHECKED Then
		$bLogHand = 1
	else
		$bLogHand = 0
	endif
	IniWrite($iniFile,  "Log", "log_hand",$bLogHand)

	if GUICtrlRead($checkLogCards) = $GUI_CHECKED Then
		$logScreenCard = 1
	else
		$logScreenCard = 0
	endif
	IniWrite($iniFile,  "Log", "log_screen_card",$logScreenCard)

	if GUICtrlRead($checkLogBlinds) = $GUI_CHECKED Then
		$logScreenBlind = 1
	else
		$logScreenBlind = 0
	endif
	IniWrite($iniFile,  "Log", "log_screen_blind",$logScreenBlind)

	if GUICtrlRead($checkLogScreen) = $GUI_CHECKED Then
		$logScreenCapture = 1
	else
		$logScreenCapture = 0
	endif
	IniWrite($iniFile,  "Log", "log_screen_capture",$logScreenCapture)

	if GUICtrlRead($checkLogAction) = $GUI_CHECKED Then
		$logScreenAction = 1
	else
		$logScreenAction = 0
	endif
	IniWrite($iniFile, "Log", "log_screen_action",$logScreenAction)

	;table
	$tableBuyin = GUICtrlRead($SliderBuyIn)
	IniWrite($iniFile, "Table", "table_buyin", $tableBuyin)

	$iMinBlind = _LookupBlindbyID(GUICtrlRead($SliderMinBlind))
	IniWrite($iniFile, "Table", "table_min_blind", $iMinBlind)
	$iMaxBlind = _LookupBlindbyID(GUICtrlRead($SliderMaxBlind))
	IniWrite($iniFile, "Table", "table_max_blind", $iMaxBlind)
	$iMinPlayers = GUICtrlRead($SliderminPlayers)
	IniWrite($iniFile, "Table", "table_min_players", $iMinPlayers)
	$iMaXPlayers = GUICtrlRead($SliderMaxPlayers)
	IniWrite($iniFile, "Table", "table_max_players", $iMaXPlayers)


	;browser
	$browserFile = GUICtrlRead($InputBrowserFile)
	IniWrite ($iniFile, "Browser", "browser_file",$browserFile)
	$browserTitle = GUICtrlRead($InputBrowserTitle)
	IniWrite($iniFile, "Browser", "browser_title",$browserTitle)

	;hide this window next time
	$hideWindow = GUICtrlRead($chkSkipWindow)

	if GUICtrlRead($chkSkipWindow) = $GUI_CHECKED Then
		IniWrite($iniFile, "General", "HideStartupWindow",1)
	endif
EndFunc

func _frmStart_LoadSettings()
	;LOAD FROM INI
	$iniFile = @ScriptDir & "\settings.ini"
	Global $BotName = IniRead($iniFile, "Player", "player_file", "boomingranny")

	;log
	Global $bLogText = Int(IniRead($iniFile, "Log", "log_text", 0))
	Global $bLogHand = Int(IniRead($iniFile, "Log", "log_hand", 10))
	global $logScreenCard = Int(IniRead($iniFile, "Log", "log_screen_card", 0))
	Global $logScreenBlind = Int(IniRead($iniFile,"Log","log_screen_blind", 0))
	Global $logScreenCapture = Int(IniRead($iniFile, "Log", "log_screen_capture", 0))
	global $logScreenAction = Int(IniRead($iniFile, "Log", "log_screen_action", 0))

	;table
	Global $tableBuyin = Int(IniRead($iniFile, "Table", "table_buyin", 10))
	Global $iMinBlind = Int(IniRead($iniFile, "Table", "table_min_blind", 1))
	Global $iMaxBlind = Int(IniRead($iniFile, "Table", "table_max_blind", 2000000))
	Global $iMinPlayers = Int(IniRead($iniFile, "Table", "table_min_players", 6))
	Global $iMaXPlayers = Int(IniRead($iniFile, "Table", "table_max_players", 9))

	;browser
	global $browserFile = IniRead($iniFile, "Browser", "browser_file", "iexplore.exe")
	global $browserTitle =IniRead($iniFile, "Browser", "browser_title", "Internet Explorer")

	;SETUP GUI
	GUICtrlSetData($InputPlayerFile, $BotName)

	;log
	GUICtrlSetState($checkLogText,$bLogText)
	GUICtrlSetState($checkLogHandHistory,$bLogHand)
	GUICtrlSetState($checkLogCards,$logScreenCard)
	GUICtrlSetState($checkLogBlinds,$logScreenBlind)
	GUICtrlSetState($checkLogScreen,$logScreenCapture)
	GUICtrlSetState($checkLogAction,$logScreenAction)
	;table
	GUICtrlSetData($SliderBuyIn,$tableBuyin)
	_tablebuyinupdate()
	GUICtrlSetData($SliderMinBlind,_LookupBlindID($iMinBlind))
	_minblindupdate()
	GUICtrlSetData($SliderMaxBlind,_LookupBlindID($iMaxBlind))
	_maxblindupdate()
	GUICtrlSetData($SliderMinPlayers,$iMinPlayers)
	_minplayersupdate()
	GUICtrlSetData($SliderMaxPlayers,$iMaXPlayers)
	_maxplayersupdate()

	;browser
	guictrlsetdata ($InputBrowserFile,$browserFile)
	guictrlsetdata ($InputBrowserTitle,$browserTitle)

EndFunc

func _LookupBlindbyID($num)
	return int($iAllBlinds[$num])
EndFunc

func _LookupBlindID($num)
	for $i = 1 to $iAllBlinds[0]
		if $iAllBlinds[$i] = $num then return $i
	Next
EndFunc

func _tablebuyinupdate()
	local $i_buyin = GUICtrlRead($SliderBuyIn)
	$i_buyin = round($i_buyin/5)*5 ;round to 5
	GUICtrlSetData($SliderBuyIn,$i_buyin)
	GUICtrlSetData($lblBuyIn,"Buy In: "&$i_buyin&" blinds")
EndFunc

func _minblindupdate()
	$i_minblind = _LookupBlindbyID(GUICtrlRead($SliderMinBlind))
	GUICtrlSetData($lblMinBlind,"Min Blind: "&_blindfriendly($i_minblind))
	if GUICtrlRead($SliderMinBlind) > GUICtrlRead( $SliderMaxBlind) Then
		GUICtrlSetData($SliderMaxBlind,GUICtrlRead($SliderMinBlind))
		_maxblindupdate()
	endif
EndFunc

func _maxblindupdate()
	$i_maxblind = _LookupBlindbyID(GUICtrlRead($SlidermaxBlind))
	GUICtrlSetData($lblmaxBlind,"max Blind: "&_blindfriendly($i_maxblind))
	if GUICtrlRead($SlidermaxBlind) < GUICtrlRead( $SliderMinBlind) Then
		GUICtrlSetData($SliderMinBlind,GUICtrlRead($SlidermaxBlind))
		_minblindupdate()
	endif
EndFunc

func _minplayersupdate()
	local $i_MinPlayers = GUICtrlRead( $SliderMinPlayers)
	GUICtrlSetData($lblMinPlayers,"Min "&$i_MinPlayers&" Players")
	if $i_MinPlayers > GUICtrlRead( $SlidermaxPlayers) Then
		GUICtrlSetData($SlidermaxPlayers,$i_MinPlayers)
		_maxplayersupdate()
	endif
EndFunc

func _maxplayersupdate()
	local $i_maxPlayers = GUICtrlRead( $SlidermaxPlayers)
	GUICtrlSetData($lblmaxPlayers,"Max "&$i_maxPlayers&" Players")
	if $i_maxPlayers < GUICtrlRead( $SliderminPlayers) Then
		GUICtrlSetData($SliderminPlayers,$i_maxPlayers)
		_minplayersupdate()
	endif
EndFunc

func _blindfriendly($num)
	if $num >= 1000000 then return "$"&round($num/1000000)&"m"
	if $num >= 10000 then return "$"&round($num/1000)&"k"
	return "$"&$num
EndFunc

func _updateCountdown()
	if IsHWnd($frmStart) then
		WinSetTitle($frmStart,"",$StartupWindowTitle&" [Autostart in "&$StartupWindowTimeoutSec - round(TimerDiff($TimerCountdown)/1000)&"]")
		$TimerCountdownLastUpdate = TimerDiff($TimerCountdown)
	endif
EndFunc

func _stopCountdown()
	$TimerCountdown = 0
	WinSetTitle($frmStart,"",$StartupWindowTitle)
	GUICtrlDelete($btDisableAutostart)
EndFunc

func _SaveProfile($filename)
	_frmStart_SaveChanges() ;save any unsaved changes to the INI first before saving it into the profile folder
	if not StringInStr ($filename,".profile") then $filename &= ".profile" ;put the .profile on the end, if it is missing
	FileWriteLine ($filename,"zbot Profile Version 1.0")
	$filename = StringReplace($filename,".profile","");chop .profile off the end
	$pathnameLetters = StringInStr($filename,"\",0,-1)
	$filename = StringTrimLeft($filename,$pathnameLetters)
	$ProfilePath = @ScriptDir &"\data\profiles\"&$filename
	DirCreate ($ProfilePath)
	FileCopy (@ScriptDir &"\settings.ini",$ProfilePath,9) ;copy the current settings.ini
	FileCopy (@ScriptDir &"\"&GUICtrlRead($InputPlayerFile)&".ini",$ProfilePath,9) ;copy the current player.ini
	DirCreate ($ProfilePath&"\seat")
	FileCopy (@ScriptDir &"\data\seat\*.*",$ProfilePath&"\seat",9) ;copy seat data
EndFunc

func _LoadProfile($filename)
	$filename = StringReplace($filename,".profile","");chop .profile off the end
	$pathnameLetters = StringInStr($filename,"\",0,-1)
	$filename = StringTrimLeft($filename,$pathnameLetters)
	$ProfilePath = @ScriptDir &"\data\profiles\"&$filename
	FileCopy ($ProfilePath&"\*.ini",@ScriptDir ,9) ;copy the current settings.ini
	DirCreate (@ScriptDir &"\data\seat")
	FileCopy ($ProfilePath&"\seat\*.*",@ScriptDir &"\data\seat",9) ;copy seat data
	_frmStart_LoadSettings() ;load the new profile settings into the GUI
EndFunc
