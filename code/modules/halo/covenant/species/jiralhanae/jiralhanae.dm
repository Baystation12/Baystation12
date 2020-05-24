
GLOBAL_LIST_INIT(first_names_jiralhanae, world.file2list('code/modules/halo/covenant/species/jiralhanae/first_jiralhanae.txt'))

/mob/living/carbon/human/covenant/jiralhanae/New(var/new_loc)
	. = ..(new_loc,"Jiralhanae")

/datum/language/doisacci
	name = "Doisacci"
	desc = "The language of the Jiralhanae"
	native = 1
	colour = "jiralhanae"
	syllables = list("ung","ugh","uhh","hss","grss","grah","argh","hng","ung","uss","hoh","rog")
	key = "D"
	flags = RESTRICTED

/datum/species/brutes
	name = "Jiralhanae"
	name_plural = "Jiralhanae"
	blurb = "The Jiralhanae (Latin, Servus ferox, translated to \"Wild Slave\"), \
		known by humans as Brutes, are the most recent members of the Covenant. \
		They are a large, bipedal, warlike species resembling apes that resent \
		the Sangheili for their respected position in the Covenant. They are organised\
		into tribes and packs, and in combat utilise crute brute force weaponry.\
		If they are hurt or angry enough, they can enter a beserk rage where they are \
		near immune to pain and damage."
	flesh_color = "#4A4A64"
	blood_color = "#E61A65"
	icobase = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_mob.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_mob.dmi'
	icon_template = 'code/modules/halo/covenant/species/jiralhanae//jiralhanae_template.dmi'
	damage_overlays = 'code/modules/halo/icons/species/dam_jiralhanae.dmi'
	damage_mask = 'code/modules/halo/icons/species/dam_mask_jiralhanae.dmi'
	blood_mask = 'code/modules/halo/icons/species/blood_jiralhanae.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	additional_langs = list("Doisacci")
	flags = NO_MINOR_CUT
	appearance_flags = HAS_SKIN_TONE
	total_health = 300 //Higher base health than spartans and sangheili
	radiation_mod = 0.6
	spawn_flags = SPECIES_CAN_JOIN
	brute_mod = 0.7 //receives 70% of brute damage
	pain_mod = 0.25 //receives 25% pain damage.
	burn_mod = 0.7  // receives 70% of burn damage
	explosion_effect_mod = 0.5
	can_force_door = 1
	default_faction = "Covenant"
	pixel_offset_x = -12
	item_icon_offsets = list(list(10,4),list(10,4),null,list(6,2),null,null,null,list(6,2),null)
	unarmed_types = list(/datum/unarmed_attack/brute_punch)
	inherent_verbs = list()

	equipment_slowdown_multiplier = 0.3

	pain_scream_sounds = list(\
	'code/modules/halo/sounds/species_pain_screams/brutescream1.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream2.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream3.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream4.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream5.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream6.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream7.ogg',
	'code/modules/halo/sounds/species_pain_screams/brutescream8.ogg')

	per_roll_delay = 3 //Slightly higher per roll delay than a human, because they're a bit bulkier

/datum/species/brutes/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return

/datum/species/brutes/get_random_name(var/gender)
	var/newname = pick(GLOB.first_names_jiralhanae)
	return newname

/datum/unarmed_attack/brute_punch
    attack_verb = list("clobbers", "smashes", "backhands", "punches", "slams")
    attack_noun = list("fist")
    eye_attack_text = "fingers"
    eye_attack_text_victim = "digits"
    damage = 25
