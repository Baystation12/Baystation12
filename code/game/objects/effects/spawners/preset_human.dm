/obj/spawner/preset_human
	name = "Preset Human Spawner"
	abstract_type = /obj/spawner/preset_human

	var/mob_name
	var/mob_gender = NEUTER
	var/mob_pronouns = PRONOUNS_THEY_THEM
	var/age = 30
	var/eye_color = "#000000"
	var/head_hair_style = "Bald"
	var/head_hair_color = "#000000"
	var/facial_hair_style = "Shaved"
	var/facial_hair_color = "#000000"
	var/skin_tone = 0
	var/skin_color = "#7f7f7f"
	/// String (One of `SPECIES_*`). The species the mob should spawn as.
	var/species = SPECIES_HUMAN

	/// LAZYLIST of strings (Any of `LANGUAGE_*`). Languages the mob should have.
	var/list/languages

	/// Outfit to equip, if set.
	var/singleton/hierarchy/outfit/outfit


/obj/spawner/preset_human/Initialize()
	. = ..()
	do_spawn()


/**
 * Handles the actual spawning and qeuipping process. Separated from `Initialize()` as some procs sleep.
 *
 * The spawner needs to qdel itself at the end of the process.
 *
 * Has no return value.
 */
/obj/spawner/preset_human/proc/do_spawn()
	set waitfor = FALSE

	var/mob/living/carbon/human/human = new(loc, species)
	human.fully_replace_character_name(mob_name)
	human.gender = mob_gender
	human.pronouns = mob_pronouns
	human.age = age
	human.eye_color = eye_color
	human.head_hair_style = head_hair_style
	human.head_hair_color = head_hair_color
	human.facial_hair_style = facial_hair_style
	human.facial_hair_color = facial_hair_color
	human.skin_color = skin_color
	human.skin_tone = skin_tone

	human.force_update_limbs()
	human.update_mutations(FALSE)
	human.update_body(FALSE)
	human.update_underwear(FALSE)
	human.update_hair(FALSE)
	human.update_icons()

	if (length(languages))
		for (var/language in languages)
			human.add_language(language)

	if (outfit)
		outfit = outfit_by_type(outfit)
		outfit.equip(human)

	qdel_self()
