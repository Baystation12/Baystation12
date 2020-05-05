
/datum/event/ion_storm
	endWhen = 10
	var/obj/machinery/overmap_comms/jammer/jammer

/datum/event/ion_storm/announce()
	command_announcement.Announce("Temporary telecommunication failure imminent in [system_name()].", "Ionospheric Perturbations Detected", new_sound = 'sound/AI/ionstorm.ogg')

/datum/event/ion_storm/start()
	endWhen *= severity

	//a virtual jammer to jam all comms
	jammer = new(null)
	jammer.active = 1
	for(var/level in map_sectors)
		var/obj/effect/overmap/sector = map_sectors[level]
		sector.telecomms_jammers.Add(jammer)
/*
	for(var/obj/machinery/overmap_comms/receiver/R in world)
		R.emp_act(severity)

	for(var/obj/item/device/radio/R in GLOB.all_radios)
		R.emp_act(severity)
*/
/datum/event/ion_storm/end()
	for(var/level in map_sectors)
		var/obj/effect/overmap/sector = map_sectors[level]
		sector.telecomms_jammers.Remove(jammer)
	qdel(jammer)
