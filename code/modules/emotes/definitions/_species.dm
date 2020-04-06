/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/update_emotes()
	. = ..(skip_sort=1)
	if(species)
		for(var/emote in species.default_emotes)
			var/decl/emote/emote_datum = decls_repository.get_decl(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	usable_emotes = sortAssoc(usable_emotes)

// Specific defines follow.
/datum/species/slime
	default_emotes = list(
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate
		)

/datum/species/unathi
	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway,
		/decl/emote/audible/lizard_bellow
		)

/datum/species/unathi/yeosa
	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway,
		/decl/emote/audible/lizard_bellow,
		/decl/emote/audible/lizard_squeal
		)

/datum/species/nabber
	default_emotes = list(
		/decl/emote/audible/bug_hiss,
		/decl/emote/audible/bug_buzz,
		/decl/emote/audible/bug_chitter
		)

/datum/species/adherent
	default_emotes = list(
		/decl/emote/audible/adherent_chime,
		/decl/emote/audible/adherent_ding
	)

/datum/species/vox
	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)

/datum/species/mantid
	default_emotes = list(
		/decl/emote/audible/ascent_purr,
		/decl/emote/audible/ascent_hiss,
		/decl/emote/audible/ascent_snarl,
		/decl/emote/visible/ascent_flicker,
		/decl/emote/visible/ascent_glint,
		/decl/emote/visible/ascent_glimmer,
		/decl/emote/visible/ascent_pulse,
		/decl/emote/visible/ascent_shine,
		/decl/emote/visible/ascent_dazzle
	)

/datum/species/diona
	default_emotes = list(
		/decl/emote/audible/chirp,
		/decl/emote/audible/multichirp
	)

/mob/living/carbon/human/set_species(var/new_species, var/default_colour = 1)
	UNLINT(. = ..())
	update_emotes()
