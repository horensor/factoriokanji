#SingleInstance force
#NoEnv
SendMode Input
IfExist, factoriokanji.ico
	Menu, Tray, Icon, factoriokanji.ico

Menu, Tray , DeleteAll
Menu, Tray , Add , ウィンドウ表示, GuiShow
Menu, Tray , Default, ウィンドウ表示

fkver:="FactorioKanji 0.1.3"

Menu, Tray , Tip, %fkver%

;初期変数
agreebackground:=1
ShowHotKey:="{vkF4}.{vkF3}"

Gui,+OwnDialogs
GUI, Font , S12 Q2, Meiryo UI
GUI, 2:Font , S12 Q2, Meiryo UI
WinSet, TransColor, CCCCCC 150
;Gui, -Caption	
Gui, Add, Text, x10 , FactorioKanji(Hide,Sendで常駐、Exitで終了)
Gui, Add, Edit, x10 W600 vEditString 
Gui, Add, Button, X+10 vSend GSubmit Default , Send
Gui, Add, Button, x+10 vHide GHide , Hide
Gui, Add, Button, x+10 vExit GExit , Exit
Gui, Add, Text, x10 , FactorioKanji起動キー:
Gui, Add, Combobox, x+10 vShowHotKey, 全角半角||{F1}|{Ins}|{Tab}|全角半角2|全角半角3
Gui, Add, Text, x+10 , チャット開始キー:
Gui, Add, Combobox, x+10 vChatHotKey, @||
Gui, Add, Button, x+10 GReloadHotKey , 更新
Gui, Add, Checkbox , x10 vShowAfterFactorio checked, チェックすると、Factorioを起動してないとき自動終了しません。
Gui, Add, Checkbox , x10 vShowFactorioChat , チェックすると、チャットモードにします。
Gui, Add, Checkbox , x10 vSaveFactorio , チェックすると、設定をFactorioKanji.iniに保存します。
Gui, Add, Button, x+10 GReloadHotKey , 更新
Gui, Add, Button, x10 vvevolution gViewEvolution, /&evolution
Gui, Add, Button, x+10 vvtime gViewTime ,/&time

IfExist, FactorioKanji.ini
{
	IniRead, SaveFactorio, FactorioKanji.ini, FactorioKanji, SaveFactorio
	if( SaveFactorio==1 ){
		GuiControl, , SaveFactorio, %SaveFactorio%
	
		IniRead, ShowAfterFactorio, FactorioKanji.ini, FactorioKanji, ShowAfterFactorio, 1
		GuiControl, , ShowAfterFactorio, %ShowAfterFactorio%
		IniRead, ShowFactorioChat, FactorioKanji.ini, FactorioKanji, ShowFactorioChat
		GuiControl, , ShowFactorioChat, %ShowFactorioChat%
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
GoSub, Main

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
			GuiControlGet, vv, Visible , EditString
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
	IniWrite, %ShowHotKey% , FactorioKanji.ini, FactorioKanji, ShowHotKey
	IniWrite, %ChatHotKey% , FactorioKanji.ini, FactorioKanji, ChatHotKey
}
return



GuiShow:
Gui, Show, , %fkver%
Guicontrol, Focus, Send
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


