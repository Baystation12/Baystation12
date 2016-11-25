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


/mob/living/carbon/human/set_species(var/new_species, var/default_colour)
	. = ..()
	update_emotes()
