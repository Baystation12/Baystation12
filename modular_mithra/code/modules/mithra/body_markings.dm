////////////////////////
// All the sprite accesories pilfered from Virgo.
////////////////////////
/* Disabled pending porting all the species
/datum/sprite_accessory/hair

	//var/icon_add = 'icons/mob/human_face.dmi' //Already defined in sprite_accessories.dm line 49.
	var/color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJ,SPECIES_TESHARI,SPECIES_NEVREAN,SPECIES_AKULA,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_XENOHYBRID,SPECIES_VASILISSAN,SPECIES_RAPALA,SPECIES_PROTEAN,SPECIES_ALRAUNE) //This lets all races use the default hairstyles.

	awoohair
		name = "Shoulder-length Messy"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "momijihair"

	citheronia
		name = "Citheronia Hair (Kira72)"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_state = "citheronia_hair"
		ckeys_allowed = list("Kira72")
		do_colouration = 0

	taramaw
		name = "Hairmaw (Liquidfirefly)"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_state = "maw_hair"
		ckeys_allowed = list("liquidfirefly")
		do_colouration = 0

	citheronia_colorable
		name = "Citheronia Hair"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "citheronia_hair_c"
		do_colouration = 1

	sergal_plain
		name = "Sergal Plain"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "serg_plain"
		species_allowed = list(SPECIES_SERGAL)

	sergal_medicore
		name = "Sergal Medicore"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "serg_medicore"
		species_allowed = list(SPECIES_SERGAL)

	sergal_tapered
		name = "Sergal Tapered"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "serg_tapered"
		species_allowed = list(SPECIES_SERGAL)

	sergal_fairytail
		name = "Sergal Fairytail"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "serg_fairytail"
		species_allowed = list(SPECIES_SERGAL)

	braid
		name = "Floorlength Braid"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "hair_braid"

	twindrills
		name = "Twin Drills"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "hair_twincurl"

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJ,SPECIES_TESHARI,SPECIES_NEVREAN,SPECIES_AKULA,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_XENOHYBRID,SPECIES_VASILISSAN,SPECIES_RAPALA,SPECIES_PROTEAN,SPECIES_ALRAUNE) //Lets all the races be bald if they want.

	ponytail6_fixed //Eggnerd's done with waiting for upstream fixes lmao.
		name = "Ponytail 6 but fixed"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "hair_ponytail6"
		species_allowed = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJ,SPECIES_NEVREAN,SPECIES_AKULA,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_XENOHYBRID,SPECIES_VASILISSAN,SPECIES_RAPALA,SPECIES_PROTEAN,SPECIES_ALRAUNE)

	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN) //Xenochimera get most hairstyles since they're abominations.

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)


	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_bighorns
		name = "Unathi Big Horns"
		icon_state = "unathi_bighorn"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_smallhorns
		name = "Unathi Small Horns"
		icon_state = "unathi_smallhorn"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_ramhorns
		name = "Unathi Ram Horns"
		icon_state = "unathi_ramhorn"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	una_sidefrills
		name = "Unathi Side Frills"
		icon_state = "unathi_sidefrills"
		species_allowed = list(SPECIES_UNATHI,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list(SPECIES_TAJ,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

//Skrell 'hairstyles' - these were requested for a chimera and screw it, if one wants to eat seafood, go nuts
	skr_tentacle_veryshort
		name = "Skrell Very Short Tentacles"
		icon_state = "skrell_hair_veryshort"
		species_allowed = list(SPECIES_SKRELL,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)
		gender = MALE

	skr_tentacle_short
		name = "Skrell Short Tentacles"
		icon_state = "skrell_hair_short"
		species_allowed = list(SPECIES_SKRELL,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	skr_tentacle_average
		name = "Skrell Average Tentacles"
		icon_state = "skrell_hair_average"
		species_allowed = list(SPECIES_SKRELL,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)

	skr_tentacle_verylong
		name = "Skrell Long Tentacles"
		icon_state = "skrell_hair_verylong"
		species_allowed = list(SPECIES_SKRELL,SPECIES_XENOCHIMERA,SPECIES_PROTEAN)
		gender = FEMALE

// Vulpa stuffs

	vulp_hair_none
		name = "None"
		icon_state = "bald"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

	vulp_hair_kajam
		name = "Kajam"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "kajam"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "keid"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "adhara"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "kleeia"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "mizar"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "apollo"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "belle"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "bun"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "jagged"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "curl"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "hawk"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "anita"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "short"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "spike"
		species_allowed = list(SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_TAJ,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_PROTEAN)
		gender = NEUTER

//xeno stuffs
	xeno_head_drone_color
		name = "Drone dome"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "cxeno_drone"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER
// figure this one out for better coloring
	xeno_head_sentinel_color
		name = "Sentinal dome"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "cxeno_sentinel"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_queen_color
		name = "Queen dome"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "cxeno_queen"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_hunter_color
		name = "Hunter dome"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "cxeno_hunter"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_praetorian_color
		name = "Praetorian dome"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_add = 'modular_mithra/icons/mob/human_face_add.dmi'
		icon_state = "cxeno_praetorian"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	var/color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_OLDUNATHI,SPECIES_TAJ,SPECIES_TESHARI,SPECIES_NEVREAN,SPECIES_AKULA,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_XENOHYBRID,SPECIES_VASILISSAN,SPECIES_RAPALA,SPECIES_PROTEAN,SPECIES_ALRAUNE) //This lets all races use the facial hair styles.

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_OLDUNATHI,SPECIES_TAJ,SPECIES_TESHARI,SPECIES_NEVREAN,SPECIES_AKULA,SPECIES_SERGAL,SPECIES_ZORREN_FLAT,SPECIES_ZORREN_HIGH,SPECIES_VULPKANIN,SPECIES_XENOCHIMERA,SPECIES_XENOHYBRID,SPECIES_VASILISSAN,SPECIES_RAPALA,SPECIES_PROTEAN,SPECIES_ALRAUNE) //This needed to be manually defined, apparantly.


	vulp_none
		name = "None"
		icon = 'modular_mithra/icons/mob/human_face.dmi'
		icon_state = "none"
		species_allowed = list(SPECIES_VULPKANIN)
		gender = NEUTER

//Special hairstyles
/datum/sprite_accessory/ears/inkling
	name = "colorable mature inkling hair"
	desc = ""
	icon = 'modular_mithra/icons/mob/human_face.dmi'
	icon_state = "inkling-colorable"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
*/
//MITHRAstation Body Markings and Overrides
//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking //Override for base markings
	var/color_blend_mode = ICON_ADD

/datum/sprite_accessory/marking/vr
	icon = 'modular_mithra/icons/mob/human_races/markings.dmi'
	do_colouration = 1

	vulp_belly
		name = "belly fur (Vulp)"
		icon_state = "vulp_belly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	vulp_fullbelly
		name = "full belly fur (Vulp)"
		icon_state = "vulp_fullbelly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	vulp_crest
		name = "belly crest (Vulp)"
		icon_state = "vulp_crest"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	vulp_nose
		name = "nose (Vulp)"
		icon_state = "vulp_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	snoutstripe
		name = "snout stripe (Vulp)"
		icon_state = "snoutstripe"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_face
		name = "face (Vulp)"
		icon_state = "vulp_face"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_earsface
		name = "ears and face (Vulp)"
		icon_state = "vulp_earsface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_all
		name = "all head highlights (Vulp)"
		icon_state = "vulp_all"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_blaze
		name = "blaze (Vulp)"
		icon_state = "vulp_blaze"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_vulpine
		name = "vulpine (Vulp)"
		icon_state = "vulp_vulpine"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_earfluff
		name = "earfluff (Vulp)"
		icon_state = "vulp_earfluff"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_mask
		name = "mask (Vulp)"
		icon_state = "vulp_mask"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_patch
		name = "patch (Vulp)"
		icon_state = "vulp_patch"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_ruff
		name = "ruff (Vulp)"
		icon_state = "vulp_ruff"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_kita
		name = "kita (Vulp)"
		icon_state = "vulp_kita"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	vulp_swift
		name = "swift (Vulp)"
		icon_state = "vulp_swift"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sergal_full
		name = "Sergal Markings"
		icon_state = "sergal_full"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	sergal_full_female
		name = "Sergal Markings (Female)"
		icon_state = "sergal_full_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	monoeye
		name = "Monoeye"
		icon_state = "monoeye"
		body_parts = list(BP_HEAD)

	spidereyes
		name = "Spider Eyes"
		icon_state = "spidereyes"
		body_parts = list(BP_HEAD)

	vasseyes
		name = "Vassilisan Eyes"
		icon_state = "vasseyes"
		body_parts = list(BP_HEAD)

	vasseyesalt
		name = "Vassilisan Eyes (Alt)"
		icon_state = "vasseyesalt"
		body_parts = list(BP_HEAD)

	sergaleyes
		name = "Sergal Eyes"
		icon_state = "eyes_sergal"
		body_parts = list(BP_HEAD)

	brows
		name = "Eyebrows"
		icon_state = "brows"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	nevrean_female
		name = "Female Nevrean beak"
		icon_state = "nevrean_f"
		body_parts = list(BP_HEAD)
		color_blend_mode = ICON_MULTIPLY
		gender = FEMALE

	nevrean_male
		name = "Male Nevrean beak"
		icon_state = "nevrean_m"
		body_parts = list(BP_HEAD)
		color_blend_mode = ICON_MULTIPLY
		gender = MALE

	spots
		name = "Spots"
		icon_state = "spots"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)

	shaggy_mane
		name = "Shaggy mane/feathers"
		icon_state = "shaggy"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST)

	jagged_teeth
		name = "Jagged teeth"
		icon_state = "jagged"
		body_parts = list(BP_HEAD)

	saber_teeth
		name = "Saber teeth"
		icon_state = "saber"
		body_parts = list(BP_HEAD)

	fangs
		name = "Fangs"
		icon_state = "fangs"
		body_parts = list(BP_HEAD)

	tusks
		name = "Tusks"
		icon_state = "tusks"
		body_parts = list(BP_HEAD)

	otie_face
		name = "Otie face"
		icon_state = "otieface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otie_nose
		name = "Otie nose"
		icon_state = "otie_nose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otienose_lite
		name = "Short otie nose"
		icon_state = "otienose_lite"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	backstripes
		name = "Back stripes"
		icon_state = "otiestripes"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_HEAD)

	belly_butt
		name = "Belly and butt"
		icon_state = "bellyandbutt"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN,BP_CHEST)

	fingers_toes
		name = "Fingers and toes"
		icon_state = "fingerstoes"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

	otie_socks
		name = "Fingerless socks"
		icon_state = "otiesocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	corvid_beak
		name = "Corvid beak"
		icon_state = "corvidbeak"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	corvid_belly
		name = "Corvid belly"
		icon_state = "corvidbelly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN,BP_CHEST,BP_HEAD)

	cow_body
		name = "Cow markings"
		icon_state = "cowbody"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	cow_nose
		name = "Cow nose"
		icon_state = "cownose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	zmask
		name = "Eye mask"
		icon_state = "zmask"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	zbody
		name = "Thick jagged stripes"
		icon_state = "zbody"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_CHEST)

	znose
		name = "Jagged snout"
		icon_state = "znose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otter_nose
		name = "Otter nose"
		icon_state = "otternose"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	otter_face
		name = "Otter face"
		icon_state = "otterface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	deer_face
		name = "Deer face"
		icon_state = "deerface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sharkface
		name = "Akula snout"
		icon_state = "sharkface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sheppy_face
		name = "Shepherd snout"
		icon_state = "shepface"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	sheppy_back
		name = "Shepherd back"
		icon_state = "shepback"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	zorren_belly_male
		name = "Zorren Male Torso"
		icon_state = "zorren_belly"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	zorren_belly_female
		name = "Zorren Female Torso"
		icon_state = "zorren_belly_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST,BP_GROIN)

	zorren_back_patch
		name = "Zorren Back Patch"
		icon_state = "zorren_backpatch"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST)

	zorren_face_male
		name = "Zorren Male Face"
		icon_state = "zorren_face"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = MALE

	zorren_face_female
		name = "Zorren Female Face"
		icon_state = "zorren_face_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = FEMALE

	zorren_muzzle_male
		name = "Zorren Male Muzzle"
		icon_state = "zorren_muzzle"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = MALE

	zorren_muzzle_female
		name = "Zorren Female Muzzle"
		icon_state = "zorren_muzzle_female"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
		gender = FEMALE

	zorren_socks
		name = "Zorren Socks"
		icon_state = "zorren_socks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	zorren_longsocks
		name = "Zorren Longsocks"
		icon_state = "zorren_longsocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

	harpy_feathers
		name = "Rapala leg Feather"
		icon_state = "harpy-feathers"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG)

	harpy_legs
		name = "Rapala leg coloring"
		icon_state = "harpy-leg"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

	chooves
		name = "Cloven hooves"
		icon_state = "chooves"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT)

	alurane
		name = "Alurane Body"
		icon_state = "alurane"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)
		ckeys_allowed = list("natje")

	body_tone
		name = "Body toning (for emergency contrast loss)"
		icon_state = "btone"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)

	gloss
		name = "Full body gloss"
		icon_state = "gloss"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	eboop_panels
		name = "Eggnerd FBP panels"
		icon_state = "eboop"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	osocks_rarm
		name = "Modular Longsock (right arm)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_ARM,BP_R_HAND)

	osocks_larm
		name = "Modular Longsock (left arm)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_ARM,BP_L_HAND)

	osocks_rleg
		name = "Modular Longsock (right leg)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_FOOT,BP_R_LEG)

	osocks_lleg
		name = "Modular Longsock (left leg)"
		icon_state = "osocks"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_L_LEG)

	animeeyesinner
		name = "Anime Eyes Inner"
		icon_state = "animeeyesinner"
		body_parts = list(BP_HEAD)

	animeeyesouter
		name = "Anime Eyes Outer"
		icon_state = "animeeyesouter"
		body_parts = list(BP_HEAD)

	panda_eye_marks
		name = "Panda Eye Markings"
		icon_state = "eyes_panda"
		body_parts = list(BP_HEAD)
		species_allowed = list("Human")

	catwomantorso
		name = "Catwoman chest stripes"
		icon_state = "catwomanchest"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_CHEST)

	catwomangroin
		name = "Catwoman groin stripes"
		icon_state = "catwomangroin"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_GROIN)

	catwoman_rleg
		name = "Catwoman right leg stripes"
		icon_state = "catwomanright"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_R_LEG)

	catwoman_lleg
		name = "Catwoman left leg stripes"
		icon_state = "catwomanleft"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG)

	spirit_lights
		name = "Ward - Spirit FBP Lights"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_HEAD)

	spirit_lights_body
		name = "Ward - Spirit FBP Lights (body)"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST)

	spirit_panels_head
		name = "Ward - Spirit FBP Lights (head)"
		icon_state = "lights"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	spirit_panels
		name = "Ward - Spirit FBP Panels"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST,BP_HEAD)

	spirit_panels_body
		name = "Ward - Spirit FBP Panels (body)"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)

	spirit_panels_head
		name = "Ward - Spirit FBP Panels (head)"
		icon_state = "panels"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	heterochromia
		name = "Heterochromia"
		icon_state = "heterochromia"
		body_parts = list(BP_HEAD)

	voxscales
		name = "Vox Scales"
		icon_state = "Voxscales"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_HEAD)

	voxclaws
		name = "Vox Claws"
		icon_state = "Voxclaws"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

	voxbeak
		name = "Vox Beak"
		icon_state = "Voxscales"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	unathihood
		name = "Cobra Hood"
		icon_state = "unathihood"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)

	unathidoublehorns
		name = "Double Unathi Horns"
		icon_state = "unathidoublehorns"
		color_blend_mode = ICON_MULTIPLY
		body_parts = list(BP_HEAD)
