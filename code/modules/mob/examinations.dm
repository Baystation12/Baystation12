
/proc/examinate(mob/user, atom/A)
	if ((is_blind(user) || user.stat) && !isobserver(user))
		to_chat(user, SPAN_NOTICE("Something is there but you can't see it."))
		return
	user.face_atom(A)
	if (user.simulated)
		if (A.loc != user || user.IsHolding(A))
			for (var/mob/M in viewers(4, user))
				if (M == user)
					continue
				if (M.client && M.client.get_preference_value(/datum/client_preference/examine_messages) == GLOB.PREF_SHOW)
					if (M.is_blind() || user.is_invisible_to(M))
						continue
					to_chat(M, SPAN_SUBTLE("<b>\The [user]</b> looks at \the [A]."))
	var/distance = INFINITY
	var/is_adjacent = FALSE
	if (isghost(user) || user.stat == DEAD)
		distance = 0
		is_adjacent = TRUE
	else
		var/turf/source_turf = get_turf(user)
		var/turf/target_turf = get_turf(A)
		if (source_turf && source_turf.z == target_turf?.z)
			distance = get_dist(source_turf, target_turf)
		is_adjacent = user.Adjacent(A)
	if (!A.examine(user, distance, is_adjacent))
		crash_with("Improper /examine() override: [log_info_line(A)]")
	if (!A.LateExamine(user, distance, is_adjacent))
		crash_with("Improper /LateExamine() override: [log_info_line(A)]")

/mob/proc/ForensicsExamination(atom/A, distance, is_adjacent)
	if (!(get_skill_value(SKILL_FORENSICS) >= SKILL_EXPERIENCED && distance <= (get_skill_value(SKILL_FORENSICS) - SKILL_TRAINED)))
		return

	var/clue = FALSE
	if (LAZYLEN(A.suit_fibers))
		to_chat(src, SPAN_NOTICE("You notice some fibers embedded in \the [A]."))
		clue = TRUE
	if (LAZYLEN(A.fingerprints))
		to_chat(src, SPAN_NOTICE("You notice a partial print on \the [A]."))
		clue = TRUE
	if (LAZYLEN(A.gunshot_residue))
		GunshotResidueExamination(A)
		clue = TRUE
	// Noticing wiped blood is a bit harder
	if ((get_skill_value(SKILL_FORENSICS) >= SKILL_MASTER) && LAZYLEN(A.blood_DNA))
		to_chat(src, SPAN_WARNING("You notice faint blood traces on \the [A]."))
		clue = TRUE
	if (clue && has_client_color(/datum/client_color/noir))
		playsound_local(null, pick('sound/effects/clue1.ogg','sound/effects/clue2.ogg'), 60, is_global = TRUE)


/mob/proc/GunshotResidueExamination(atom/A)
	to_chat(src, SPAN_NOTICE("You notice a faint acrid smell coming from \the [A]."))

/mob/living/GunshotResidueExamination(atom/A)
	if (isSynthetic())
		to_chat(src, SPAN_NOTICE("You notice faint black residue on \the [A]."))
	else
		to_chat(src, SPAN_NOTICE("You notice a faint acrid smell coming from \the [A]."))

/mob/living/silicon/GunshotResidueExamination(atom/A)
	to_chat(src, SPAN_NOTICE("You notice faint black residue on \the [A]."))
