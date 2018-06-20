/mob/living/carbon/human/mantid
	var/mantid_type

/mob/living/carbon/human/mantid/New(newloc)
	..(newloc, mantid_type)

/mob/living/carbon/human/mantid/Initialize()
	. = ..()
	GLOB.hunters.equip(src)
	var/decl/cultural_info/culture = cultural_info[TAG_CULTURE]
	real_name = culture.get_random_name(gender)
	name = real_name
	if(wearing_rig)
		wearing_rig.visible_name = real_name

/mob/living/carbon/human/mantid/gyne
	mantid_type = SPECIES_MANTID_GYNE

/mob/living/carbon/human/mantid/monarch_worker
	mantid_type = SPECIES_MONARCH_WORKER

/mob/living/carbon/human/mantid/monarch_queen
	mantid_type = SPECIES_MONARCH_QUEEN

/mob/living/carbon/human/mantid/alate
	mantid_type = SPECIES_MANTID_ALATE
