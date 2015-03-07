/mob/living/carbon/human/gib()

	for(var/datum/organ/internal/I in internal_organs)
		var/obj/item/organ/current_organ = I.remove()
		if(current_organ)
			if(istype(loc,/turf))
				current_organ.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
			current_organ.removed(src)

	for(var/datum/organ/external/E in src.organs)
		if(istype(E, /datum/organ/external/chest))
			continue
		// Only make the limb drop if it's not too damaged
		if(prob(100 - E.get_damage()))
			// Override the current limb status and don't cause an explosion
			E.droplimb(1,1)

	..(species.gibbed_anim)
	gibs(loc, viruses, dna, null, species.flesh_color, species.blood_color)

/mob/living/carbon/human/dust()
	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/death(gibbed)

	if(stat == DEAD) return

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	handle_hud_list()

	//Handle species-specific deaths.
	if(species) species.handle_death(src)

	//Handle brain slugs.
	var/datum/organ/external/head = get_organ("head")
	var/mob/living/simple_animal/borer/B

	for(var/I in head.implants)
		if(istype(I,/mob/living/simple_animal/borer))
			B = I
	if(B)
		if(!B.ckey && ckey && B.controlling)
			B.ckey = ckey
			B.controlling = 0
		if(B.host_brain.ckey)
			ckey = B.host_brain.ckey
			B.host_brain.ckey = null
			B.host_brain.name = "host brain"
			B.host_brain.real_name = "host brain"

		verbs -= /mob/living/carbon/proc/release_control

	callHook("death", list(src, gibbed))

	if(!gibbed && species.death_sound)
		playsound(loc, species.death_sound, 80, 1, 1)


	if(ticker && ticker.mode)
		sql_report_death(src)
		ticker.mode.check_win()
		if(istype(ticker.mode,/datum/game_mode/heist))
			vox_kills++ //Bad vox. Shouldn't be killing humans.

	return ..(gibbed,species.death_message)

/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)	return

	if(f_style)
		f_style = "Shaved"		//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	update_body(0)
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= HUSK
	return

/mob/living/carbon/human/proc/ChangeToSkeleton()
	if(SKELETON in src.mutations)	return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(SKELETON)
	status_flags |= DISFIGURED
	update_body(0)
	return
