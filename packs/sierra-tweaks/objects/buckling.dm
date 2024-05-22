/obj/buckle_mob(mob/living/M)
	if (M.buckled)
		return FALSE
	// Additional check not covered can_buckle(), due to attempting to buckle allowing you to move an adjacent target to the object.
	if (M.loc != loc)
		return  FALSE
	if(ismob(src))
		var/mob/living/carbon/C = src //Don't wanna forget the xenos.
		if(M != src && C.incapacitated())
			return 0

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.UpdateLyingBuckledAndVerbStatus()
	M.update_floating()
	M.pixel_x = initial(M.pixel_x)
	M.pixel_y = initial(M.pixel_y)
	buckled_mob = M
	GLOB.destroyed_event.register(buckled_mob, src, TYPE_PROC_REF(/obj, clear_buckle))
	if (buckle_sound)
		playsound(src, buckle_sound, 20)
	post_buckle_mob(M)
	// SIERRA TODO: alerts
	// M.throw_alert("buckled", /obj/screen/alert/restrained/buckled)
	return TRUE
