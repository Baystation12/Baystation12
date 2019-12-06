@echo off
cd %~dp0
for %%f in (*.hook) do (
	echo Installing hook: %%~nf
	copy %%f ..\..\.git\hooks\%%~nf >nul
)
for %%f in (*.merge) do (
	echo Installing merge driver: %%~nf
	echo [merge "%%~nf"]^

	driver = tools/hooks/%%f %%P %%O %%A %%B %%L >> ..\..\.git\config
)
echo Done
pause
