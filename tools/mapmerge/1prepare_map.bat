SET z_levels=6
cd ../../maps

FOR /L %%i IN (1,1,%z_levels%) DO (
  copy aphelion-%%i.dmm aphelion-%%i.dmm.backup
)

pause
