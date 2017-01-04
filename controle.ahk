#Persistent
#SingleInstance force
; checa o estado dos triggerButtons a cada 80ms
SetTimer, watchTriggerButton, 80 

; checa o estado dos padButtons a cada 80ms
SetTimer, watchPadButtons, 80

; checa o estado do joystick direito a cada 10ms
SetTimer, watchRightJoy, 10

; Macro Screen Shot:
screenShotCount = 1
screenShotFolder = desktop	; colocar aqui a pasta onde os screenshots ser�o salvos

; CALIBRAGEM controle do mouse com o joystick
; valores dos eixos do joystick direito quando parado
rightJoyParadoUpDown = 50
rightJoyParadoLeftRight = 50
; quanto maior o valor de sensibilidade, mais ser� preciso mover o joystick para mover o cursor
sensibilidade = 8

joyUp := rightJoyParadoUpDown - sensibilidade
joyDown := rightJoyParadoUpDown + sensibilidade
joyLeft := rightJoyParadoLeftRight - sensibilidade
joyRight := rightJoyParadoLeftRight + sensibilidade


;LB diminui 5 volume
Joy5::
While GetKeyState("Joy5","P"){
	SoundSet -5
	Sleep, 150
}
Return


;RB aumenta 5 volume
Joy6::
While GetKeyState("Joy6","P"){
	SoundSet +5
	Sleep, 150
}
Return

; Start muta/desmuta o �udio
Joy8::SoundSet, +1, , mute

; X � a seta pra esquerda, que no Netflix e no YouTube voltam 10 segundos do v�deo
Joy3::
While GetKeyState("Joy3","P"){
	Send {Left}
	Sleep, 100
}
Return

; B � a seta pra direita, que no Netflix e no YouTube avan�am 10 segundos do v�deo
Joy2::
While GetKeyState("Joy2","P"){
	Send {Right}
	Sleep, 100
}
Return

; A � Espa�o, que no Netflix e no YouTube s�o PLAY
Joy1::Space

; Y � F, que no Netflix e no Youtube s�o FullScreen
Joy4::F

; BackButton d� print screen 
Joy7::
{
	Send {PrintScreen}
	Run C:\Windows\System32\mspaint.exe
	Sleep 500	; espera meio segundo pra dar tempo de o paint abrir
	Send ^v		; CTRL+V
	Send ^s		; CTRL+S
	Sleep 500	; espera meio segundo pra dar tempo de a janela de salvar abrir
	Send ScreenShot%screenShotCount%
	screenShotCount++
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

; Controle dos bot�es do mouse com os triggerButtons
; RT = bot�o esquerdo do mouse
; LT = bot�o direito do mouse
watchTriggerButton:
	GetKeyState, triggerButton, JoyZ	
		if triggerButton < 10
			Click
		if triggerButton > 90
			MouseClick, right
	return

; R3 � o bot�o do meio do mouse
Joy10::MButton

; controle dos bot�es do PAD
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

; Joystick direito controla o mouse
watchRightJoy:
	moverMouse := false
	GetKeyState, rightJoyUpDown, JoyR
	GetKeyState, rightJoyLeftRight, JoyU
	; controle do movimento para cima e para baixo
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
	
; L3 fecha o script
Joy9::ExitApp





