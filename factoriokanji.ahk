#SingleInstance force
#NoEnv
SendMode Input
IfExist, factoriokanji.ico
  Menu, Tray, Icon, factoriokanji.ico

Menu, Tray , DeleteAll
Menu, Tray , Add , ウィンドウ表示, GuiShow
Menu, Tray , Default, ウィンドウ表示

fkver:="FactorioKanji 0.1.1"

Menu, Tray , Tip, %fkver%

;初期変数
agreebackground:=0
ShowHotKey:="{vkF4sc029}.{vkF3sc029}"

GUI, Font , S12 Q2, Meiryo UI
GUI, 2:Font , S12 Q2, Meiryo UI
WinSet, TransColor, CCCCCC 150
;Gui, -Caption  
Gui, Add, Text ,, FactorioKanji(Hide,Sendで常駐、Exitで終了)
Gui, Add, Edit, x10 W600 vEditString 
Gui, Add, Button, X+10 vSend GSubmit Default , Send
Gui, Add, Button, x+10 vHide GHide , Hide
Gui, Add, Button, x+10 vExit GExit , Exit
Gui, Add, Checkbox , x10 vShowAfterFactorio checked, チェックすると、Factorioの起動してないときはポップアップしません。
Gui, Add, Combobox, x+10 vShowHotKey, 全角半角||{F1}|{Ins}|全角半角2
Gui, Add, Button, x+10 GReloadHotKey , ホットキー更新
Gui, Add, Checkbox , x10 vShowFactorioChat , チェックすると、@キーで起動します。(チャットモード)
Gui, Add, Button, x+10 GReloadHotKey , 更新

Gosub, GuiShow
gosub, Main

Main:
Loop
{
	Input ,Key,T10 V, %ShowHotKey%
	If ErrorLevel = Timeout
	{
		IfWinExist, ahk_exe Factorio.exe
		{
			Continue
		}else{
			if( agreebackground==0 )
				Gosub, GuiShow
		}
	}

	IfWinActive, ahk_exe Factorio.exe
	{
		Gosub, GuiShow
	}
}
return

ReloadHotKey:
Gui, Submit
if( ShowHotKey=="全角半角" )
  ShowHotKey:="{vkF4sc029}.{vkF3sc029}"
if( ShowHotKey=="全角半角2" )
  ShowHotKey:="{vkF4sc029}"
if( ShowHotKey=="全角半角3" )
  ShowHotKey:="{vkF3sc029}"

if( ShowAfterFactorio != 0 )
	agreebackground:=1
if( ShowFactorioChat !=0 )
  ShowHotKey := ShowHotKey . ".@"

return

GuiShow:
Gui, Show, , %fkver%
Guicontrol, Focus, Send
Guicontrol, Focus, EditString
return

Pause::
msgbox, %ShowHotKey%

Submit:
Gui, Submit
Hide:
if( EditString!="" )
	Send, %EditString%
if( ShowFactorioChat != 0 )
	Send, {Enter}

GuiControl, Text, EditString ,
gosub,ReloadHotKey
return

GuiHide:
{
Gui, Hide
}
return

Exit:
{
ExitApp
}
return


