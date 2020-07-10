
GLOBAL_LIST_INIT(yanmee_nicknames, world.file2list('code/modules/halo/covenant/species/yanmee/yanmee_nicknames.txt'))

/datum/language/yanmee_hivemind
	name = "Yanme e Hivemind"
	desc = "The hivemind language of the Yanme e"
	native = 1
	colour = "vox"
	key = "Y"
	flags = RESTRICTED|NO_TALK_MSG|NO_STUTTER|HIVEMIND

/datum/unarmed_attack/bug_punch
    attack_verb = list("scratches", "kicks", "strikes", "slashes")
    attack_noun = list("hand")
    eye_attack_text = "hands"
    eye_attack_text_victim = "digits"
    damage = 0
    sharp = 1
    edge = 1

/datum/species/yanmee
	name = "Yanme e"
	name_plural = "Yanme e"
	blurb = "Yanme\'e, also known as drones, are the main covenant engineers aboard many of their vessels that have not been provided with\
Huragok Engineers. Their flight makes them hard to hit during combat and their natural EVA ability allows them to be easily deployed to fix external damage."
	flesh_color = "#FF9463"
	blood_color = "#E6E621"
	icobase = 'code/modules/halo/covenant/species/yanmee/r_yanmee.dmi'
	deform = 'code/modules/halo/covenant/species/yanmee/r_yanmee.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	additional_langs = list("Yanme e Hivemind")
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	inherent_verbs = list(/mob/living/carbon/human/proc/yanmee_flight_ability)
	spawn_flags = SPECIES_CAN_JOIN
	flags = NO_MINOR_CUT
	darksight = 4
	brute_mod = 1.2
	burn_mod = 1.2
	slowdown = -0.3
	gluttonous = GLUT_ANYTHING
	pixel_offset_x = -1
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/bug_punch)

	warning_low_pressure = 25
	hazard_low_pressure = -1

	item_icon_offsets = list(list(1,0),list(1,0),null,list(1,0),null,null,null,list(-1,0),null)

	roll_distance = 3
	gibbed_anim = null
	dusted_anim = null

	pain_scream_sounds = list(\
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_1.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_2.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_3.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_4.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_5.ogg')

/datum/species/yanmee/create_organs(var/mob/living/carbon/human/H)
	. = ..()
	H.equip_to_slot(new /obj/item/clothing/under/yanmee_internal,slot_w_uniform)
	H.equip_to_slot(new /obj/item/clothing/shoes/drone_boots,slot_shoes)
	H.equip_to_slot(new /obj/item/clothing/gloves/drone_gloves,slot_gloves)

/datum/species/yanmee/get_random_name(var/gender)
	return pick(GLOB.yanmee_nicknames)


/datum/species/yanmee/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.name = "Yanme\'e [rand(0,999)] \"[H.name]\""
	H.real_name = H.name

/datum/species/yanmee/apply_species_name_formatting(var/to_format_name)
	return "Yanme\'e [rand(1,999)] \"[to_format_name]\""

/datum/species/yanmee/handle_flight_failure(var/mob/living/carbon/human/H)
	H.visible_message("<span class = 'warning'>[name] is unable to support their flight and falls to the ground, reflexively slowing their fall with their wings!</span>")
	if(H.flight_item)
		H.flight_item.deactivate(H,0)
	else
		H.change_elevation(-H.elevation)
	if(istype(H.loc,/turf/simulated/open))
		H.fall()
	Stun(1)
	return 1

/mob/living/carbon/human/covenant/yanmee/New(var/new_loc)
	. = ..(new_loc,"Yanme e")
