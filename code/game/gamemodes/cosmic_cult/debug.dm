var/global/list/cosmic_debug_verbs = list(
	/client/proc/cosmic_increment_progress,
	/client/proc/cosmic_dump_overlays,
	/client/proc/cosmic_spawn_rift,
	/client/proc/cosmic_increment_global_progress,
	/client/proc/cosmic_check_global_progress,
	/client/proc/cosmic_spawn_rift_wave
)

/client/proc/cosmic_increment_progress(mob/target in world, delta as num)
	set category = "Cosmic Debug"
	set name = "Adjust Cultist Progress"

	if(!check_rights(R_ADMIN)) return

	if (!is_cosmic_cultist(target))
		to_chat(usr, SPAN_DEBUG("[target] is not a Cosmic Cultist!"))
		return

	target.mind.cosmic_cultist.adjust_progress(delta)
	to_chat(usr, SPAN_DEBUG("Adjusted Cosmic progress on [target] by [delta]"))

/client/proc/cosmic_dump_overlays(atom/A in world)
	set category = "Cosmic Debug"
	set name = "Dump Overlays"

	if(!check_rights(R_ADMIN)) return

	for (var/image/O as anything in A.overlays)
		to_chat(usr, SPAN_DEBUG("[icon2html(O, usr)] / [O.icon] / [O.icon_state] / layer=[O.layer] plane=[O.plane] color=[O.color] dir=[O.dir]"))

/client/proc/cosmic_spawn_rift()
	set category = "Cosmic Debug"
	set name = "Spawn Rift"

	if(!check_rights(R_ADMIN)) return

	var/obj/result = GLOB.cosmic_cult.spawn_rift()
	to_chat(usr, SPAN_DEBUG(append_admin_tools("Spawned rift [result] at [get_turf(result)] [get_area(result)]", result, get_turf(result))))

/client/proc/cosmic_spawn_rift_wave()
	set category = "Cosmic Debug"
	set name = "Spawn Rift Wave"

	if(!check_rights(R_ADMIN)) return

	var/count = GLOB.cosmic_cult.spawn_rift_wave()
	to_chat(usr, SPAN_DEBUG("Spawned [count] rift(s)"))

/client/proc/cosmic_increment_global_progress(delta as num)
	set category = "Cosmic Debug"
	set name = "Adjust Global Progress"

	if(!check_rights(R_ADMIN)) return

	GLOB.cosmic_cult.adjust_progress(delta)
	to_chat(usr, SPAN_DEBUG("Adjusted Cosmic progress on [GLOB.cosmic_cult] by [delta]"))

/client/proc/cosmic_check_global_progress()
	set category = "Cosmic Debug"
	set name = "Check Global Progress"

	if(!check_rights(R_ADMIN)) return

	var/datum/antagonist/cosmic_cultist/cult = GLOB.cosmic_cult
	to_chat(usr, SPAN_DEBUG("The Cosmic Cult is at [cult.progress] progress on tier [cult.tier], and needs [cult.get_target_progress(cult.tier + 1)] to get to tier [cult.tier + 1]"))
