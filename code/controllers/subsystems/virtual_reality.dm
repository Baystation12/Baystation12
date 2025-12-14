GLOBAL_LIST_AS(active_vr_areas , list())
GLOBAL_LIST_AS(vr_areas, list(
	"Plaza" = /area/virtual_reality/plaza,
	"Courtroom" = /area/virtual_reality/courtroom,
	"Meeting Hall" = /area/virtual_reality/meeting_hall,
	"Theatre" = /area/virtual_reality/theatre,
	"Cafe" = /area/virtual_reality/cafe,
	"Temple" = /area/virtual_reality/temple,
	"Boxing Ring" = /area/virtual_reality/boxing_ring,
	"Empty Court" = /area/virtual_reality/empty_court,
	"Volleyball Court" = /area/virtual_reality/volleyball_court,
	"Basketball Court" = /area/virtual_reality/basketball_court,
	"Thunderdome" = /area/virtual_reality/thunderdome,
	"Beach" = /area/virtual_reality/beach,
	"Snowy Field" = /area/virtual_reality/snowfield,
	"Picnic Area" = /area/virtual_reality/picnic_area,
	"Desert" = /area/virtual_reality/desert,
	"Space" = /area/virtual_reality/space,
	"Infirmary" = /area/virtual_reality/infirmary
))
GLOBAL_LIST_AS(emagged_vr_areas, list(
	"Shady Room" = /area/virtual_reality/shady_room
))


/// Keeps tabs on every client currently in VR, as well as every occupant and very virtual mob.
/// If an occupant is no longer valid in VR (i.e. pod depowered), it will yank them out and put them into their original mob.
SUBSYSTEM_DEF(virtual_reality)
	name = "VR"
	priority = SS_PRIORITY_VR
	init_order = SS_INIT_DEFAULT
	wait = 0.5 SECONDS

	var/list/virtual_mobs_to_occupants = list()		// Associative list of /mob/living => /mob/living. Each virtual mob is tied to its occupant.
	var/list/virtual_occupants_to_mobs = list()		// Reverse of previous list, in case one is missing but not the other.
	var/list/virtual_clients = list()				// Associative list of /client => /mob/living. Each client is linked to its virtual mob.
	var/list/was_warned = list()					// A list of clients that have already received the disclaimer message when entering VR.
	var/list/simulated_objects = list()				// A list of all objects created inside of VR, for easy cleanup.

/datum/controller/subsystem/virtual_reality/Initialize(start_timeofday)
	GLOB.active_vr_areas["Zone 1"] = locate(/area/virtual_reality/zone1)
	GLOB.active_vr_areas["Zone 2"] = locate(/area/virtual_reality/zone2)
	GLOB.active_vr_areas["Zone 3"] = locate(/area/virtual_reality/zone3)
	GLOB.vr_spawns["Zone 1"] = list()
	GLOB.vr_spawns["Zone 2"] = list()
	GLOB.vr_spawns["Zone 3"] = list()
	. = ..()

/datum/controller/subsystem/virtual_reality/fire(resumed = FALSE)
	for (var/mob/living/L in virtual_occupants_to_mobs)
		if (!check_vr(L))
			remove_virtual_mob(L, TRUE)
	for (var/mob/living/L in virtual_mobs_to_occupants)
		if (!L.client) // Remove clientless virtual mobs, but NOT occupants - they're already clientless since their mind gets transferred
			remove_virtual_mob(L)
	listclearnulls(virtual_clients)

/// Checks whether or not the provided occupant can remain inside of VR. Returns TRUE or FALSE.
/datum/controller/subsystem/virtual_reality/proc/check_vr(mob/living/user)
	if ((user.getBrainLoss() >= 25)) // Boot out mobs with moderate brain damage
		return FALSE
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if (H.shock_stage >= 15) // Boot out humans in high pain
			return FALSE
	if (user.isSynthetic()) // And also boot out synthetics with low charge
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
			if(istype(C) && C.percent() <= 25)
				return FALSE
	var/is_valid = FALSE
	var/obj/machinery/vr_pod/pod = user.loc
	if (istype(pod)) // Check for a usable VR pod
		is_valid = pod.operable()
	else // Finally, check for a VR implant, but only if nothing else is active
		is_valid = !!locate(/obj/item/implant/virtual_reality) in user
	return is_valid

/// Creates a virtual mob for the provided occupant. Humans will take appearance based on client prefs.
/// Returns the instance of the mob that was created.
/datum/controller/subsystem/virtual_reality/proc/create_virtual_mob(mob/living/new_occupant, mob_type, location, silent = FALSE)
	var/mob/living/simulated_mob = new mob_type(location)
	if (ishuman(simulated_mob) && ishuman(new_occupant)) // Copy human appearance for the new mob
		var/mob/living/carbon/human/H = simulated_mob
		new_occupant.client.prefs.copy_to(simulated_mob)
		H.set_nutrition(400)
		H.set_hydration(400)
		H.job = new_occupant.job
		H.apply_job_equipment()

		for (var/obj/item/I in H)
			if (istype(I, /obj/item/underwear))
				I.canremove = FALSE
				I.verbs -= /obj/item/underwear/verb/RemoveSocks

	log_and_message_admins("entered VR as [simulated_mob] (assigned role: [new_occupant.mind.assigned_role]).", new_occupant)

	var/datum/extension/virtual_surrogate/VM = get_or_create_extension(simulated_mob, /datum/extension/virtual_surrogate)
	VM.set_mob(simulated_mob, src)

	virtual_occupants_to_mobs[new_occupant] = simulated_mob
	virtual_mobs_to_occupants[simulated_mob] = new_occupant
	virtual_clients[new_occupant.client] = simulated_mob

	new_occupant.mind.transfer_to(simulated_mob)

	if (!silent)
		var/dat = ""
		dat += SPAN_NOTICE(SPAN_BOLD(FONT_LARGE("-=-=-=-<br>You have entered VR!<br>")))
		if (!locate(simulated_mob.client) in was_warned)
			dat += SPAN_NOTICE("You are now controlling a virtual body in a virtual environment.<br>")
			dat += SPAN_NOTICE("Your normal body can be found where you entered VR, hopefully secure from outside influence.<br>")
			dat += SPAN_NOTICE("You won't be able to see or hear anything around your normal body, but if your pod loses power or is forced open, you'll be returned.")
			dat += SPAN_NOTICE("<br><br>From an in-character perspective, <b>everything done here is simulated, and will have no <i>direct</i> impact on the round.</b><br>")
			dat += SPAN_NOTICE("Of course, you're still beholden to the server's rules, and you're expected to follow them! Don't beat someone to death without asking.<br>")
			dat += SPAN_NOTICE("If you die in this form, you'll be forced back to your body. You can also use the \[Exit-VR\] verb at any time, which you can find in the VR tab.<br>")
		dat += SPAN_NOTICE(SPAN_BOLD(FONT_LARGE("-=-=-=-")))
		to_chat(simulated_mob, dat)
		playsound(simulated_mob.loc, 'sound/machines/boop1.ogg', 50)
		simulated_mob.languages = new_occupant.languages.Copy()
		simulated_mob.default_language = new_occupant.default_language
	simulated_mob.lastarea = null
	return simulated_mob

/// Removes a mob from VR. Accepts both occupants and virtual mobs as a first argument.
/// Returns TRUE if the removal succeeded.
/datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob(mob/living/removed_mob, sudden = FALSE, easter_egg_chance = 1, silent = FALSE)
	var/mob/living/occ_mob
	var/mob/living/vir_mob

	if (virtual_occupants_to_mobs[removed_mob])
		occ_mob = removed_mob
		vir_mob = virtual_occupants_to_mobs[removed_mob]
	else if (virtual_mobs_to_occupants[removed_mob])
		occ_mob = virtual_mobs_to_occupants[removed_mob]
		vir_mob = removed_mob

	if (!vir_mob)
		return FALSE

	var/client/C = virtual_clients[vir_mob.client]

	virtual_occupants_to_mobs[occ_mob] = null
	virtual_occupants_to_mobs -= occ_mob
	virtual_mobs_to_occupants[vir_mob] = null
	virtual_mobs_to_occupants -= vir_mob
	virtual_clients -= C

	if (!silent)
		var/dat = ""
		dat += SPAN_NOTICE(SPAN_BOLD(FONT_LARGE("-=-=-=-<br>You have left VR!<br>")))
		if (!(vir_mob.client in was_warned))
			was_warned += vir_mob.client
			dat += SPAN_NOTICE("You have exited virtual reality and returned to your normal body.<br>")
			dat += SPAN_NOTICE("Everything that happened in VR was simulated, but it did happen. In-character, you remember all the events that transpired inside.<br>")
			dat += SPAN_NOTICE("Now that you've been in and out of VR, you won't see these messages again this round.<br>")
		dat += SPAN_NOTICE(SPAN_BOLD(FONT_LARGE("-=-=-=-")))
		to_chat(vir_mob, dat)

	if (!sudden)
		vir_mob.visible_message(SPAN_NOTICE("\The [vir_mob] visibly pixelates, and then fades away."))
		to_chat(vir_mob, SPAN_NOTICE("Your view blurs and distorts for a moment, and you feel weightless. And then, you're back in reality."))
	else
		vir_mob.visible_message(SPAN_WARNING("\The [vir_mob] suddenly distorts and pops out of existence."))
		to_chat(vir_mob, SPAN_DANGER(FONT_LARGE("You're abruptly dragged back to reality!")))

	if (occ_mob) // Occupier mob might have been destroyed somehow, in which case we just kill the virtual one
		vir_mob.mind.transfer_to(occ_mob)
		if (prob(easter_egg_chance))
			to_chat(occ_mob, SPAN_WARNING("Just like the simulations...!"))
		var/list/vr_buffs = occ_mob.fetch_buffs_of_type(/datum/skill_buff/virtual_reality)
		if (vr_buffs.len)
			for (var/datum/skill_buff/virtual_reality/VRB in vr_buffs)
				VRB.remove()
		occ_mob.lastarea = vir_mob.lastarea
	QDEL_NULL(vir_mob)
	return TRUE

/// Returns the virtual mob representing the provided mob, if it has any.
/datum/controller/subsystem/virtual_reality/proc/get_surrogate_for(mob/living/L)
	var/mob/M = virtual_occupants_to_mobs[L]
	if (!istype(M))
		return
	return M

/// Inverse of get_surrogate_for - returns the occupant mob that's controlling a virtual mob.
/datum/controller/subsystem/virtual_reality/proc/get_occupant_for(mob/living/L)
	var/mob/M = virtual_mobs_to_occupants[L]
	if (!istype(M))
		return
	return M

/// Gets a list of all turfs that are valid VR entry points at call time.
/datum/controller/subsystem/virtual_reality/proc/get_vr_spawns(zone)
	. = list()
	for (var/obj/effect/vr_spawn/L in GLOB.vr_spawns[zone])
		var/turf/T = get_turf(L)
		. += T

/// Returns TRUE if a mob can enter VR, and FALSE if it can't.
/datum/controller/subsystem/virtual_reality/proc/can_enter_vr(mob/living/target)
	var/mob/living/carbon/human/H = target // we typecast immediately, but the typecast var is only used after sanity checks
	if (target.isSynthetic())
		if (ishuman(target))
			var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
			if(istype(C) && C.percent() <= 25) // if a human has low charge, intercept
				return FALSE
	if (ishuman(target))
		if (H.shock_stage > 15) // if a human is in severe pain, intercept
			return FALSE
	return target.getBrainLoss() < 25 // otherwise, check for moderate brain damage

/datum/controller/subsystem/virtual_reality/proc/load_template(datum/nano_module/program/vr_control/vr_program, user, zone, template_area)
	if (!zone)
		to_chat(user, SPAN_WARNING("No VR zone selected. Cannot load template."))
		return TRUE

	var/area/zone_area = GLOB.active_vr_areas[zone]
	if (!zone_area)
		to_chat(user, SPAN_WARNING("The system could not find the specified VR zone: [zone]"))
		return TRUE

	var/list/the_matrix = SSvirtual_reality.virtual_occupants_to_mobs
	var/P = GLOB.vr_areas[template_area]
	var/area/A = locate(P)
	if (!A)
		P = GLOB.emagged_vr_areas[template_area]
		A = locate(P)
		if (!A) // if we still don't have our area after checking for emagged ones, throw an error
			to_chat(user, SPAN_WARNING("The system could not find the specified template: [template_area]"))
			return TRUE
	if (zone_area == A)
		return TRUE
	if (the_matrix.len)
		if (alert(user, "Switching the VR area will eject [the_matrix.len] users from the simulation. Continue?", "Change Area", "Yes", "No") != "Yes")
			return TRUE
		log_and_message_admins("changed the VR area to [A.name], ejecting [the_matrix.len] occupants.", user)
	else
		log_and_message_admins("changed the VR area to [A.name].", user)

	var/loaded_normally = TRUE
	if (!vr_program.emagged || prob(75))
		for (var/atom/SO in simulated_objects[zone]) // Clear the entire previous template before we place another one
			if (length(SO.contents))
				for (var/atom/sub_SO in SO.contents)
					qdel(sub_SO)
			qdel(SO)
		for (var/turf/T in zone_area)
			if (!istype(T, /turf/unsimulated/floor/plating))
				T.ChangeTurf(/turf/unsimulated/floor/plating)
	else // we're emagged, just fuck our shit up a quarter of the time
		loaded_normally = FALSE
		var/atom/comp_holder = vr_program.program.computer.holder
		comp_holder.audible_message(SPAN_DANGER("\The [comp_holder] buzzes oddly!"))
		to_chat(user, SPAN_WARNING("updatevr.dm:[rand(10000, 20000)]:warning: Previous loaded template did not fully unload. Virtual space may be affected."))
		playsound(vr_program.program.computer.holder, 'sound/machines/buzz-sigh.ogg', 50)

	var/list/mobs_in_zone = mobs_in_area(zone_area)
	for (var/mob/living/L in SSvirtual_reality.virtual_occupants_to_mobs)
		if (L in mobs_in_zone)
			to_chat(L, SPAN_DANGER(FONT_LARGE("ALERT: Loaded VR template reconfiguring. Terminating connection.")))
			SSvirtual_reality.remove_virtual_mob(L, TRUE)

	// in this way, we use the selected area as a template. we copy all of its contents to the actual area,
	// allowing users to "reset" the template by refreshing it
	var/area/active_area = zone_area
	simulated_objects[zone] = A.copy_contents_to(active_area)
	active_area.forced_ambience = A.forced_ambience
	active_area.dynamic_lighting = A.dynamic_lighting
	active_area.sound_env = A.sound_env
	GLOB.vr_spawns[zone] = list()
	for (var/obj/effect/vr_spawn/V in active_area)
		GLOB.vr_spawns[zone] += V

	to_chat(user, SPAN_NOTICE("Successfully loaded new area: [A.name]!"))
	if (loaded_normally)
		playsound(vr_program.program.computer.holder, 'sound/machines/ping.ogg', 50)
	vr_program.area_cooldown = world.time + 30 SECONDS
	return TRUE
