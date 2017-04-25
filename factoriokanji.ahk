#SingleInstance force
#NoEnv

#InstallKeybdHook
#Persistent
#NoTrayIcon

fkver:="FactorioKanjiTest 0.3.0001"

SendMode Input
IfExist, factoriokanji.ico
	Menu, Tray, Icon, factoriokanji.ico

Menu, Tray , Tip, FactorioKanji

Menu, Tray , DeleteAll
Menu, Tray , Add , ウィンドウ表示, GuiShow
Menu, Tray , Default, ウィンドウ表示

Gui, 1: New, +HwndGuiHwndFK,%fkver% 
Gui, %GuiHwndFK%:Default 

;初期変数
agreebackground:=1
ShowHotKey:="{vkF4}{vkF3}"
ValueTranspare=180
histstrarr:=Object()

WinSetTitle,ahk_id %GuiHwndFK%, ,  %fkver%
WinSet, Transparent, 255
Gui, +Delimiter`n
Gui, Margin, 0, 0
GUI, Font , S12 Q2, Meiryo UI
Gui, Add, Tab3 , R1 vMainTab -Theme, Input`n`nOption`nAbout
Gui, Margin, 10, 10
Gui, Tab, 1, 1
Gui, Add, Text, Section , FactorioKanji(Hideで最小化、Exitで終了)
Gui, Add, ComboBox, W600 vEditString 
Gui, Add, Button, x+10 vSend GSubmit Default , Send
Gui, Add, Button, x+10 vHide GHide , Hide
Gui, Add, Button, x+10 vExit GExit , Exit
Gui, Add, Button, xs vToggleTranspare gToggleTranspare   , 透過切り替え(&&g)
Gui, Add, Button, xs vvevolution gViewEvolution, /&evolution
Gui, Add, Button, x+10 vvtime gViewTime ,/&time
Gui, Tab, 2
Gui, Add, Text, Section , FactorioKanji起動キー:
Gui, Add, Combobox, x+10 vShowHotKey, 全角半角`n`n{F1}`n{Ins}`n{Tab}`n全角半角2`n全角半角3
Gui, Add, Text, x+10 , チャット開始キー:
Gui, Add, Combobox, x+10 vChatHotKey, @`n`n
Gui, Add, Checkbox , xs vShowAfterFactorio checked, Factorio起動中か確認しない
Gui, Add, Checkbox , x+10 vShowTrayIcon , 通知領域にアイコンを表示
Gui, Add, Checkbox , x+10 vShowFactorioChat , チャットモード
Gui, Add, Text, xs , 透過度設定:
Gui, Add, Slider, x+10 AltSubmit gSlideTranspare Range0-9 TickInterval6 vSlideTranspare, 6 
Gui, Add, Combobox, x+10 vValueTranspare  gSetTranspare , 180`n`n
Gui, Add, Text, x+10 , 30-255
Gui, Add, Checkbox , x+10 vTranspare gSetTranspare , 透過する
Gui, Add, Checkbox , xs vSaveFactorio , チェックすると、設定をFactorioKanji.iniに保存します。
Gui, Add, Button, x+10 gReloadHotKey , 更新
Gui, Tab, 3
Gui, Add, Text, Section , FactorioKanji
Gui, Add, Text, xs, %fkver%
Gui, Add, Text, xs, Licenced under MIT X11 or GPL2 (C)horensor
Gui, Font, underline
Gui, Add, Text, xs cBlue gRunURL      , https://github.com/horensor/FactorioKanji
Gui, Font, norm
Gui, Show, AutoSize
Gui, Margin, 0, 0
Gui, Show, AutoSize

IfExist, FactorioKanji.ini
{
	IniRead, SaveFactorio, FactorioKanji.ini, FactorioKanji, SaveFactorio
	if( SaveFactorio==1 ){
		GuiControl, , SaveFactorio, %SaveFactorio%
		IniRead, ShowAfterFactorio, FactorioKanji.ini, FactorioKanji, ShowAfterFactorio, 1
		GuiControl, , ShowAfterFactorio, %ShowAfterFactorio%
		IniRead, ShowTrayIcon , FactorioKanji.ini, FactorioKanji, ShowTrayIcon , 0
		GuiControl, , ShowTrayIcon , %ShowTrayIcon%
		IniRead, ShowFactorioChat, FactorioKanji.ini, FactorioKanji, ShowFactorioChat
		GuiControl, , ShowFactorioChat, %ShowFactorioChat%
		IniRead, Transpare, FactorioKanji.ini, FactorioKanji, Transpare , 0
		GuiControl, , Transpare, %Transpare%
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
Gosub, ReloadHotKey
GoSub, GuiShow

Main:
Loop
{
	if( ShowFactorioChat !=0 )
		Input ,Key,T10 V, %ShowHotKey%%ChatHotKey%
	else
		Input ,Key,T10 V, %ShowHotKey%
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
	return "{vkF4}{vkF3}"
if( code=="全角半角2" )
	return "{vkF4}"
if( code=="全角半角3" )
	return "{vkF3}"
if( code=="全角半角4" )
	return "{vkF4sc029}{vkF3sc029}"
return code
}

DecodeZenHan(code){
if( code=="{vkF4}{vkF3}" )
	return "全角半角"
if( code=="{vkF4}.{vkF3}" )
	return "全角半角"
if( code=="{vkF4}" )
	return "全角半角2"
if( code=="{vkF3}" )
	return "全角半角3"
if( code=="{vkF4sc029}{vkF3sc029}" )
	return "全角半角4"
return code
}

ToggleTranspare:
GuiControlGet, tv, , Transpare
if(tv){
  tv=0
}else{
  tv=1
}
GuiControl, , Transpare, %tv%
Gosub, GuiTranspare
return

SlideTranspare:
GuiControlGet, vv, , SlideTranspare
vv:=vv*25+30
GuiControl, Text, ValueTranspare, %vv%
SetTranspare:
GuiControlGet, vv, , ValueTranspare
Gosub, GuiTranspare
return


GuiTranspare:
GuiControlGet, tv, , ValueTranspare
GuiControlGet, vv, , Transpare

if tv not between 0 and 255
	tv:=255
if(tv==255 or tv<30 or vv=0){
	WinSet, Transparent, off, ahk_id %GuiHwndFK%
	ttp=0
}else{
	WinSet, Transparent, %tv%, ahk_id %GuiHwndFK%
	ttp=1
}
return


ReloadHotKey:
Gui, Submit, NoHide
ShowHotKey:=EncodeZenHan(ShowHotKey)
ChatHotKey:=EncodeZenHan(ChatHotKey)
if( ShowAfterFactorio != 0 )
	agreebackground:=1
else
	agreebackground:=0

if( ShowTrayIcon )
	Menu, TRAY, Icon
else
	Menu, TRAY, NoIcon

if( SaveFactorio !=0 )
{
	IniWrite, %ShowAfterFactorio% , FactorioKanji.ini, FactorioKanji, ShowAfterFactorio
	IniWrite, %ShowTrayIcon% , FactorioKanji.ini, FactorioKanji, ShowTrayIcon
	IniWrite, %SaveFactorio% , FactorioKanji.ini, FactorioKanji, SaveFactorio
	IniWrite, %ShowFactorioChat% , FactorioKanji.ini, FactorioKanji, ShowFactorioChat
	IniWrite, %Transpare% , FactorioKanji.ini, FactorioKanji, Transpare
	IniWrite, %ValueTranspare% , FactorioKanji.ini, FactorioKanji, ValueTranspare
	IniWrite, %ShowHotKey% , FactorioKanji.ini, FactorioKanji, ShowHotKey
	IniWrite, %ChatHotKey% , FactorioKanji.ini, FactorioKanji, ChatHotKey
}
Gosub, GuiTranspare
return

GuiShow:
Gui, Show
Guicontrol, Focus, Send
Guicontrol, Choose, MainTab, 1
Guicontrol, Focus, EditString
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
	WinActivate, ahk_exe factorio.exe
	Send, %ChatHotKey%
	Send, {Enter}
	Send, {Enter}
	Send, %ChatHotKey%
	Send, %command%
	Send, {Enter}
}else{
	MsgBox, 起動中の factorio.exe が見つかりませんでした。
	return
}
GoSub, ReloadHotKey
return

Submit:
Gui, Submit, NoHide
ssstr:=EditString
;GuiControl, Text, EditString ,
if( ssstr != "" ){
  histstrarr.Insert(ssstr)
  if( histstrarr.Maxindex() > 50 ){
    histstrarr.Remove(1, histstrarr.Maxindex() - 50)
  }
  vstr := "`n"
  For k, v in histstrarr
    vstr := vstr  . v . "`n"
  vstr := vstr . " `n`n"
  GuiControl, , EditString, %vstr%
  IfWinExist, ahk_exe factorio.exe
  {
  	WinActivate, ahk_exe factorio.exe
  		SendRaw, %ssstr%
  	if( ShowFactorioChat != 0 )
  		Send, {Enter}
  }else{
  	MsgBox, 起動中の factorio.exe が見つかりませんでした。
  	return
  }
}
Hide:
GuiEscape:
GuiClose:
Gui, Submit, NoHide
GoSub, ReloadHotKey
IfWinExist, ahk_exe factorio.exe
	WinActivate, ahk_exe factorio.exe
Else 
if( ShowTrayIcon )
	Gui, Hide
Else
	Gui, Minimize
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


RunURL:
Run, https://github.com/horensor/FactorioKanji
return
