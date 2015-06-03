
/proc/power_failure(var/announce = 1)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", new_sound = 'sound/AI/poweroff.ogg')

	rad_storm = 1

	for(var/obj/machinery/light/emergency/EL in world)
		EL.update()

	var/list/skipped_areas = list(/area/engine/engine_room, /area/engine/smes, /area/turret_protected/ai)

	for(var/obj/machinery/power/smes/S in world)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || !(S.z in config.station_levels))
			continue
		S.last_charge			= S.charge
		S.last_output_attempt	= S.output_attempt
		S.last_input_attempt 	= S.input_attempt
		S.charge = 0
		S.inputting(0)
		S.outputting(0)
		S.update_icon()
		S.power_change()


	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z in config.station_levels)
			C.cell.charge = 0
			C.operating = 0
			C.chargemode = 0
			C.update()
			C.update_icon()

/proc/power_restore(var/announce = 1)
	var/list/skipped_areas = list(/area/engine/engine_room, /area/engine/smes, /area/turret_protected/ai)

	rad_storm = 0

	for(var/obj/machinery/light/emergency/EL in world)
		EL.update()

	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z in config.station_levels)
			C.cell.charge = C.cell.maxcharge
			C.operating = 1
			C.chargemode = 1
			C.update()
			C.update_icon()

	for(var/obj/machinery/power/smes/S in world)
		var/area/current_area = get_area(S)
		if(current_area.type in skipped_areas || isNotStationLevel(S.z))
			continue
		S.charge = S.last_charge
		S.output_attempt = S.last_output_attempt
		S.input_attempt = S.last_input_attempt
		S.update_icon()
		S.power_change()

/proc/power_restore_quick(var/announce = 1)

	if(announce)
		command_announcement.Announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in world)
		if(isNotStationLevel(S.z))
			continue
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.output_attempt = 1
		S.input_attempt = 1
		S.update_icon()
		S.power_change()
