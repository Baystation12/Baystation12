/client/proc/cleartox()
	set category = "Special Verbs"
	set name = "DEBUG ONLY DO NOT USE YET. DOES NOT REMOVE TRACE GASES YET EITHER, IF IT WORKS AT ALL :D"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.gas["phoron_archived"] = null //Can I even do this? We'll find out.
	environment.gas["phoron"]= 0
	environment.gas["carbon_dioxide"] = 0
	environment.gas["carbon_dioxide_archived"] = null
	environment.gas["oxygen"]= 21.8366
	environment.gas["oxygen_archived"] = null
	environment.gas["nitrogen"] = 82.1472
	environment.gas["nitrogen_archived"] = null
	environment.gas["temperature_archived"] = null
	environment.gas["temperature"] = 293.15 //I have absolutely no idea how to atmos in code, jesus. This is a proper shot in the dark and it's 03:20 and oh god.
	var/turf/simulated/location = get_turf(usr)
	if(location.zone)
		for(var/turf/T in location.zone.contents)
			for(var/obj/fire/F in T.contents)
				del(F)
//		for(var/TG in environment.trace_gases) you lil undefined variable shit
//			del(TG)
		for(var/obj/fire/FF in world)
			del(FF)

/client/proc/fillspace()
	set category = "Special Verbs"
	set name = "Fill space with plating"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/area/location = usr.loc.loc
	if(location.name != "Space")
		for(var/turf/space/S in location)
			S.ChangeTurf(/turf/simulated/floor/plating)
	if(location.name == "Space")
		for(var/turf/space/S in range(2,usr.loc))
			S.ChangeTurf(/turf/simulated/floor/plating)