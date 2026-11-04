var/global/list/cosmic_debug_verbs = list(
	/client/proc/cosmic_increment_progress,
	/client/verb/cosmic_dump_overlays
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

/client/verb/cosmic_dump_overlays(atom/A in world)
	set category = "Cosmic Debug"
	set name = "Dump Overlays"

	if(!check_rights(R_ADMIN)) return

	for (var/image/O as anything in A.overlays)
		to_chat(usr, SPAN_DEBUG("[icon2html(O, usr)] / [O.icon] / [O.icon_state] / layer=[O.layer] plane=[O.plane] color=[O.color] dir=[O.dir]"))
