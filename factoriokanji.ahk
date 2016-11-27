#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance ;同じスクリプトを複数起動できないようにする
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Icon, factoriokanji.ico

;初期変数
agreebackground:=0


MainLoop:
;メインループ
Loop
{
	;Factorio.exeが起動しているか
	IfWinExist, ahk_exe Factorio.exe
	{
		agreebackground=0
		;@が入力されるまで5秒待つ．もしチャット開始キーが違う場合は最後の@の部分をそのキーに変更
		Input ,Key,T5 V,{vkF4sc029}
		;タイムアウトの場合
		If ErrorLevel = Timeout
			Continue
	}Else{
		;ループから抜ける
		Break
	}

	;Factorio.exeがアクティブだった場合
	IfWinActive, ahk_exe Factorio.exe
	{
		;入力のボックスを表示させる
		InputBox, OutputVar , チャット入力, 文字を入力してください, , 375, 130

		;ウィンドウフォーカスをFactorio.exeに変更
		Process,Exist,Factorio.exe
		If ErrorLevel<>0
			WinActivate,ahk_pid %ErrorLevel%
		if( StrLen(%OutputVar%) > 0 ){
			;クリップボードに取得した文字列を代入
			clipboard = %OutputVar%
			;キー入力
			Send, ^v
		}
	}else{
	return
	}
}
;メッセージ表示

if( agreebackground=0 )
MsgBox,1,, Factorioが起動していませんが終了しますか?
;MsgBox, Factorioが起動していないため終了します
;プログラム終了
IfMsgBox, Ok 
	ExitApp
agreebackground:=1
Goto, MainLoop
