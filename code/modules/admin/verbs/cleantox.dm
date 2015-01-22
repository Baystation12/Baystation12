/client/proc/cleartox()
	set category = "Special Verbs"
	set name = "Clear Toxin/Fire in Zone"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/datum/gas_mixture/environment = usr.loc.return_air()
	environment.phoron_archived = null
	environment.phoron = 0
	environment.carbon_dioxide = 0
	environment.carbon_dioxide_archived = null
	environment.oxygen= 21.8366
	environment.oxygen_archived = null
	environment.nitrogen = 82.1472
	environment.nitrogen_archived = null
	environment.temperature_archived = null
	environment.temperature = 293.15
	var/turf/simulated/location = get_turf(usr)
	if(location.zone)
		for(var/turf/T in location.zone.contents)
			for(var/obj/fire/F in T.contents)
				del(F)
		for(var/TG in environment.trace_gases)
			del(TG)
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