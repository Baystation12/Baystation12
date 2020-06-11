
#define KNIGHT_TELEPORT_ANIM_TIME 2
#define KNIGHT_DEATH_TP_DELAY 3 SECONDS

/datum/species/knight
	name = "Knight"
	name_plural = "Knights"
	blurb = "???"

	//flesh_color = "#4A4A64"
	//blood_color = "#AB36AF"
	icobase = 'code/modules/halo/Forerunner/species/knight/knight.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/Forerunner/species/knight/knight.dmi'
	icon_template = 'code/modules/halo/Forerunner/species/knight/knight_template.dmi'

	damage_overlays = 'code/modules/halo/Forerunner/species/knight/knight_dam.dmi'
	damage_mask = 'code/modules/halo/Forerunner/species/knight/knight_dam.dmi'
	blood_mask = 'code/modules/halo/Forerunner/species/knight/knight_blood.dmi'

	flags = NO_MINOR_CUT | NO_EMBED | NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON

	pixel_offset_x = -26
	item_icon_offsets = list(list(26,3),list(26,0),null,list(17,2),null,null,null,list(31,2),null)
	inhand_icon_offsets = list(list(5,0),list(-7,0),null,list(2,0),null,null,null,list(2,0),null)
	inter_hand_dist = 14
	roll_distance = 3

	total_health = 300
	radiation_mod = 0
	virus_immune = 1
	breath_type = null
	poison_gases = list()

	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_SKIN_TONE
	brute_mod = 1
	burn_mod = 1
	pain_mod = 0
	slowdown = -0.5
	explosion_effect_mod = 0
	can_force_door = 1

	warning_low_pressure = -1
	hazard_low_pressure = -1
	cold_level_1 = 260
	cold_level_2 = 200
	cold_level_3 = 120

	death_message = "dims, power flowing out of them..."
	knockout_message = "has been knocked unconscious!"
	halloss_message = "freezes up, and falls to the ground..."
	halloss_message_self = "Sensory inputs overloaded..."

	inherent_verbs = list(/mob/living/proc/tele_evac)

	pain_scream_sounds = list(\
	'code/modules/halo/sounds/species_pain_screams/knightscream.ogg',
	'code/modules/halo/sounds/species_pain_screams/knightscream2.ogg',
	'code/modules/halo/sounds/species_pain_screams/knightscream3.ogg'
	)

	has_organ = list(
		"elegiast" =    /obj/item/organ/internal/knight_core,
		BP_BRAIN =    /obj/item/organ/internal/brain/knight
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/knight),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/knight),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/knight),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/knight),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/knight),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/knight),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/knight),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/knight),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/knight),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/knight),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/knight)
		)

/datum/species/knight/handle_death_check(var/mob/living/carbon/human/h)
	. = ..()
	if(.)
		return
	var/obj/item/organ/core = h.internal_organs_by_name["elegiast"]
	if(!core || core.damage == core.max_damage || (core.status & ORGAN_DEAD))
		return TRUE
	return FALSE

/datum/species/knight/handle_death(var/mob/living/carbon/human/H)
	H.visible_message("<span class = 'danger'>[H] begins to disintegrate as it starts an emergency translocation jump...</span>")
	H.Stun(KNIGHT_DEATH_TP_DELAY)
	sleep(KNIGHT_DEATH_TP_DELAY)
	H.do_tele_evac(null)

/datum/species/knight/handle_dodge_roll(var/mob/roller,var/rolldir,var/roll_dist,var/roll_delay)
	. = 1 //We don't want to be able to do normal rolls
	var/turf/endpoint = null
	var/turf/step_to = roller.loc
	for(var/i = 0,i < roll_dist,i++)
		step_to = get_step(step_to,rolldir)
		if(step_to.density == 0)
			endpoint = step_to
	if(endpoint && endpoint.density == 0)
		new /obj/effect/knightroll_tp(roller.loc)
		new /obj/effect/knightroll_tp (endpoint)
		roller.forceMove(endpoint)

/datum/species/knight/get_random_name(var/gender)
	return pick(GLOB.yanmee_nicknames)

/datum/species/knight/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.name = "Knight [rand(0,999)] \"[H.name]\""
	H.real_name = H.name

/datum/species/knight/apply_species_name_formatting(var/to_format_name)
	return "Knight [rand(1,999)] \"[to_format_name]\""

/obj/effect/knightroll_tp
	name = "slipspace teleport"
	desc = "a teleportion portal"
	icon = 'code/modules/halo/Forerunner/species/knight/knight_armour.dmi'
	icon_state = "teleport"
	var/die_at

/obj/effect/knightroll_tp/Initialize()
	. = ..()
	die_at = world.time + KNIGHT_TELEPORT_ANIM_TIME
	GLOB.processing_objects += src

/obj/effect/knightroll_tp/process()
	if(world.time >= die_at)
		qdel(src)
		return

/obj/item/organ/internal/brain/knight
	name = "knight durance"
	desc = "Co-ordinates combat processing."
	icon = 'code/modules/halo/Forerunner/species/knight/knight.dmi'
	icon_state = "knight_durance"
	robotic = ORGAN_ROBOT

/obj/item/organ/internal/knight_core
	name = "knight elegiast"
	desc = "Supplies the system with power."
	icon = 'code/modules/halo/Forerunner/species/knight/knight.dmi'
	icon_state = "knight_elegiast"
	robotic = ORGAN_ROBOT
	max_damage = 100

/obj/item/organ/external/chest/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/groin/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/head/knight
	eye_icon = "face"
	eye_icon_location = 'code/modules/halo/Forerunner/species/knight/knight.dmi'
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/arm/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/arm/right/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/leg/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/leg/right/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/hand/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/hand/right/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/foot/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/obj/item/organ/external/foot/right/knight
	robotic = ORGAN_ROBOT
	use_robotic_sprites = 0

/mob/living/carbon/human/knight/New(var/new_loc)
	. = ..(new_loc,"Knight")
	faction = "Forerunner"

#undef KNIGHT_DEATH_TP_DELAY
#undef KNIGHT_TELEPORT_ANIM_TIME
