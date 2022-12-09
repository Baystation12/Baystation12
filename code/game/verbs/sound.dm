/client/verb/stop_all_sounds()
	set name = "Stop All Sounds"
	set desc = "Stop all sounds that are currently playing."
	set category = "OOC"

	if(!mob) return
	sound_to(mob, sound(null))
