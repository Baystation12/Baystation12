
#define COVENANT_SPECIES_AND_MOBS list(\
	/datum/species/kig_yar,\
	/datum/species/unggoy,\
	/datum/species/brutes,\
	/datum/species/sangheili,\
	/datum/species/kig_yar_skirmisher,\
	/datum/species/sanshyuum,\
	/datum/species/yanmee,\
	/mob/living/simple_animal/engineer,\
	/mob/living/simple_animal/hostile/covenant,\
	/mob/living/silicon/robot/huragok,\
	/mob/living/carbon/human/covenant)

/proc/is_covenant_mob(var/mob/user)
	if(user.type in COVENANT_SPECIES_AND_MOBS)
		return 1

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.type in COVENANT_SPECIES_AND_MOBS)
			return 1

	return 0