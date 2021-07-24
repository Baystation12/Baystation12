
/decl/emote/audible/species_sound/wort
	key = "wort"
	emote_message_3p = "USER worts, three times!"
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

/decl/emote/audible/painscream
	key = "painscream"
	emote_message_3p = "USER screams in pain!"

/decl/emote/audible/painscream/do_extra(var/atom/user, var/atom/target)
	var/mob/living/carbon/human/h = user
	if(!istype(h))
		return
	if(h.stat != CONSCIOUS)
		return
	if(world.time < h.next_scream_at)
		return
	var/datum/species/s = h.species
	if(isnull(s) || s.pain_scream_sounds.len == 0)
		return
	var/scream_sound
	if(s.scream_sounds_female.len > 0 && h.gender == FEMALE)
		scream_sound = pick(s.scream_sounds_female)
	else
		scream_sound = pick(s.pain_scream_sounds)

	playsound(user.loc, scream_sound,50,0,7)
	h.next_scream_at = world.time + SCREAM_COOLDOWN
	return

/decl/emote/audible/painscream/do_emote(var/mob/living/user, var/extra_params)
	if(istype(user))
		if(world.time < user.next_scream_at)
			return
	return ..()

/decl/emote/audible/gasp/do_emote(var/mob/living/user, var/extra_params)
	if(istype(user))
		if(world.time < user.next_scream_at)
			return
	return ..()