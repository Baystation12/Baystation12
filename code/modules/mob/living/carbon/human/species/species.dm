/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/

/datum/species

	// Descriptors and strings.
	var/name                                             // Species name.
	var/name_plural                                      // Pluralized name (since "[name]s" is not always valid)
	var/blurb = "A completely nondescript species."      // A brief lore summary for use in the chargen screen.

	// Icon/appearance vars.
	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	var/prone_icon                                       // If set, draws this from icobase when mob is prone.
	var/has_floating_eyes                                // Eyes will overlay over darkness (glow)
	var/blood_color = "#A10808"                          // Red.
	var/flesh_color = "#FFC896"                          // Pink.
	var/base_color                                       // Used by changelings. Should also be used for icon previes..
	var/tail                                             // Name of tail state in species effects icon file.
	var/tail_animation                                   // If set, the icon to obtain tail animation states from.
	var/tail_hair
	var/race_key = 0       	                             // Used for mob icon cache string.
	var/icon/icon_template                               // Used for mob icon generation for non-32x32 species.
	var/mob_size	= MOB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	var/short_sighted                                    // Permanent weldervision.
	var/blood_volume = 560                               // Initial blood volume.
	var/hunger_factor = DEFAULT_HUNGER_FACTOR            // Multiplier for hunger.
	var/taste_sensitivity = TASTE_NORMAL                 // How sensitive the species is to minute tastes.

	var/min_age = 17
	var/max_age = 70

	// Language/culture vars.
	var/default_language = "Galactic Common" // Default language is used when 'say' is used without modifiers.
	var/language = "Galactic Common"         // Default racial language, if any.
	var/list/secondary_langs = list()        // The names of secondary languages that are available to this species.
	var/list/speech_sounds                   // A list of sounds to potentially play when speaking.
	var/list/speech_chance                   // The likelihood of a speech sound playing.
	var/num_alternate_languages = 0          // How many secondary languages are available to select at character creation
	var/name_language = "Galactic Common"    // The language to use when determining names for this species, or null to use the first name/last name generator

	// Combat vars.
	var/total_health = 100                   // Point at which the mob will enter crit.
	var/list/unarmed_types = list(           // Possible unarmed attacks that the mob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null          // For empty hand harm-intent attack
	var/brute_mod =     1                    // Physical damage multiplier.
	var/burn_mod =      1                    // Burn damage multiplier.
	var/oxy_mod =       1                    // Oxyloss modifier
	var/toxins_mod =    1                    // Toxloss modifier
	var/radiation_mod = 1                    // Radiation modifier
	var/flash_mod =     1                    // Stun from blindness modifier.
	var/metabolism_mod = 1					 // Reagent metabolism modifier
	var/vision_flags = SEE_SELF              // Same flags as glasses.

	// Death vars.
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/human
	var/remains_type = /obj/item/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"
	var/halloss_message = "slumps to the ground, too weak to continue fighting."
	var/halloss_message_self = "You're in too much pain to keep going..."

	var/spawns_with_stack = 0
	// Environment tolerance/life processes vars.
	var/reagent_tag                                   //Used for metabolizing reagents.
	var/breath_pressure = 16                          // Minimum partial pressure safe for breathing, kPa
	var/breath_type = "oxygen"                        // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"                        // Poisonous air.
	var/exhale_type = "carbon_dioxide"                // Exhaled gas type.
	var/cold_level_1 = 260                            // Cold damage level 1 below this point.
	var/cold_level_2 = 200                            // Cold damage level 2 below this point.
	var/cold_level_3 = 120                            // Cold damage level 3 below this point.
	var/heat_level_1 = 360                            // Heat damage level 1 above this point.
	var/heat_level_2 = 400                            // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                           // Heat damage level 3 above this point.
	var/passive_temp_gain = 0		                  // Species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.
	var/light_dam                                     // If set, mob will be damaged in light over this value and heal in light below its negative.
	var/body_temperature = 310.15	                  // Species will try to stabilize at this temperature.
	                                                  // (also affects temperature processing)

	var/heat_discomfort_level = 315                   // Aesthetic messages about feeling warm.
	var/cold_discomfort_level = 285                   // Aesthetic messages about feeling chilly.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type
	var/health_hud_intensity = 1

	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/has_fine_manipulation = 1 // Can use small items.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight = 2             // Native darksight distance.
	var/flags = 0                 // Various specific features.
	var/appearance_flags = 0      // Appearance/display related features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	var/slowdown = 0              // Passive movement speed malus (or boost, if negative)
	var/primitive_form            // Lesser form, if any (ie. monkey for humans)
	var/greater_form              // Greater form, if any, ie. human for monkeys.
	var/holder_type
	var/gluttonous                // Can eat some mobs. Values can be GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING, GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT
	var/stomach_capacity = 5      // How much stuff they can stick in their stomach
	var/rarity_value = 1          // Relative rarity/collector value for this species.
	                              // Determines the organs that the species spawns with and
	var/list/has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	var/vision_organ              // If set, this organ is required for vision. Defaults to "eyes" if the species has them.

	var/list/has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	var/list/genders = list(MALE, FEMALE)

	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

	var/pass_flags = 0
	var/breathing_sound = 'sound/voice/monkey.ogg'

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/get_bodytype()
	return name

/datum/species/proc/get_knockout_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/datum/species/proc/get_death_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)

/datum/species/proc/get_ssd(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "flashing a 'system offline' glyph on their monitor" : show_ssd)

/datum/species/proc/get_blood_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_BLOOD_COLOUR : blood_color)

/datum/species/proc/get_virus_immune(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? 1 : virus_immune)

/datum/species/proc/get_flesh_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/datum/species/proc/get_halloss_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots." : halloss_message)

/datum/species/proc/get_halloss_message_self(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..." : halloss_message_self)

/datum/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H, var/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.l_hand == clothes|| H.r_hand == clothes)
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				H << "<span class='danger'>[pick(cold_discomfort_strings)]</span>"
		if("heat")
			if(covered)
				H << "<span class='danger'>[pick(heat_discomfort_strings)]</span>"

/datum/species/proc/sanitize_name(var/name)
	return sanitizeName(name)

/datum/species/proc/get_random_name(var/gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	var/datum/language/species_language = all_languages[name_language]
	if(!species_language)
		species_language = all_languages[default_language]
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	if(H.backbag == 1)
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
		else	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		else	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.

	H.mob_size = mob_size
	for(var/obj/item/organ/organ in H.contents)
		if((organ in H.organs) || (organ in H.internal_organs))
			qdel(organ)

	if(H.organs)                  H.organs.Cut()
	if(H.internal_organs)         H.internal_organs.Cut()
	if(H.organs_by_name)          H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(H)
		organ_data["descriptor"] = O.name

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H,1)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O

	for(var/name in H.organs_by_name)
		H.organs |= H.organs_by_name[name]

	for(var/name in H.internal_organs_by_name)
		H.internal_organs |= H.internal_organs_by_name[name]

	for(var/obj/item/organ/O in (H.organs|H.internal_organs))
		O.owner = H

	H.sync_organ_dna()

/datum/species/proc/hug(var/mob/living/carbon/human/H,var/mob/living/target)

	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(var/mob/other)
	return

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)

	if(!ignore_intent && H.a_intent != I_HURT)
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

// Called in life() when the mob has no client.
/datum/species/proc/handle_npc(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/handle_vision(var/mob/living/carbon/human/H)
	H.update_sight()
	H.sight |= get_vision_flags(H)
	H.sight |= H.equipment_vision_flags

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.see_in_dark = (H.sight == SEE_TURFS|SEE_MOBS|SEE_OBJS) ? 8 : min(darksight + H.equipment_darkness_modifier, 8)
		if(H.seer)
			var/obj/effect/rune/R = locate() in H.loc
			if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
				H.see_invisible = SEE_INVISIBLE_CULT
		if(H.see_invisible != SEE_INVISIBLE_CULT && H.equipment_see_invis)
			H.see_invisible = min(H.see_invisible, H.equipment_see_invis)

	if(H.equipment_tint_total >= TINT_BLIND)
		H.eye_blind = max(H.eye_blind, 1)

	if(!H.client)//no client, no screen to update
		return 1

	H.set_fullscreen(H.eye_blind && !H.equipment_prescription, "blind", /obj/screen/fullscreen/blind)

	if(config.welder_vision)
		H.set_fullscreen(H.equipment_tint_total, "welder", /obj/screen/fullscreen/impaired, H.equipment_tint_total)
	var/how_nearsighted = get_how_nearsighted(H)
	H.set_fullscreen(how_nearsighted, "nearsighted", /obj/screen/fullscreen/oxy, how_nearsighted)
	H.set_fullscreen(H.eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
	H.set_fullscreen(H.druggy, "high", /obj/screen/fullscreen/high)

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	return 1

/datum/species/proc/get_how_nearsighted(var/mob/living/carbon/human/H)
	. = short_sighted
	if(H.disabilities & NEARSIGHTED)
		. += 7
	if(H.equipment_prescription)
		. -= H.equipment_prescription
	return Clamp(., 0, 7)
