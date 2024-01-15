/client/proc/respawn_as_self()
	set name = "Respawn as Current Character"
	set desc = "Respawn instantly with currenly loaded character on place."
	set category = "Special Verbs"

	if(!check_rights(R_SPAWN))
		return

	var/input = ckey(input(src, "Specify which key will be respawned as their character.", "Respawn as Current Character", "[usr.ckey]") as text)
	if(!input || input == "Cancel")
		return

	var/client/C
	for(var/client/find in GLOB.clients)
		if(find.ckey == input)
			C = find
			break

	if(!C)
		to_chat(usr, SPAN_WARNING("There is no active key like that in the game or the person is not currently a ghost."))
		return

	if(isnewplayer(C.mob))
		to_chat(usr, SPAN_WARNING("You can't use this on a new player."))
		return

	if(!C.prefs)
		to_chat(usr, SPAN_WARNING("No preferences or client found."))
		return

	var/mob/oldmob = C.mob
	var/mob/living/carbon/human/H = new(oldmob.loc)
	C.prefs.copy_to(H)
	H.key = C.key
	qdel(oldmob)
