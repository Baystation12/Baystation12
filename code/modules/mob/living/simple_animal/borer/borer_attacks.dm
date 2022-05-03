/mob/living/simple_animal/borer/UnarmedAttack(atom/A, proximity)

	if(!isliving(A) || a_intent != I_GRAB)
		return ..()

	if(host || !can_use_borer_ability(requires_host_value = FALSE, check_last_special = FALSE))
		return

	var/mob/living/M = A
	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot take a host who already has a passenger!"))
		return

	//TODO generalize borers to enter any mob. Until then, return early.
	if(!ishuman(M))
		to_chat(src, SPAN_WARNING("This creature is not sufficiently intelligent to host you."))
		return
	// end TODO

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
	if(!E || E.is_stump())
		to_chat(src, SPAN_WARNING("\The [H] does not have a head!"))
		return
	if(!H.should_have_organ(BP_BRAIN))
		to_chat(src, SPAN_WARNING("\The [H] does not seem to have a brain cavity to enter."))
		return
	if(H.check_head_coverage())
		to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
		return

	to_chat(M, SPAN_WARNING("Something slimy begins probing at the opening of your ear canal..."))
	to_chat(src, SPAN_NOTICE("You slither up [M] and begin probing at their ear canal..."))
	set_ability_cooldown(5 SECONDS)

	if(!do_after(src, 3 SECONDS, M, DO_DEFAULT | DO_USER_UNIQUE_ACT))
		return

	to_chat(src, SPAN_NOTICE("You wiggle into \the [M]'s ear."))
	if(M.stat == CONSCIOUS)
		to_chat(M, SPAN_DANGER("Something wet, cold and slimy wiggles into your ear!"))

	host = M
	host.status_flags |= PASSEMOTES
	forceMove(host)

	for(var/obj/thing in hud_elements)
		thing.alpha =        255
		thing.invisibility = 0

	//Update their traitor status.
	if(host.mind && !neutered)
		GLOB.borers.add_antagonist_mind(host.mind, 1, GLOB.borers.faction_role_text, GLOB.borers.faction_welcome)

	if(istype(host, /mob/living/carbon/human))
		var/obj/item/organ/I = H.internal_organs_by_name[BP_BRAIN]
		if(!I) // No brain organ, so the borer moves in and replaces it permanently.
			replace_brain()
		else if(E) // If they're in normally, implant removal can get them out.
			E.implants += src

/mob/living/simple_animal/borer/RangedAttack(atom/A, var/params)
	. = ..()
	if(!. && a_intent == I_DISARM && !host && isliving(A) && !neutered && can_use_borer_ability(requires_host_value = FALSE))
		var/mob/living/M = A
		if(M.has_brain_worms())
			to_chat(src, SPAN_WARNING("You cannot dominate a host who already has a passenger!"))
		else
			visible_message(SPAN_DANGER("\The [src] extends a writhing pseudopod towards \the [M]..."))

			if(M.deflect_psionic_attack())
				return TRUE

			sound_to(src, sound('sound/effects/psi/power_evoke.ogg'))
			sound_to(M, sound('sound/effects/psi/power_evoke.ogg'))

			if(do_psionics_check(5, src))
				to_chat(src, SPAN_DANGER("You try to focus on [M], but you cannot expel any psionic power!"))
				return TRUE

			if(M.do_psionics_check(5, src))
				to_chat(src, SPAN_DANGER("You focus on [M], but your psionic assault skates across them like glass."))
				return TRUE

			to_chat(src, SPAN_DANGER("You focus on [M] and freeze their limbs with a wave of terrible psionic dread."))
			to_chat(M, SPAN_DANGER("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
			M.Weaken(10)
			set_ability_cooldown(15 SECONDS)

		return TRUE
