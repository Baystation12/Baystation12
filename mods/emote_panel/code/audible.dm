#define SOUNDED_SPECIES list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER, SPECIES_MULE, SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_SKRELL)

/singleton/emote/audible
	// three-dimensional array
	// first is the species, associated to a list of genders, associated to a list of the sound effects to use
	var/list/sounded_species = null

/singleton/emote/audible/do_extra(atom/user)
	if(emote_sound) do_sound(user)

/singleton/emote/audible/proc/do_sound(atom/user)
	var/mob/living/carbon/human/H = user
	if(H.stat) return // No dead or unconcious people screaming pls.
	if(istype(H))
		if(sounded_species)
			if(H.species.name in sounded_species)
				if(islist(emote_sound))
					if(H.species.name == SPECIES_SKRELL)
						if(H.head_hair_style == "Skrell Male Tentacles")
							return playsound(user.loc, pick(emote_sound[MALE]), 50, 0)
						else
							return playsound(user.loc, pick(emote_sound[FEMALE]), 50, 0)
					if(emote_sound[H.gender])
						return playsound(user.loc, pick(emote_sound[H.gender]), 50, 0)
		return playsound(user.loc, pick(emote_sound), 50, 0)

/singleton/emote/audible/gasp
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/gasp_male1.ogg',
			'mods/emote_panel/sound/gasp_male2.ogg',
			'mods/emote_panel/sound/gasp_male3.ogg',
			'mods/emote_panel/sound/gasp_male4.ogg',
			'mods/emote_panel/sound/gasp_male5.ogg',
			'mods/emote_panel/sound/gasp_male6.ogg',
			'mods/emote_panel/sound/gasp_male7.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/gasp_female1.ogg',
			'mods/emote_panel/sound/gasp_female2.ogg',
			'mods/emote_panel/sound/gasp_female3.ogg',
			'mods/emote_panel/sound/gasp_female4.ogg',
			'mods/emote_panel/sound/gasp_female5.ogg',
			'mods/emote_panel/sound/gasp_female6.ogg',
			'mods/emote_panel/sound/gasp_female7.ogg'
		)
	)
	sounded_species = list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER,
	SPECIES_MULE,
	SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_VOX, SPECIES_SKRELL)

/singleton/emote/audible/whistle
	emote_sound = 'mods/emote_panel/sound/whistle.ogg'
	sounded_species = list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER,
	SPECIES_MULE,
	SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_VOX, SPECIES_IPC,
	SPECIES_SKRELL)

/singleton/emote/audible/sneeze
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/sneeze_male_1.ogg',
			'mods/emote_panel/sound/sneeze_male_2.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/sneeze_female_1.ogg',
			'mods/emote_panel/sound/sneeze_female_2.ogg'
		)
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/snore
	emote_sound = list(
		'mods/emote_panel/sound/snore_1.ogg',
		'mods/emote_panel/sound/snore_2.ogg',
		'mods/emote_panel/sound/snore_3.ogg',
		'mods/emote_panel/sound/snore_4.ogg',
		'mods/emote_panel/sound/snore_5.ogg',
		'mods/emote_panel/sound/snore_6.ogg',
		'mods/emote_panel/sound/snore_7.ogg'
	)
	sounded_species = list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER,
	SPECIES_MULE,
	SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_VOX, SPECIES_SKRELL)

/singleton/emote/audible/yawn
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/yawn_male_1.ogg',
			'mods/emote_panel/sound/yawn_male_2.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/yawn_female_1.ogg',
			'mods/emote_panel/sound/yawn_female_2.ogg',
			'mods/emote_panel/sound/yawn_female_3.ogg'
		)
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/clap
	emote_sound = 'mods/emote_panel/sound/clap.ogg'

/singleton/emote/audible/cough
	emote_sound = list(
		MALE = 'mods/emote_panel/sound/cough_male.ogg',
		FEMALE = 'mods/emote_panel/sound/cough_female.ogg'
	)
	sounded_species = list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER,
	SPECIES_MULE,
	SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_VOX, SPECIES_SKRELL)

/singleton/emote/audible/cry
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/cry_male_1.ogg',
			'mods/emote_panel/sound/cry_male_2.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/cry_female_1.ogg',
			'mods/emote_panel/sound/cry_female_2.ogg',
			'mods/emote_panel/sound/cry_female_3.ogg'
		)
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/sigh
	emote_sound = list(
		MALE = 'mods/emote_panel/sound/sigh_male.ogg',
		FEMALE = 'mods/emote_panel/sound/sigh_female.ogg'
	)
	sounded_species = list(SPECIES_HUMAN, SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER,
	SPECIES_MULE,
	SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_TAJARA, SPECIES_VOX, SPECIES_SKRELL)

/singleton/emote/audible/laugh
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/laugh_male_1.ogg',
			'mods/emote_panel/sound/laugh_male_2.ogg',
			'mods/emote_panel/sound/laugh_male_3.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/laugh_female_1.ogg',
			'mods/emote_panel/sound/laugh_female_2.ogg',
			'mods/emote_panel/sound/laugh_female_3.ogg'
		)
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/giggle
	emote_sound = list(
		MALE = 'mods/emote_panel/sound/giggle_male_1.ogg',
		FEMALE = 'mods/emote_panel/sound/giggle_female_1.ogg'
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/scream
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/scream_male_1.ogg',
			'mods/emote_panel/sound/scream_male_2.ogg',
			'mods/emote_panel/sound/scream_male_3.ogg'
		),
		FEMALE = list(
			'mods/emote_panel/sound/scream_female_1.ogg',
			'mods/emote_panel/sound/scream_female_2.ogg'
		)
	)
	sounded_species = SOUNDED_SPECIES

/singleton/emote/audible/scream/monkey
	emote_sound = list(
		'mods/emote_panel/sound/pain_monkey_1.ogg',
		'mods/emote_panel/sound/pain_monkey_2.ogg',
		'mods/emote_panel/sound/pain_monkey_3.ogg'
	)
	sounded_species = null

/singleton/emote/audible/cat_purr
	key = "purr"
	emote_message_3p = "USER мурчит."
	emote_sound = 'mods/emote_panel/sound/cat_purr.ogg'

/singleton/emote/audible/cat_purr/long
	key = "purrl"
	emote_sound = 'mods/emote_panel/sound/cat_purr_long.ogg'

/singleton/emote/audible/finger_snap
	key = "snap"
	emote_message_3p = "USER щёлкает пальцами."
	emote_sound = 'mods/emote_panel/sound/fingersnap.ogg'
