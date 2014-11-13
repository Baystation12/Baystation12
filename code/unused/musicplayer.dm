// this toggle doesn't save across rounds
/mob/verb/musictoggle()
	set name = "Toggle area specific music"
	set category = "Preferences"
	set desc = ".Toggle the area specific music. (Does not save across rounds)"
	if(src.be_music == 0)
		src.be_music = 1
		src << "\blue Area specific music toggled on!"
		return
	src.be_music = 0
	src << "\blue Area specific music toggled off!"

// This checks a var on each area and plays that var
/area/Entered(mob/A as mob)
	if (A && src.music != "" && istype(A, /mob) && A.be_music != 0 && (A.music_lastplayed != src.music))
		A.music_lastplayed = src.music
		A << sound(src.music, repeat = 0, wait = 0, volume = 20, channel = 1)
