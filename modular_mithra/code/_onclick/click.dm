//This file works together with our non-modular edit in click.dm in order to implement the shift-middle-click to point shortcut.

/mob/proc/ShiftMiddleClickOn(atom/A)
	src.pointed(A)
	return