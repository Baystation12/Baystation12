
/proc/power_failure(var/announce = 1)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", new_sound = 'sound/AI/poweroff.ogg')

	rad_storm = 1

	for(var/obj/machinery/light/emergency/EL in world)
		EL.update()

	var/list/skipped_areas = list(/area/engine/engine_room, /area/engine/generators, /area/turret_protected/ai)

	for(var/obj/machinery/power/smes/S in world)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || S.z != 1)
			continue
		S.last_charge = S.charge
		S.last_output = S.output
		S.last_online = S.online
		S.charge = 0
		S.output = 0
		S.online = 0
		S.updateicon()
		S.power_change()


	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			C.cell.charge = 0
			C.operating = 0
			C.chargemode = 0
			C.update()
			C.update_icon()

/proc/power_restore(var/announce = 1)
	var/list/skipped_areas = list(/area/engine/engine_room, /area/engine/generators, /area/turret_protected/ai)

	rad_storm = 0

	for(var/obj/machinery/light/emergency/EL in world)
		EL.update()

	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			C.cell.charge = C.cell.maxcharge
			C.operating = 1
			C.chargemode = 1
			C.update()
			C.update_icon()

	for(var/obj/machinery/power/smes/S in world)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || S.z != 1)
			continue
		S.charge = S.last_charge
		S.output = S.last_output
		S.online = S.last_online
		S.updateicon()
		S.power_change()

/proc/power_restore_quick(var/announce = 1)

	if(announce)
		command_announcement.Announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in world)
		if(S.z != 1)
			continue
		S.charge = S.capacity
		S.output = S.output_level_max // Most new SMESs on map are of buildable type, and may actually have higher output limit than 200kW. Use max output of that SMES instead.
		S.online = 1
		S.updateicon()
		S.power_change()
