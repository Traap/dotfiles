' https://medium.com/@bhupathy/install-terminator-on-windows-with-wsl-2826591d2156
set shell = WScript.CreateObject("Shell.Application")

if not IsProcessRunning("vcxsrv.exe") then
	shell.shellExecute "vcxsrv.exe", ":0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl -dpi auto", "C:\Program Files\VcXsrv\", "", 0
end if
shell.ShellExecute "bash", "-c -l ""DISPLAY=:0 terminator""", "", "open", 0

' https://stackoverflow.com/questions/19794726/vb-script-how-to-tell-if-a-program-is-already-running
Function IsProcessRunning( strProcess )
	Dim Process, strObject
	IsProcessRunning = False
	strObject = "winmgmts://."
	For Each Process in GetObject( strObject ).InstancesOf( "win32_process" )
	If UCase( Process.name ) = UCase( strProcess ) Then
		IsProcessRunning = True
		Exit Function
	End If
	Next
End Function