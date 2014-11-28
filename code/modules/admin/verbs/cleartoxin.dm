/client/proc/cleartox()
	set category = "Special Verbs"
	set name = "Clear Toxin/Fire in Zone"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.gas["phoron_archived"] = null
	environment.gas["phoron"] = 0
	environment.gas["carbon_dioxide"] = 0
	environment.gas["carbon_dioxide_archived"] = null
	environment.gas["oxygen"] = 21.8366
	environment.gas["oxygen_archived"] = null
	environment.gas["nitrogen"] = 82.1472
	environment.gas["nitrogen_archived"] = null
	environment.gas["temperature_archived"] = null
	environment.temperature = 293.15
	environment.update_values()
	var/turf/simulated/location = get_turf(usr)
	if(location.zone)
		for(var/turf/T in location.zone.contents)
			for(var/obj/fire/F in T.contents)
				del(F)
		for(var/obj/fire/FF in world)
			del(FF)

/client/proc/fillspace()
	set category = "Special Verbs"
	set name = "Fill Space with floor"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/area/location = usr.loc.loc
	if(istype(location,/area/space))
		return
	if(location.name != "Space")
		for(var/turf/space/S in location)
			S.ChangeTurf(/turf/simulated/floor/plating)
		for(var/turf/simulated/floor/open/O in location)
			O.ChangeTurf(/turf/simulated/floor/plating)