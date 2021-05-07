;=================================================================
; Terminate
;=================================================================
Func _Terminate()
   If @GUI_CtrlId == $guiClose Then
	  Local $confirm = MsgBox($MB_YESNO, "Confirm Exit" ,"Do you want to terminate the bot?")
	  If $confirm <> $IDYES Then
		 Return
	  EndIf
   EndIf
   _Log('Terminating')
   _ClassifyClose()
   _GuiDelete()
   _Log('Terminated')
   Exit
EndFunc