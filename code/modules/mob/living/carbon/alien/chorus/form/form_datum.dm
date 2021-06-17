/datum/chorus_form
	var/name = "DEBUG"
	var/desc = "DEBUG"
	var/form_state = "DEBUG"
	var/list/buildings = list() //All possible buildings
	var/list/resources = list()

/datum/chorus_form/New()
	. = ..()
	var/list/n_buildings = list()
	for(var/type in buildings)
		var/datum/chorus_building/cb = new type()
		n_buildings["[cb.type]"] = cb
	buildings = n_buildings

/datum/chorus_form/proc/send_rscs(var/mob/c)
	for(var/b in buildings)
		var/datum/chorus_building/cb = buildings[b]
		send_rsc(c, cb.get_rsc(), cb.get_rsc_path())

/datum/chorus_form/proc/get_buildings_by_tier()
	. = list()
	for(var/b in buildings)
		var/datum/chorus_building/cb = buildings[b]
		LAZYADD(.["[cb.build_level]"], cb)

/datum/chorus_form/proc/get_building_by_type(var/type)
	return buildings["[type]"]

/datum/chorus_form/proc/setup_new_unit(var/mob/living/carbon/alien/chorus/c)
	return

