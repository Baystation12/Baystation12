SET z_levels=6
cd 

FOR /L %%i IN (1,1,%z_levels%) DO (
  java -jar MapPatcher.jar -clean ../../maps/aphelion-%%i.dmm.backup ../../maps/aphelion-%%i.dmm ../../maps/aphelion-%%i.dmm
)

pause