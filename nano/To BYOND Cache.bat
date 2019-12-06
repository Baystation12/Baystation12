for /D %%i in ("%USERPROFILE%\Documents\BYOND\cache\*") do ( 
	copy css\* %%i /y
	copy images\* %%i /y
	copy js\* %%i /y
	copy templates\* %%i /y
)
