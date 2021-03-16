GLOBAL_VAR_INIT(active_vr_area, null)
GLOBAL_LIST_INIT(vr_areas, list(
	"Plaza" = /area/virtual_reality/plaza,
	"Courtroom" = /area/virtual_reality/courtroom,
	"Meeting Hall" = /area/virtual_reality/meeting_hall,
	"Theatre" = /area/virtual_reality/theatre,
	"Cafe" = /area/virtual_reality/cafe,
	"Temple" = /area/virtual_reality/temple,
	"Infirmary" = /area/virtual_reality/infirmary,
	"Boxing Ring" = /area/virtual_reality/boxing_ring,
	"Empty Court" = /area/virtual_reality/empty_court,
	"Volleyball Court" = /area/virtual_reality/volleyball_court,
	"Basketball Court" = /area/virtual_reality/basketball_court,
	"Thunderdome" = /area/virtual_reality/thunderdome,
	"Beach" = /area/virtual_reality/beach,
	"Snowy Field" = /area/virtual_reality/snowfield,
	"Picnic Area" = /area/virtual_reality/picnic_area,
	"Desert" = /area/virtual_reality/desert,
	"Space" = /area/virtual_reality/space
))
GLOBAL_LIST_INIT(emagged_vr_areas, list(
	"Shady Room" = /area/virtual_reality/shady_room
))


// Keeps tabs on every client currently in VR, as well as every occupant and very virtual mob.
// If an occupant is no longer valid in VR (i.e. pod depowered), it will yank them out and put them into their original mob.
SUBSYSTEM_DEF(virtual_reality)
	name = "VR"
	priority = SS_PRIORITY_VR
	init_order = SS_INIT_DEFAULT
	wait = 0.5 SECONDS
	
	var/list/virtual_mobs_to_occupants = list()		// Associative list of /mob/living => /mob/living. Each virtual mob is tied to its occupant.
	var/list/virtual_occupants_to_mobs = list()		// Reverse of previous list, in case one is missing but not the other.
	var/list/virtual_clients = list()				// Associative list of /client => /mob/living. Each client is linked to its virtual mob.
	var/list/was_warned = list()					// A list of clients that have already received the disclaimer message when entering VR.

/datum/controller/subsystem/virtual_reality/fire(resumed = FALSE)
	for (var/mob/living/L in virtual_occupants_to_mobs)
		if (!check_vr(L))
			remove_virtual_mob(L, TRUE)
	for (var/mob/living/L in virtual_mobs_to_occupants)
		if (!L.client) // Remove clientless virtual mobs, but NOT occupants - they're already clientless since their mind gets transferred
			remove_virtual_mob(L)
	listclearnulls(virtual_clients)

// Checks whether or not the provided occupant can remain inside of VR. Returns TRUE or FALSE.
/datum/controller/subsystem/virtual_reality/proc/check_vr(mob/living/user)
	if (user.getBrainLoss() >= 25) // Boot out mobs with moderate brain damage
		return FALSE
	if (user.isSynthetic()) // And also boot out synthetics with low charge
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
			if(istype(C) && C.percent() <= 25)
				return
	var/is_valid = FALSE
	var/obj/machinery/vr_pod/pod = user.loc
	if (istype(pod)) // Check for powered and operable VR pod
		is_valid = pod.is_powered() && pod.operable()
	else // Finally, check for a VR implant, but only if nothing else is active
		is_valid = !!locate(/obj/item/implant/virtual_reality) in user
	return is_valid

// Creates a virtual mob for the provided occupant. Humans will take appearance based on client prefs.
// Returns the instance of the mob that was created.
/datum/controller/subsystem/virtual_reality/proc/create_virtual_mob(mob/living/new_occupant, mob_type, location, silent = FALSE)
	var/mob/living/simulated_mob = new mob_type(location)
	if (ishuman(simulated_mob) && ishuman(new_occupant)) // Copy human appearance for the new mob
		var/mob/living/carbon/human/H = simulated_mob
		new_occupant.client.prefs.copy_to(simulated_mob)
		H.set_nutrition(400)
		H.set_hydration(400)
		
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
	simulated_mob.client.played = 0
	return simulated_mob

// Removes a mob from VR. Accepts both occupants and virtual mobs as a first argument.
// Returns TRUE if the removal succeeded.
/datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob(mob/living/removed_mob, sudden = FALSE, easter_egg_chance = 1)
	var/mob/living/occ_mob = null
	var/mob/living/vir_mob = null

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
	
	var/dat = ""
	dat += SPAN_NOTICE(SPAN_BOLD(FONT_LARGE("-=-=-=-<br>You have left VR!<br>")))
	if (!locate(vir_mob.client) in was_warned)
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

	for(var/obj/item/W in vir_mob)
		if (W.canremove)
			vir_mob.drop_from_inventory(W)

	if (occ_mob) // Occupier mob might have been destroyed somehow, in which case we just kill the virtual one
		vir_mob.mind.transfer_to(occ_mob)
		if (prob(easter_egg_chance))
			to_chat(occ_mob, SPAN_WARNING("Just like the simulations...!"))
		var/list/vr_buffs = occ_mob.fetch_buffs_of_type(/datum/skill_buff/virtual_reality)
		if (vr_buffs.len)
			for (var/datum/skill_buff/virtual_reality/VRB in vr_buffs)
				VRB.remove()
	QDEL_NULL(vir_mob)
	return TRUE

/datum/controller/subsystem/virtual_reality/proc/get_surrogate_for(mob/living/L)
	var/mob/M = virtual_occupants_to_mobs[L]
	if (!istype(M))
		return
	return M

/datum/controller/subsystem/virtual_reality/proc/get_occupant_for(mob/living/L)
	var/mob/M = virtual_mobs_to_occupants[L]
	if (!istype(M))
		return
	return M

/datum/controller/subsystem/virtual_reality/proc/get_vr_spawns()
	. = list()
	for (var/turf/T in GLOB.vr_spawnlocs)
		if (get_area(T) == GLOB.active_vr_area) // this sucks on ice
			. += T

/datum/controller/subsystem/virtual_reality/proc/can_enter_vr(mob/living/target)
	if (target.isSynthetic())
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
			if(istype(C) && C.percent() <= 25)
				return
	return target.getBrainLoss() < 25
