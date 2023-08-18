/mob/living/silicon/pai/examine(mob/user, distance, is_adjacent)
	. = ..(user, distance, is_adjacent, infix = ", personal AI")

	var/msg = ""
	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "\nIt appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		msg += "\n[SPAN_WARNING("It doesn't seem to be responding.")]"
		if(DEAD)			msg += "\n[SPAN_CLASS("deadsay", "It looks completely unsalvageable.")]"
	msg += "\n*---------*"

	if(print_flavor_text()) msg += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\nIt is [pose]"

	to_chat(user, msg)
