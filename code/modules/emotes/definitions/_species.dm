/mob/living/carbon/update_emotes()
	. = ..(skip_sort=1)
	if(species)
		for(var/emote in species.default_emotes)
			var/singleton/emote/emote_datum = GET_SINGLETON(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	usable_emotes = sortAssoc(usable_emotes)

// Specific defines follow.
/singleton/species/slime/default_emotes = list(
	/singleton/emote/visible/bounce,
	/singleton/emote/visible/jiggle,
	/singleton/emote/visible/lightup,
	/singleton/emote/visible/vibrate
)

/singleton/species/unathi/default_emotes = list(
	/singleton/emote/visible/flick,
	/singleton/emote/human/swish,
	/singleton/emote/human/wag,
	/singleton/emote/human/sway,
	/singleton/emote/human/qwag,
	/singleton/emote/human/fastsway,
	/singleton/emote/human/swag,
	/singleton/emote/human/stopsway,
	/singleton/emote/audible/lizard_bellow,
	/singleton/emote/audible/lizard_thump,
	/singleton/emote/audible/lizard_hiss
)

/singleton/species/unathi/yeosa/default_emotes = list(
	/singleton/emote/visible/flick,
	/singleton/emote/human/swish,
	/singleton/emote/human/wag,
	/singleton/emote/human/sway,
	/singleton/emote/human/qwag,
	/singleton/emote/human/fastsway,
	/singleton/emote/human/swag,
	/singleton/emote/human/stopsway,
	/singleton/emote/audible/lizard_bellow,
	/singleton/emote/audible/lizard_squeal,
	/singleton/emote/audible/lizard_thump,
	/singleton/emote/audible/lizard_hiss
)

/singleton/species/nabber/default_emotes = list(
	/singleton/emote/audible/bug_hiss,
	/singleton/emote/audible/bug_buzz,
	/singleton/emote/audible/bug_chitter
)

/singleton/species/adherent/default_emotes = list(
	/singleton/emote/audible/adherent_chime,
	/singleton/emote/audible/adherent_ding
)

/singleton/species/vox/default_emotes = list(
	/singleton/emote/audible/vox_shriek
)

/singleton/species/diona/default_emotes = list(
	/singleton/emote/audible/chirp,
	/singleton/emote/audible/multichirp
)
