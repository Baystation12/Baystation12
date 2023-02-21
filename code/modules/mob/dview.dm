//DVIEW is a hack that uses a mob with darksight in order to find lists of viewable stuff while ignoring darkness
// Defines for dview are elsewhere.

var/global/mob/dview/dview_mob = new

/mob/dview
	anchored = TRUE
	density = FALSE
	invisibility = INVISIBILITY_ABSTRACT
	see_in_dark = 1e6
	simulated = FALSE
	virtual_mob = null

/mob/dview/Destroy(force = FALSE)
	SHOULD_CALL_PARENT(FALSE)
	if (!force)
		return QDEL_HINT_LETMELIVE

	crash_with("Forced deletion of dview mob, this should not happen! : [log_info_line(src)]")

	dview_mob = new
	return QDEL_HINT_QUEUE

/mob/dview/Initialize()
	. = ..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	STOP_PROCESSING_MOB(src)
