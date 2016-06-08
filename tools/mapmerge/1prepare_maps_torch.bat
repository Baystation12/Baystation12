cd ../../maps/torch

FOR %%f IN (*.dmm) DO (
  copy %%f %%f.backup
)

pause
