;=================================================================
; Terminate
;=================================================================
Func _TerminateConfirm()
   Local $confirm = MsgBox($MB_YESNO, "Confirm Exit" ,"Do you want to terminate the bot?")
   If $confirm <> $IDYES Then
	  Return
   EndIf
   _Terminate()
EndFunc

Func _Terminate()
   _Log('Terminating')
   _ClassifyClose()
   _GuiDelete()
   _Log('Terminated')
   Exit
EndFunc