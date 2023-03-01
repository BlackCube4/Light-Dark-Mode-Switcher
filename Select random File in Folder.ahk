FileList := []
FileList := FileGetList(A_ScriptDir)

Random, RandomIndex, 1, FileList.MaxIndex()
RandomFile := FileList[RandomIndex]
MsgBox % "Randomly selected file: " . RandomFile


FileGetList(FolderPath) {
    OutputArray := []
    Loop, Files, %FolderPath%\*.*, F
        OutputArray.Push(A_LoopFileName)
    Return OutputArray
}
