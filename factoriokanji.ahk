#SingleInstance force
#NoEnv
SendMode Input
IfExist, factoriokanji.ico
	Menu, Tray, Icon, factoriokanji.ico

Menu, Tray , DeleteAll
Menu, Tray , Add , ウィンドウ表示, GuiShow
Menu, Tray , Default, ウィンドウ表示

fkver:="FactorioKanji 0.1.4"

Menu, Tray , Tip, %fkver%

;初期変数
agreebackground:=1
ShowHotKey:="{vkF4}.{vkF3}"
ValueTranspare=180

;Gui, +AlwaysOnTop +LastFound   
WinSet, Transparent, 255
Gui, Margin, 0, 0
GUI, Font , S12 Q2, Meiryo UI
GUI, 2:Font , S12 Q2, Meiryo UI
Gui, Add, Tab2 , R1 vMainTab , Input||Option
Gui, Margin, 10, 10
Gui, Tab, 1, 1
Gui, Add, Text, Section , FactorioKanji(Hide,Sendで常駐、Exitで終了)
Gui, Add, Edit, W600 vEditString 
Gui, Add, Button, x+10 vSend GSubmit Default , Send
Gui, Add, Button, x+10 vHide GHide , Hide
Gui, Add, Button, x+10 vExit GExit , Exit
Gui, Add, Button, xs vToggleTranspare gToggleTranspare   , 透過切り替え(&&&g)
Gui, Add, Button, xs vvevolution gViewEvolution, /&evolution
Gui, Add, Button, x+10 vvtime gViewTime ,/&time
Gui, Tab, 2
Gui, Add, Text, Section , FactorioKanji起動キー:
Gui, Add, Combobox, x+10 vShowHotKey, 全角半角||{F1}|{Ins}|{Tab}|全角半角2|全角半角3
Gui, Add, Text, x+10 , チャット開始キー:
Gui, Add, Combobox, x+10 vChatHotKey, @||
Gui, Add, Button, x+10 GReloadHotKey , 更新
Gui, Add, Checkbox , xs vShowAfterFactorio checked, チェックすると、Factorioを起動してないとき自動終了しません。
Gui, Add, Checkbox , x+10 vShowFactorioChat , チャットモード
Gui, Add, Text, xs , 透過度設定:
Gui, Add, Slider, x+10 AltSubmit gSlideTranspare Range0-9 TickInterval6 vSlideTranspare, 6 
Gui, Add, Combobox, x+10 vValueTranspare   , 180||
Gui, Add, Text, x+10 , 10-255
Gui, Add, Checkbox , xs vSaveFactorio , チェックすると、設定をFactorioKanji.iniに保存します。
Gui, Add, Button, x+10 GReloadHotKey , 更新
Gui, Margin, 0, 0

Gui, Show, , WinControl script
WinGetPos,,, ww, hh, WinControl script
ww+=10
hh+=10
GuiControl, Move, MainTab, w%ww% h%hh%
Gui, Show, AutoSize, WinControl script


IfExist, FactorioKanji.ini
{
	IniRead, SaveFactorio, FactorioKanji.ini, FactorioKanji, SaveFactorio
	if( SaveFactorio==1 ){
		GuiControl, , SaveFactorio, %SaveFactorio%
		IniRead, ShowAfterFactorio, FactorioKanji.ini, FactorioKanji, ShowAfterFactorio, 1
		GuiControl, , ShowAfterFactorio, %ShowAfterFactorio%
		IniRead, ShowFactorioChat, FactorioKanji.ini, FactorioKanji, ShowFactorioChat
		GuiControl, , ShowFactorioChat, %ShowFactorioChat%
		IniRead, ValueTranspare, FactorioKanji.ini, FactorioKanji, ValueTranspare , 180
		GuiControl, , ValueTranspare, %ValueTranspare%
		GuiControl, ChooseString, ValueTranspare, %ValueTranspare%
		if(ValueTranspare>10){
			vv:=floor( ( ValueTranspare - 5 ) / 25 -  1 )
			GuiControl, , SlideTranspare, %vv%
		}

		IniRead, ShowHotKey, FactorioKanji.ini, FactorioKanji, ShowHotKey
		if(ShowHotKey){
			ShowHotKey:=DecodeZenHan(ShowHotKey)
			try{
				GuiControl, ChooseString, ShowHotKey, %ShowHotKey%
			}catch{
				GuiControl, , ShowHotKey, %ShowHotKey%
				GuiControl, ChooseString, ShowHotKey, %ShowHotKey%
			}
		}
		IniRead, ChatHotKey, FactorioKanji.ini, FactorioKanji, ChatHotKey
		if(ChatHotKey){
			ChatHotKey:=DecodeZenHan(ChatHotKey)
			try{
				GuiControl, ChooseString, ChatHotKey, %ChatHotKey%
			}catch{
				GuiControl, , ChatHotKey, %ChatHotKey%
				GuiControl, ChooseString, ChatHotKey, %ChatHotKey%
			}
		}
	}
}
GoSub, GuiShow

Main:
Loop
{
	if( ShowFactorioChat !=0 )
		Input ,Key,T2 V, %ShowHotKey% . "." . %ChatHotKey%
	else
		Input ,Key,T2 V, %ShowHotKey%
	If ErrorLevel = Timeout
	{
		IfWinExist, ahk_exe factorio.exe
		{
			Continue
		}else{
			GuiControlGet, vv, Visible , MainTab
			if( vv == 0 )
			if( agreebackground==0 )
				Gosub, Exit
		}
	}

	IfWinActive, ahk_exe factorio.exe
	{
		Gosub, GuiShow
	}
}
return

EncodeZenHan(code){
if( code=="全角半角" )
	return "{vkF4}.{vkF3}"
if( code=="全角半角2" )
	return "{vkF4}"
if( code=="全角半角3" )
	return "{vkF3}"
return code
}

DecodeZenHan(code){
if( code=="{vkF4}.{vkF3}" )
	return "全角半角"
if( code=="{vkF4sc029}.{vkF3sc029}" )
	return "全角半角"
if( code=="{vkF4}" )
	return "全角半角2"
if( code=="{vkF3}" )
	return "全角半角3"
return code
}

ToggleTranspare:
GuiControlGet, vv, , ValueTranspare
if vv not between 0 and 255
	vv:=255
if(vv==255 or vv<10)
	ttp=1
if(ttp){
	WinSet, Transparent, off
	ttp=0
}else{
	WinSet, Transparent, %vv%
	ttp=1
}
return

SlideTranspare:
GuiControlGet, vv, , SlideTranspare
vv:=vv*25+30
GuiControl, Text, ValueTranspare, %vv%
if vv not between 0 and 255
	vv:=255
if(vv==255 or vv<10){
	WinSet, Transparent, off
	ttp=0
}else{
	WinSet, Transparent, %vv%
	ttp=1
}
return

ReloadHotKey:
Gui, Submit
ShowHotKey:=EncodeZenHan(ShowHotKey)
ChatHotKey:=EncodeZenHan(ChatHotKey)
if( ShowAfterFactorio != 0 )
	agreebackground:=1
else
	agreebackground:=0

if( SaveFactorio !=0 )
{
	IniWrite, %ShowAfterFactorio% , FactorioKanji.ini, FactorioKanji, ShowAfterFactorio
	IniWrite, %SaveFactorio% , FactorioKanji.ini, FactorioKanji, SaveFactorio
	IniWrite, %ShowFactorioChat% , FactorioKanji.ini, FactorioKanji, ShowFactorioChat
	IniWrite, %ValueTranspare% , FactorioKanji.ini, FactorioKanji, ValueTranspare
	IniWrite, %ShowHotKey% , FactorioKanji.ini, FactorioKanji, ShowHotKey
	IniWrite, %ChatHotKey% , FactorioKanji.ini, FactorioKanji, ChatHotKey
}
return



GuiShow:
Gui, Show, , %fkver%
Guicontrol, Focus, Send
Guicontrol, Choose, MainTab, 1
Guicontrol, Focus, EditString
return


Pause::
msgbox, %ShowHotKey%
return


ViewEvolution:
command := "/evolution"
Gosub, SubmitCommand
return

ViewTime:
command := "/time"
Gosub, SubmitCommand
return


SubmitCommand:
IfWinExist, ahk_exe factorio.exe 
{
	WinActivate
	Send, %ChatHotKey%
	Send, {Enter}
	Send, {Enter}
	Send, %ChatHotKey%
	Send, %command%
	Send, {Enter}
}else{
	MsgBox, factorio.exe Windowが見つかりませんでした。
	return
}
GoSub, ReloadHotKey
return

Submit:
Gui, Submit
GuiControl, Text, EditString ,
IfWinExist, ahk_exe factorio.exe
{
	WinActivate
	if( EditString!="" )
		Send, %EditString%
	if( ShowFactorioChat != 0 )
		Send, {Enter}
}else{
	MsgBox, factorio.exe Windowが見つかりませんでした。
	return
}
Hide:
GuiEscape:
GuiCloase:
Gui, Submit
GuiControl, Text, EditString ,
GoSub, ReloadHotKey
return

GuiHide:
{
Gui, Hide
}
return

Exit:
Gosub, ReloadHotKey
MsgBox,260,Exit FactorioKanji, FactorioKanjiを終了します。`n(10秒以内にいいえでキャンセルできます), 10
IfMsgBox, No
	Gosub, GuiShow
IfMsgBox, Timeout
	ExitApp
IfMsgBox, Yes
	ExitApp
return


