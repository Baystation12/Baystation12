/datum/species/unathi/default_emotes = list(
	/singleton/emote/human/swish,
	/singleton/emote/human/wag,
	/singleton/emote/human/sway,
	/singleton/emote/human/qwag,
	/singleton/emote/human/fastsway,
	/singleton/emote/human/swag,
	/singleton/emote/human/stopsway,
	/singleton/emote/audible/lizard_bellow,
	/singleton/emote/audible/lizard_squeal,
	/singleton/emote/audible/lizard_scream,
	/singleton/emote/audible/lizard_roar,
	/singleton/emote/audible/lizard_rumble,
	/singleton/emote/audible/lizard_threat
)

/datum/species/unathi/yeosa/default_emotes = list(
	/singleton/emote/human/swish,
	/singleton/emote/human/wag,
	/singleton/emote/human/sway,
	/singleton/emote/human/qwag,
	/singleton/emote/human/fastsway,
	/singleton/emote/human/swag,
	/singleton/emote/human/stopsway,
	/singleton/emote/audible/lizard_bellow,
	/singleton/emote/audible/lizard_squeal,
	/singleton/emote/audible/lizard_scream,
	/singleton/emote/audible/lizard_roar,
	/singleton/emote/audible/lizard_rumble,
	/singleton/emote/audible/lizard_threat
)

/singleton/emote/audible/lizard_bellow
	key = "bellow"
	emote_message_3p_target = "USER утробно рычит на TARGET!"
	emote_message_3p = "USER рычит!"
	emote_sound = 'sound/voice/LizardBellow.ogg'

/singleton/emote/audible/lizard_squeal
	key = "squeal"
	emote_message_3p = "USER визжит."
	emote_sound = 'sound/voice/LizardSqueal.ogg'

/singleton/emote/audible/lizard_scream
	key = "scream"
	emote_message_3p = "USER кричит!"
	emote_sound = list(
		MALE = list(
			'mods/emote_panel/sound/unathi/m_u_scream.ogg', 'mods/emote_panel/sound/unathi/m_u_scream2.ogg'),
		FEMALE = list(
			'mods/emote_panel/sound/unathi/f_u_scream.ogg', 'mods/emote_panel/sound/unathi/f_u_scream2.ogg'))

/singleton/emote/audible/lizard_roar
	key = "roar"
	emote_message_3p = "USER издаёт рёв!"
	emote_sound = list(
		'mods/emote_panel/sound/unathi/roar.ogg',
		'mods/emote_panel/sound/unathi/roar2.ogg',
		'mods/emote_panel/sound/unathi/roar3.ogg'
	)

/singleton/emote/audible/lizard_rumble
	key = "rumble"
	emote_message_3p = "USER урчит"
	emote_sound = list(
		'mods/emote_panel/sound/unathi/rumble.ogg',
		'mods/emote_panel/sound/unathi/rumble2.ogg'
	)

/singleton/emote/audible/lizard_threat
	key = "threat"
	emote_message_3p_target = "USER угрожающе раскрывает пасть на TARGET!"
	emote_message_3p = "USER грозно рычит"
	emote_sound = list(
		'mods/emote_panel/sound/unathi/threat.ogg',
		'mods/emote_panel/sound/unathi/threat2.ogg'
	)

/mob/living/carbon/human/unathi/verb/lizard_bellow()
	set name = "Рычать"
	set category = "Emote"
	emote("bellow")

/mob/living/carbon/human/unathi/verb/lizard_squeal()
	set name = "Визжать"
	set category = "Emote"
	emote("squeal")

/mob/living/carbon/human/unathi/verb/lizard_scream()
	set name = "Кричать"
	set category = "Emote"
	emote("scream")

/mob/living/carbon/human/unathi/verb/lizard_roar()
	set name = "Издать рёв"
	set category = "Emote"
	emote("roar")

/mob/living/carbon/human/unathi/verb/lizard_rumble()
	set name = "Урчать"
	set category = "Emote"
	emote("rumble")

/mob/living/carbon/human/unathi/verb/lizard_threat()
	set name = "Угрожающе рычать"
	set category = "Emote"
	emote("threat")
