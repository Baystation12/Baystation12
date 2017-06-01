/mob/living/deity/Stat()
	. = ..()
	statpanel("Status")
	stat(null, "Health: [health]/[maxHealth]")
	stat(null, "Power: [mob_uplink.uses]")
	stat(null, "Power Minimum: [power_min]")
	stat(null, "Structure Num: [structures.len]")
	stat(null, "Minion Num: [minions.len]")
	var/boon_name = "None"
	if(current_boon)
		if(istype(current_boon, /spell))
			var/spell/S = current_boon.
			boon_name = S.name
		else
			var/obj/O = current_boon
			boon_name = O.name
	stat(null, "Current Boon: [boon_name]")