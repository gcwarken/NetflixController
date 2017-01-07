; CONFIG -------------------------------------------------------------------------------------------------

; Macro Screen Shot:
screenShotFolder = desktop	; write here the folder you want to save the screenshots (desktop as default)

; Joystick mouse control calibration: idle joystick axis values
rightJoyParadoUpDown = 50
rightJoyParadoLeftRight = 50
; Joystick sensibility: the higher the number, the lesser the sensibility
sensibility = 8

; SCRIPT -------------------------------------------------------------------------------------------------
#Persistent
#SingleInstance force

joyUp := rightJoyParadoUpDown - sensibility
joyDown := rightJoyParadoUpDown + sensibility
joyLeft := rightJoyParadoLeftRight - sensibility
joyRight := rightJoyParadoLeftRight + sensibility

; check trigger buttons state every 80ms
SetTimer, watchTriggerButton, 80 

; check directional pad butons state every 80ms
SetTimer, watchPadButtons, 80

; check right joystick state every 10ms
SetTimer, watchRightJoy, 10


;LB turns the volume down by 5
Joy5::
While GetKeyState("Joy5","P"){
	SoundSet -5
	Sleep, 150
}
Return


;RB turns the volume up by 5
Joy6::
While GetKeyState("Joy6","P"){
	SoundSet +5
	Sleep, 150
}
Return

; Start mutes/unmutes audio
Joy8::SoundSet, +1, , mute

; X/blue presses the left key (video backward in Netflix and Youtube)
Joy3::
While GetKeyState("Joy3","P"){
	Send {Left}
	Sleep, 100
}
Return

; B/red presses the right key (video forward in Netflix and Youtube)
Joy2::
While GetKeyState("Joy2","P"){
	Send {Right}
	Sleep, 100
}
Return

; A/green presses Space (play/pause in Netflix and Youtube)
Joy1::Space

; Y/yellow presses F (toggle fullscreen in Netflix and Youtube)
Joy4::F

; BackButton saves a screenshot in the selected folder 
Joy7::
{
	FormatTime, CurrentDateTime,, yy-MM-dd HH.mm
	Send {PrintScreen}
	Run C:\Windows\System32\mspaint.exe
	Sleep 500	; espera meio segundo pra dar tempo de o paint abrir
	Send ^v		; CTRL+V
	Send ^s		; CTRL+S
	Sleep 500	; espera meio segundo pra dar tempo de a janela de salvar abrir
	Send ScreenShot{Space}%CurrentDateTime%
	Send {F4}	; leva o vursor pra caixa onde se seleciona a pasta para salvar
	Send ^a		; CTRL+A
	Send %screenShotFolder%	; seleciona a pasta escolhida para salvar os screenshots
	Send {Enter}
	Send, +{tab}
	Send, +{tab}
	Send {Enter}
	Send !{F4}
	Return
}

; Control mouse clicks with the trigger buttons
; RT = left click
; LT = right click
watchTriggerButton:
	GetKeyState, triggerButton, JoyZ	
		if triggerButton < 10
			Click
		if triggerButton > 90
			MouseClick, right
	return

; R3 = mouse middle button click (useful to close browser tabs)
Joy10::MButton

; Directional pad control
; padUp = mouseWheelUp
; padDown =  mouseWheelDown
; padLeft = 4th mouse button (browser back)
; padRighte = 5th mouse button (browser forward)
watchPadButtons:
	GetKeyState, padButton, JoyPOV	
		if (padButton = 0)		; padUp
			MouseClick, WheelUp
		if (padButton = 18000)	; padDown
			MouseClick, WheelDown
		if (padButton = 27000)	; padLeft
			MouseClick, X1
		if (padButton = 9000)	; padRight
			MouseClick, X2
	return

; Right joystick controls the mouse cursor
watchRightJoy:
	moverMouse := false
	GetKeyState, rightJoyUpDown, JoyR
	GetKeyState, rightJoyLeftRight, JoyU
	; Up/Down control
	if rightJoyUpDown < %joyUp%					; moveu joy para cima 
	{				
		moverMouse := true
		deltaY := rightJoyUpDown - joyUp
	} 
	else if rightJoyUpDown > %joyDown%			; moveu joy para baixo
	{
		moverMouse := true
		deltaY := rightJoyUpDown - joyDown	
	}
	else
		deltaY = 0
	; Left/Right control
	if rightJoyLeftRight < %joyLeft%			; moveu joy para esquerda
	{			
		moverMouse := true
		deltaX := rightJoyLeftRight - joyLeft
	} 
	else if rightJoyLeftRight > %joyRight%		; moveu joy para direita
	{	
		moverMouse := true
		deltaX := rightJoyLeftRight - joyRight
	} 
	else
		deltaX = 0	
	
	if moverMouse
	{
		SetMouseDelay, -1
		MouseMove, deltaX, deltaY, , R
	}
	return
	
; L3 terminates the script
Joy9::ExitApp
