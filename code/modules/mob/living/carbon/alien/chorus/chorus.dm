/mob/living/carbon/alien/chorus
	name = "chorus"
	desc = "An unformed chorus creature. How quaint."
	icon = 'icons/mob/simple_animal/critter.dmi'
	icon_state = "blob"
	health = 100
	maxHealth = 100
	var/melee_damage = 30
	var/global/choruses
	var/global/num_choruses = 1
	var/datum/chorus/chorus_type
	var/attack_text = "smashes"
	var/icon_living = "blob"
	var/icon_dead = "blob"
	var/attack_sound = 'sound/effects/stamp.ogg'
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 8
	language = LANGUAGE_CULT_GLOBAL
	species_language = LANGUAGE_CULT_GLOBAL

/mob/living/carbon/alien/chorus/Initialize(var/maploading, var/datum/chorus/chorus)
	..()
	//I put it here instead of antagonists as it relies on less things
	if(!choruses)
		choruses = list()
		for(var/i in 1 to num_choruses)
			choruses += new /datum/chorus()
	if(!chorus)
		chorus = choruses[1]
		for(var/c in choruses)
			var/datum/chorus/ct = c
			if(ct.units.len < chorus.units.len)
				chorus = ct
	set_chorus(chorus)
	add_language(LANGUAGE_CULT)
	var/datum/language/l = all_languages[LANGUAGE_CULT]
	name = l.get_random_name()
	verbs += /mob/living/proc/ventcrawl

/mob/living/carbon/alien/chorus/Destroy()
	if(chorus_type)
		chorus_type.remove_unit(src)
	. = ..()

/mob/living/carbon/alien/chorus/Login()
	. = ..()
	chorus_type.update_huds(specific_unit = src)
	if(chorus_type.form)
		chorus_type.form.send_rscs(src)
	if(mind)
		GLOB.chorus.add_antagonist_mind(mind)

/mob/living/carbon/alien/chorus/proc/set_chorus(var/datum/chorus/cf)
	chorus_type = cf
	cf.add_unit(src)
	set_default_nano_data()

/mob/living/carbon/alien/chorus/proc/remove_chorus()
	if(!type)
		return
	chorus_type.remove_unit(src)
	chorus_type = null

/mob/living/carbon/alien/chorus/proc/update_resources(var/list/printed)
	if(hud_used)
		var/datum/hud/chorus/C = hud_used
		C.update_resources(printed)

/mob/living/carbon/alien/chorus/proc/update_buildings_units(var/buildings, var/units)
	if(hud_used)
		var/datum/hud/chorus/C = hud_used
		C.update_buildings_units(buildings, units)

/mob/living/carbon/alien/chorus/update_icons()
	if(stat == DEAD)
		icon_state = icon_dead
	else
		icon_state = icon_living