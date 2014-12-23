/mob/living/carbon/human/gib()

	for(var/datum/organ/external/E in src.organs)
		if(istype(E, /datum/organ/external/chest))
			continue
		// Only make the limb drop if it's not too damaged
		if(prob(100 - E.get_damage()))
			// Override the current limb status and don't cause an explosion
			E.droplimb(1,1)

	for(var/datum/organ/internal/I in internal_organs)
		var/obj/item/organ/current_organ = I.remove()
		current_organ.loc = src.loc
		current_organ.organ_data.rejecting = null
		var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in current_organ.reagents.reagent_list
		if(!organ_blood || !organ_blood.data["blood_DNA"])
			src.vessel.trans_to(current_organ, 5, 1, 1)

		current_organ.removed(src)

		if(current_organ && istype(loc,/turf))
			var/target_dir = pick(cardinal)
			var/turf/target_turf = loc
			var/steps = rand(1,2)
			for(var/i = 0;i<steps;i++)
				target_turf = get_step(target_turf,target_dir)
			current_organ.throw_at(target_turf)

	..(species.gibbed_anim)
	gibs(loc, viruses, dna, null, species.flesh_color, species.blood_color)

/mob/living/carbon/human/dust()
	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/death(gibbed)

	if(stat == DEAD) return

	hud_updateflag |= 1 << HEALTH_HUD
	hud_updateflag |= 1 << STATUS_HUD
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
	//mutations |= NOCLONE
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
