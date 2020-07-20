
/decl/emote/audible/species_sound/wort
	key = "wort"
	emote_message_3p = "USER worts, three times.!"
	species_sounds = list(/datum/species/sangheili = 'code/modules/halo/sounds/worting.ogg')

/decl/emote/audible/species_sound/wort/do_extra(var/atom/user, var/atom/target)
	var/oldref = species_sounds[/datum/species/sangheili]
	if(prob(33))
		species_sounds[/datum/species/sangheili] = 'code/modules/halo/sounds/wohrby.ogg'
	. = ..()
	species_sounds[/datum/species/sangheili] = oldref

/decl/emote/audible/species_sound/need_weapon
	key = "weapon"
	emote_message_3p = "USER exclaims their need for a weapon!"
	species_sounds = list(/datum/species/spartan = 'code/modules/halo/sounds/need_weapon.ogg')
