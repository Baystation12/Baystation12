// SIERRA TODO: Use these sounds
#define PICK_MALE_PAIN_SOUND pick(\
	'mods/emote_panel/sound/pain_male_1.ogg', \
	'mods/emote_panel/sound/pain_male_2.ogg', \
	'mods/emote_panel/sound/pain_male_3.ogg' \
)
#define PICK_FEMALE_PAIN_SOUND pick(\
	'mods/emote_panel/sound/agony_female_1.ogg', \
	'mods/emote_panel/sound/agony_female_2.ogg', \
	'mods/emote_panel/sound/agony_female_3.ogg' \
)
#define PICK_MALE_MOAN_SOUND pick(\
	'mods/emote_panel/sound/moan_male_1.ogg', \
	'mods/emote_panel/sound/moan_male_2.ogg', \
	'mods/emote_panel/sound/moan_male_3.ogg' \
)
#define PICK_FEMALE_MOAN_SOUND pick(\
	'mods/emote_panel/sound/moan_female_1.ogg', \
	'mods/emote_panel/sound/moan_female_2.ogg', \
	'mods/emote_panel/sound/moan_female_3.ogg' \
)

/mob/living/proc/agony_scream()
	if(stat || is_species(SPECIES_MONKEY))
		return
	var/scream_sound = null
	var/message = null

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!is_muzzled())
			switch(gender)
				if(MALE) scream_sound = PICK_MALE_PAIN_SOUND
				if(FEMALE) scream_sound = PICK_FEMALE_PAIN_SOUND
			message = "кричит от боли!"
		else
			message = "издает громкое мычание!"

	if(message)
		custom_emote(2, message)

/mob/living/proc/agony_moan()
	if(stat || is_species(SPECIES_MONKEY))
		return
	var/moan_sound = null
	var/message = null

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!is_muzzled())
			switch(gender)
				if(MALE) moan_sound = PICK_MALE_MOAN_SOUND
				if(FEMALE) moan_sound = PICK_FEMALE_MOAN_SOUND
			message = "стонет от боли!"
		else
			message = "издает громкое мычание!"

		if(moan_sound)
			if(H.species.name in SOUNDED_SPECIES)
				playsound(src, moan_sound, 50, 0, 1)

	if(message)
		custom_emote(2, message)

#undef PICK_MALE_PAIN_SOUND
#undef PICK_FEMALE_PAIN_SOUND
#undef PICK_MALE_MOAN_SOUND
#undef PICK_FEMALE_MOAN_SOUND
