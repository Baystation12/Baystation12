/mob/living/deity/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Health", "[health]/[maxHealth]")
		stat("Power", mob_uplink.uses)
		stat("Power Minimum", power_min)
		stat("Structure Num", structures.len)
		stat("Minion Num", minions.len)
		var/boon_name = "None"
		if(current_boon)
			if(istype(current_boon, /spell))
				var/spell/S = current_boon.
				boon_name = S.name
			else
				var/obj/O = current_boon
				boon_name = O.name
		stat("Current Boon",boon_name)