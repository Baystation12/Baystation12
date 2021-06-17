/datum/extension/on_click
	base_type = /datum/extension/on_click
	expected_type = /atom
	var/atom/atom_holder

/datum/extension/on_click/alt
	base_type = /datum/extension/on_click/alt

/datum/extension/on_click/New()
	..()
	atom_holder = holder

/datum/extension/on_click/Destroy()
	atom_holder = null
	return ..()

/datum/extension/on_click/proc/on_click(var/mob/user)
	return FALSE