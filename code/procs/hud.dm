/* Using the HUD procs is simple. Call these procs in the life.dm of the intended mob.
Use the regular_hud_updates() proc before process_med_hud(mob) or process_sec_hud(mob) so
the HUD updates properly! */

// hud overlay image type, used for clearing client.images precisely
/image/hud_overlay
	appearance_flags = RESET_COLOR|RESET_TRANSFORM|KEEP_APART

//Medical HUD outputs. Called by the Life() proc of the mob using it, usually.
proc/process_med_hud(var/mob/M, var/local_scanner, var/mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, med_hud_users)
	for(var/mob/living/carbon/human/patient in P.Mob.in_view(P.Turf))

		if(patient.is_invisible_to(P.Mob))
			continue

		if(local_scanner)
			P.Client.images += patient.hud_list[HEALTH_HUD]
			P.Client.images += patient.hud_list[STATUS_HUD]
		else
			var/sensor_level = getsensorlevel(patient)
			if(sensor_level >= SUIT_SENSOR_VITAL)
				P.Client.images += patient.hud_list[HEALTH_HUD]
			if(sensor_level >= SUIT_SENSOR_BINARY)
				P.Client.images += patient.hud_list[LIFE_HUD]

//Security HUDs. Pass a value for the second argument to enable implant viewing or other special features.
proc/process_sec_hud(var/mob/M, var/advanced_mode, var/mob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, sec_hud_users)
	for(var/mob/living/carbon/human/perp in P.Mob.in_view(P.Turf))

		if(perp.is_invisible_to(P.Mob))
			continue

		P.Client.images += perp.hud_list[ID_HUD]
		if(advanced_mode)
			P.Client.images += perp.hud_list[WANTED_HUD]
			P.Client.images += perp.hud_list[IMPTRACK_HUD]
			P.Client.images += perp.hud_list[IMPLOYAL_HUD]
			P.Client.images += perp.hud_list[IMPCHEM_HUD]

datum/arranged_hud_process
	var/client/Client
	var/mob/Mob
	var/turf/Turf

proc/arrange_hud_process(var/mob/M, var/mob/Alt, var/list/hud_list)
	hud_list |= M
	var/datum/arranged_hud_process/P = new
	P.Client = M.client
	P.Mob = Alt ? Alt : M
	P.Turf = get_turf(P.Mob)
	return P

proc/can_process_hud(var/mob/M)
	if(!M)
		return 0
	if(!M.client)
		return 0
	if(M.stat != CONSCIOUS)
		return 0
	return 1

//Deletes the current HUD images so they can be refreshed with new ones.
mob/proc/handle_hud_glasses() //Used in the life.dm of mobs that can use HUDs.
	if(client)
		for(var/image/hud_overlay/hud in client.images)
			client.images -= hud
	med_hud_users -= src
	sec_hud_users -= src

mob/proc/in_view(var/turf/T)
	return view(T)

/mob/observer/eye/in_view(var/turf/T)
	var/list/viewed = new
	for(var/mob/living/carbon/human/H in mob_list)
		if(get_dist(H, T) <= 7)
			viewed += H
	return viewed
