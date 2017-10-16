/datum/proc/extra_ghost_link(var/prefix, var/sufix, var/short_links)
	return list()

/atom/movable/extra_ghost_link(var/atom/ghost, var/prefix, var/sufix, var/short_links)
	if(src == ghost)
		return list()
	return list(create_ghost_link(ghost, src, short_links ? "F" : "Follow", prefix, sufix))

/client/extra_ghost_link(var/atom/ghost, var/prefix, var/sufix, var/short_links)
	return mob.extra_ghost_link(ghost, prefix, sufix, short_links)

/mob/extra_ghost_link(var/atom/ghost, var/prefix, var/sufix, var/short_links)
	. = ..()
	if(client && eyeobj)
		. += create_ghost_link(ghost, eyeobj, short_links ? "E" : "Eye", prefix, sufix)

/mob/observer/ghost/extra_ghost_link(var/atom/ghost, var/prefix, var/sufix, var/short_links)
	. = ..()
	if(mind && (mind.current && !isghost(mind.current)))
		. += create_ghost_link(ghost, mind.current, short_links ? "B" : "Body", prefix, sufix)

/proc/create_ghost_link(var/ghost, var/target, var/text, var/prefix, var/sufix)
	return "<a href='byond://?src=\ref[ghost];track=\ref[target]'>[prefix][text][sufix]</a>"

/datum/proc/get_ghost_follow_link(var/atom/target, var/delimiter, var/prefix, var/sufix)
	return

/client/get_ghost_follow_link(var/atom/target, var/delimiter, var/prefix, var/sufix)
	return mob.get_ghost_follow_link(target, delimiter, prefix, sufix)

/mob/observer/ghost/get_ghost_follow_link(var/atom/target, var/delimiter, var/prefix, var/sufix)
	var/short_links = get_preference_value(/datum/client_preference/ghost_follow_link_length) == GLOB.PREF_SHORT
	return ghost_follow_link(target, src, delimiter, prefix, sufix, short_links)

/proc/ghost_follow_link(var/atom/target, var/atom/ghost, var/delimiter = "|", var/prefix = "", var/sufix = "", var/short_links = TRUE)
	if((!target) || (!ghost)) return
	return jointext(target.extra_ghost_link(ghost, prefix, sufix, short_links),delimiter)
