/datum/species/nabber
	name = SPECIES_NABBER
	name_plural = "giant armoured serpentids"
	description = "A species of large invertebrates who, after being discovered by a \
	research company, were taught how to live and work with humans. Standing \
	upwards of nine feet tall, these people have a tendency to terrify \
	those who have not met them before and are rarely trusted by the \
	average person. Even so, they do their jobs well and are thriving in this \
	new environment."
	hidden_from_codex = FALSE
	silent_steps = TRUE

	antaghud_offset_y = 8

	assisted_langs = list(LANGUAGE_GUTTER, LANGUAGE_UNATHI_SINTA, LANGUAGE_SKRELLIAN, LANGUAGE_HUMAN_EURO, LANGUAGE_EAL, LANGUAGE_HUMAN_RUSSIAN)
	min_age = 8
	max_age = 40

	skin_material = MATERIAL_SKIN_CHITIN
	bone_material = null
	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2

	warning_low_pressure = 50
	hazard_low_pressure = -1

	body_temperature = null

	blood_color = "#525252"
	flesh_color = "#525252"
	blood_oxy = 0

	reagent_tag = IS_NABBER

	icon_template = 'icons/mob/human_races/species/template_tall.dmi'
	icobase = 'icons/mob/human_races/species/nabber/body.dmi'
	deform = 'icons/mob/human_races/species/nabber/body.dmi'
	preview_icon = 'icons/mob/human_races/species/nabber/preview.dmi'
	blood_mask = 'icons/mob/human_races/species/nabber/blood_mask.dmi'

	limb_blend = ICON_MULTIPLY

	darksight_range = 8
	darksight_tint = DARKTINT_GOOD
	slowdown = -0.5
	rarity_value = 4
	hud_type = /datum/hud_data/nabber

	total_health = 200
	brute_mod = 0.9
	burn_mod =  1.35
	natural_armour_values = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = 0.5*ARMOR_RAD_MINOR
		)

	gluttonous = GLUT_SMALLER
	mob_size = MOB_LARGE
	strength = STR_HIGH
	breath_pressure = 25
	blood_volume = 840
	spawns_with_stack = 0

	heat_level_1 = 410 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 800 //Default 1000

	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_BLOCK | SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NEED_DIRECT_ABSORB
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL | HAS_BASE_SKIN_COLOURS
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN

	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS

	breathing_organ = BP_TRACH

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake

	has_organ = list(    // which required-organ checks are conducted.
		BP_BRAIN =    /obj/item/organ/internal/brain/insectoid/nabber,
		BP_EYES =     /obj/item/organ/internal/eyes/insectoid/nabber,
		BP_TRACH =    /obj/item/organ/internal/lungs/insectoid/nabber,
		BP_LIVER =    /obj/item/organ/internal/liver/insectoid/nabber,
		BP_HEART =    /obj/item/organ/internal/heart/open,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_PHORON =   /obj/item/organ/internal/phoron,
		BP_ACETONE =  /obj/item/organ/internal/acetone,
		BP_VOICE =    /obj/item/organ/internal/voicebox/nabber
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid/nabber),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/nabber),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid/nabber),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
		)

	base_skin_colours = list(
		"Grey"   = "",
		"Green"  = "_green"
	)

	unarmed_types = list(/datum/unarmed_attack/nabber)

	descriptors = list(
		/datum/mob_descriptor/height = 3,
		/datum/mob_descriptor/body_length = 0
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_NABBER_CMINUS,
			CULTURE_NABBER_C,
			CULTURE_NABBER_CPLUS,
			CULTURE_NABBER_BMINUS,
			CULTURE_NABBER_B,
			CULTURE_NABBER_BPLUS,
			CULTURE_NABBER_AMINUS,
			CULTURE_NABBER_A,
			CULTURE_NABBER_APLUS
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_SERPENTIDS
		),
		TAG_FACTION = list(
			FACTION_XYNERGY
		),
		TAG_RELIGION =  list(
			RELIGION_OTHER
		)
	)
	pain_emotes_with_pain_level = list(
			list(/decl/emote/audible/bug_hiss) = 40
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_reagent_scale = 5
	exertion_reagent_path = /datum/reagent/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)

/datum/species/nabber/New()
	equip_adjust = list(
		slot_head_str =    list("[NORTH]" = list("x" = 0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = 0, "y" = 8),  "[WEST]" = list("x" = 0, "y" = 8)),
		slot_back_str =    list("[NORTH]" = list("x" = 0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = 0, "y" = 8),  "[WEST]" = list("x" = 0, "y" = 8)),
		slot_belt_str =    list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = 8, "y" = 0),  "[SOUTH]" = list("x" = 0, "y" = 0),  "[WEST]" = list("x" = -8, "y" = 0)),
		slot_glasses_str = list("[NORTH]" = list("x" = 0, "y" = 10), "[EAST]" = list("x" = 0, "y" = 11), "[SOUTH]" = list("x" = 0, "y" = 11), "[WEST]" = list("x" = 0, "y" = 11))
	)
	..()

/datum/species/nabber/get_blood_name()
	return "haemolymph"

/datum/species/nabber/can_overcome_gravity(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			var/turf/below = GetBelow(H)
			var/turf/T = H.loc
			if(!T.CanZPass(H, DOWN) || !below.CanZPass(H, DOWN))
				return TRUE

	return FALSE

/datum/species/nabber/handle_environment_special(mob/living/carbon/human/H)
	if(!H.on_fire && H.fire_stacks < 2)
		H.fire_stacks += 0.2
	return

// Nabbers will only fall when there isn't enough air pressure for them to keep themselves aloft.
/datum/species/nabber/can_fall(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()

	//nabbers should not be trying to break their fall on stairs.
	var/turf/T = GetBelow(H.loc)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/stairs))
			return TRUE
	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 80)
			return FALSE

	return TRUE

// Even when nabbers do fall, if there's enough air pressure they won't hurt themselves.
/datum/species/nabber/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)

	var/datum/gas_mixture/mixture = H.loc.return_air()

	var/turf/T = GetBelow(H.loc)

	//Nabbers should not be trying to break their fall on stairs.
	for(var/obj/O in T)
		if(istype(O, /obj/structure/stairs))
			return FALSE

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			if(istype(landing, /turf/simulated/open))
				H.visible_message("\The [H] descends from the deck above through \the [landing]!", "Your wings slow your descent.")
			else
				H.visible_message("\The [H] buzzes down from \the [landing], wings slowing their descent!", "You land on \the [landing], folding your wings.")

			return TRUE

	return FALSE


/datum/species/nabber/can_shred(var/mob/living/carbon/human/H, var/ignore_intent, var/ignore_antag)
	if(!H.handcuffed || H.buckled)
		return ..(H, ignore_intent, TRUE)
	else
		return 0

/datum/species/nabber/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	H.remove_cloaking_source(src)

	var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
	if(istype(B,/obj/item/organ/internal/brain/insectoid/nabber))
		var/obj/item/organ/internal/brain/insectoid/nabber/N = B

		tally += N.lowblood_tally * 2
	return tally

/obj/item/grab/nab/special
	type_name = GRAB_NAB_SPECIAL
	start_grab_name = NAB_AGGRESSIVE

/obj/item/grab/nab/special/init()
	if(!(. = ..()))
		return
	affecting.apply_damage(15, BRUTE, BP_CHEST, DAM_SHARP, "organic punctures")
	affecting.visible_message("<span class='danger'>[assailant]'s spikes dig in painfully!</span>")
	affecting.Stun(10)

/datum/species/nabber/update_skin(var/mob/living/carbon/human/H)

	if(H.stat)
		H.skin_state = SKIN_NORMAL

	switch(H.skin_state)
		if(SKIN_NORMAL)
			return
		if(SKIN_THREAT)

			var/image_key = "[H.species.get_race_key(src)]"

			for(var/organ_tag in H.species.has_limbs)
				var/obj/item/organ/external/part = H.organs_by_name[organ_tag]
				if(isnull(part) || part.is_stump())
					image_key += "0"
					continue
				if(part)
					image_key += "[part.species.get_race_key(part.owner)]"
					image_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
				if(BP_IS_ROBOTIC(part))
					image_key += "2[part.model ? "-[part.model]": ""]"
				else if(part.status & ORGAN_DEAD)
					image_key += "3"
				else
					image_key += "1"

			var/image/threat_image = skin_overlays[image_key]
			if(!threat_image)
				var/icon/base_icon = icon(H.stand_icon)
				var/icon/I = new('icons/mob/human_races/species/nabber/threat.dmi', "threat")
				base_icon.Blend(COLOR_BLACK, ICON_MULTIPLY)
				base_icon.Blend(I, ICON_ADD)
				threat_image  = image(base_icon)
				skin_overlays[image_key] = threat_image

			return(threat_image)
	return

/datum/species/nabber/disarm_attackhand(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/target)
	if(attacker.pulling_punches || target.lying || attacker == target)
		return ..(attacker, target)
	if(world.time < attacker.last_attack + 20)
		to_chat(attacker, "<span class='notice'>You can't attack again so soon.</span>")
		return 0
	attacker.last_attack = world.time
	var/turf/T = get_step(get_turf(target), get_dir(get_turf(attacker), get_turf(target)))
	playsound(target.loc, 'sound/weapons/pushhiss.ogg', 50, 1, -1)
	if(!T.density)
		step(target, get_dir(get_turf(attacker), get_turf(target)))
		target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
	else
		target.turf_collision(T, target.throw_speed / 2)
	if(prob(50))
		target.set_dir(GLOB.reverse_dir[target.dir])

/datum/species/nabber/get_additional_examine_text(var/mob/living/carbon/human/H)
	var/datum/gender/T = gender_datums[H.get_gender()]
	if(H.pulling_punches)
		return "\n[T.His] manipulation arms are out and [T.he] looks ready to use complex items."
	else
		return "\n<span class='warning'>[T.His] deadly upper arms are raised and [T.he] looks ready to attack!</span>"

/datum/species/nabber/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	return H.pulling_punches = TRUE

/datum/species/nabber/has_fine_manipulation(var/mob/living/carbon/human/H)
	return (..() && (H && H.pulling_punches))

/datum/species/nabber/attempt_grab(var/mob/living/carbon/human/grabber, var/mob/living/target)
	if(grabber.pulling_punches)
		return ..()
	if(grabber == target)
		return ..()

	grabber.unEquip(grabber.l_hand)
	grabber.unEquip(grabber.r_hand)
	to_chat(grabber, "<span class='warning'>You drop everything as you spring out to nab \the [target]!.</span>")
	playsound(grabber.loc, 'sound/weapons/pierce.ogg', 25, 1, -1)

	if(!grabber.is_cloaked())
		return ..(grabber, target, GRAB_NAB)

	if(grabber.last_special > world.time)
		to_chat(grabber, "<span class='warning'>It is too soon to make another nab attempt.</span>")
		return

	grabber.last_special = world.time + 50

	grabber.remove_cloaking_source(src)
	if(prob(90) && grabber.make_grab(grabber, target, GRAB_NAB_SPECIAL))
		target.Weaken(rand(1,3))
		target.LAssailant = grabber
		grabber.visible_message("<span class='danger'>\The [grabber] suddenly lunges out and grabs \the [target]!</span>")
		grabber.do_attack_animation(target)
		playsound(grabber.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return 1
	else
		grabber.visible_message("<span class='danger'>\The [grabber] suddenly lunges out, almost grabbing \the [target]!</span>")

/datum/species/nabber/toggle_stance(var/mob/living/carbon/human/H)
	if(H.incapacitated())
		return FALSE
	var/datum/gender/T = gender_datums[H.get_gender()]
	to_chat(H, "<span class='notice'>You begin to adjust the fluids in your arms, dropping everything and getting ready to swap which set you're using.</span>")
	var/hidden = H.is_cloaked()
	if(!hidden) H.visible_message("<span class='warning'>\The [H] shifts [T.his] arms.</span>")
	H.unEquip(H.l_hand)
	H.unEquip(H.r_hand)
	if(do_after(H, 30))
		arm_swap(H)
	else
		to_chat(H, "<span class='notice'>You stop adjusting your arms and don't switch between them.</span>")
	return TRUE

/datum/species/nabber/proc/arm_swap(var/mob/living/carbon/human/H, var/forced)
	H.unEquip(H.l_hand)
	H.unEquip(H.r_hand)
	var/hidden = H.is_cloaked()
	var/datum/gender/T = gender_datums[H.get_gender()]
	H.pulling_punches = !H.pulling_punches
	if(H.pulling_punches)
		H.current_grab_type = all_grabobjects[GRAB_NORMAL]
		if(forced)
			to_chat(H, "<span class='notice'>You can't keep your hunting arms prepared and they drop, forcing you to use your manipulation arms.</span>")
			if(!hidden)
				H.visible_message("<span class='notice'>[H] falters, [T.his] hunting arms failing.</span>")
		else
			to_chat(H, "<span class='notice'>You relax your hunting arms, lowering the pressure and folding them tight to your thorax. \
			You reach out with your manipulation arms, ready to use complex items.</span>")
			if(!hidden)
				H.visible_message("<span class='notice'>[H] seems to relax as [T.he] folds [T.his] massive curved arms to [T.his] thorax and reaches out \
				with [T.his] small handlike limbs.</span>")
	else
		H.current_grab_type = all_grabobjects[GRAB_NAB]
		to_chat(H, "<span class='notice'>You pull in your manipulation arms, dropping any items and unfolding your massive hunting arms in preparation of grabbing prey.</span>")
		if(!hidden)
			H.visible_message("<span class='warning'>[H] tenses as [T.he] brings [T.his] smaller arms in close to [T.his] body. [T.His] two massive spiked arms reach \
			out. [T.He] looks ready to attack.</span>")

/datum/species/nabber/check_background(var/datum/job/job, var/datum/preferences/prefs)
	var/decl/cultural_info/culture/nabber/grade = SSculture.get_culture(prefs.cultural_info[TAG_CULTURE])
	. = istype(grade) ? (job.type in grade.valid_jobs) : ..()

/datum/species/nabber/skills_from_age(age)	//Converts an age into a skill point allocation modifier. Can be used to give skill point bonuses/penalities not depending on job.
	switch(age)
		if(0 to 18) 	. = 8
		if(19 to 27) 	. = 2
		if(28 to 40)	. = -2
		else			. = -4
