/datum/species/nabber
	name = SPECIES_NABBER
	name_plural = "Giant Armoured Serpentids"
	blurb = "A species of large invertebrates who, after being discovered by a \
	research company, were taught how to live and work with humans. Standing \
	upwards of nine feet tall, these people have a tendency to terrify \
	those who have not met them before and are rarely trusted by the \
	average person. Even so, they do their jobs well and are thriving in this \
	new environment."

	language = LANGUAGE_NABBER
	default_language = LANGUAGE_NABBER
	assisted_langs = list(LANGUAGE_GALCOM, LANGUAGE_LUNAR, LANGUAGE_GUTTER, LANGUAGE_UNATHI, LANGUAGE_SIIK_MAAS, LANGUAGE_SKRELLIAN, LANGUAGE_SOL_COMMON, LANGUAGE_EAL, LANGUAGE_INDEPENDENT, LANGUAGE_SPACER)
	additional_langs = list(LANGUAGE_GALCOM)
	name_language = LANGUAGE_NABBER
	min_age = 8
	max_age = 40

	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2

	warning_low_pressure = 50
	hazard_low_pressure = -1

	body_temperature = null

	blood_color = "#525252"
	flesh_color = "#525252"
	blood_oxy = 0

	reagent_tag = IS_NABBER

	icon_template = 'icons/mob/human_races/r_nabber_template.dmi'
	icobase = 'icons/mob/human_races/r_nabber.dmi'
	deform = 'icons/mob/human_races/r_nabber.dmi'

	blood_mask = 'icons/mob/human_races/masks/blood_nabber.dmi'

	has_floating_eyes = 1

	darksight = 8
	slowdown = -0.5
	rarity_value = 4
	hud_type = /datum/hud_data/nabber
	total_health = 200
	brute_mod = 0.85
	burn_mod =  1.35
	gluttonous = GLUT_SMALLER
	mob_size = MOB_LARGE
	strength = STR_HIGH
	breath_pressure = 25
	blood_volume = 840
	spawns_with_stack = 0

	heat_level_1 = 410 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 800 //Default 1000

	flags = NO_SLIP | CAN_NAB | NO_BLOCK | NO_MINOR_CUT | NEED_DIRECT_ABSORB
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN | SPECIES_NO_LACE

	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS

	breathing_organ = BP_TRACH

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake

	var/list/eye_overlays = list()

	has_organ = list(    // which required-organ checks are conducted.
		BP_BRAIN =    /obj/item/organ/internal/brain/nabber,
		BP_EYES =     /obj/item/organ/internal/eyes/nabber,
		BP_TRACH =    /obj/item/organ/internal/lungs/nabber,
		BP_HEART =    /obj/item/organ/internal/heart/nabber,
		BP_LIVER =    /obj/item/organ/internal/liver/nabber,
		BP_PHORON =   /obj/item/organ/internal/phoron,
		BP_VOICE =    /obj/item/organ/internal/voicebox/nabber
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/nabber),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/nabber),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/nabber),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/nabber),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/nabber),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/nabber),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/nabber),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/nabber),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/nabber),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/nabber),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/nabber)
		)

	unarmed_types = list(/datum/unarmed_attack/nabber)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/nab,
		/mob/living/carbon/human/proc/active_camo,
		/mob/living/carbon/human/proc/switch_stance,
		/mob/living/carbon/human/proc/threat_display
		)

	equip_adjust = list(
		slot_back_str = list(NORTH = list("x" = 0, "y" = 7), EAST = list("x" = 0, "y" = 8), SOUTH = list("x" = 0, "y" = 8), WEST = list("x" = 0, "y" = 8))
			)

/datum/species/nabber/get_eyes(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/eyes/nabber/O = H.internal_organs_by_name[BP_EYES]
	if(!O || !istype(O))
		return
	var/store_string = "[O.eyes_shielded] [H.is_cloaked()] [rgb(O.eye_colour[1], O.eye_colour[2], O.eye_colour[3])]"
	var/image/eye_overlay = eye_overlays[store_string]
	if(!eye_overlay)
		var/icon/I = new('icons/mob/nabber_face.dmi', "eyes_nabber")
		I.Blend(rgb(O.eye_colour[1], O.eye_colour[2], O.eye_colour[3]), ICON_ADD)
		if(O.eyes_shielded)
			I.Blend(rgb(125, 125, 125), ICON_MULTIPLY)
		eye_overlay = image(I)
		if(H.is_cloaked())
			eye_overlay.alpha = 100

		eye_overlays[store_string] = eye_overlay
	return(eye_overlay)

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

/datum/species/nabber/handle_environment_special(var/mob/living/carbon/human/H)
	if(!H.on_fire && H.fire_stacks < 2)
		H.fire_stacks += 0.2
	return

// Nabbers will only fall when there isn't enough air pressure for them to keep themselves aloft.
/datum/species/nabber/can_fall(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/mixture = H.loc.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 80)
			return FALSE

	return TRUE

// Even when nabbers do fall, if there's enough air pressure they won't hurt themselves.
/datum/species/nabber/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)

	var/datum/gas_mixture/mixture = H.loc.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		if(pressure > 50)
			if(istype(landing, /turf/simulated/open))
				H.visible_message("\The [src] descends from the deck above through \the [landing]!", "Your wings slow your descent.")
			else
				H.visible_message("\The [src] buzzes down from \the [landing], wings slowing their descent!", "You land on \the [landing], folding your wings.")

			return TRUE

	return FALSE


/datum/species/nabber/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)
	if(!H.handcuffed || H.buckled)
		return ..()
	else
		return 0

/datum/species/nabber/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	H.remove_cloaking_source(src)

	var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
	if(istype(B,/obj/item/organ/internal/brain/nabber))
		var/obj/item/organ/internal/brain/nabber/N = B

		tally += N.lowblood_tally

	return tally

/obj/item/grab/nab/special
	type_name = GRAB_NAB_SPECIAL
	start_grab_name = NAB_AGGRESSIVE

/obj/item/grab/nab/special/init()
	..()

	var/armor = affecting.run_armor_check(BP_CHEST, "melee")
	affecting.apply_damage(15, BRUTE, BP_CHEST, armor, DAM_SHARP, "organic punctures")
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
				if(part.robotic >= ORGAN_ROBOT)
					image_key += "2[part.model ? "-[part.model]": ""]"
				else if(part.status & ORGAN_DEAD)
					image_key += "3"
				else
					image_key += "1"

			var/image/threat_image = skin_overlays[image_key]
			if(!threat_image)
				var/icon/base_icon = icon(H.stand_icon)
				var/icon/I = new('icons/mob/human_races/r_nabber_threat.dmi', "threat")
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
	H.pulling_punches = TRUE
	H.nabbing = FALSE

