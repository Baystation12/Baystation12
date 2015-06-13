SET z_levels=6
cd ../../maps

FOR /L %%i IN (1,1,%z_levels%) DO (
  copy exodus-%%i.dmm exodus-%%i.dmm.backup
)

pause
