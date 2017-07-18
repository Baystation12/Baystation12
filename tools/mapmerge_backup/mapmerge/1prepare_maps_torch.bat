cd ../../maps/torch

FOR /R %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
