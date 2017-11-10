
    set MAYA_CMD_FILE_OUTPUT=%cd%/scriptEditorTrace.txt
    set MAYA_SCRIPT_PATH=%cd%;%MAYA_SCRIPT_PATH%
    "C:\Program Files\Autodesk\Maya2017\bin\maya.exe" -command "source script.mel; evalDeferred -lp (mayaBenchmark({1}));"
    