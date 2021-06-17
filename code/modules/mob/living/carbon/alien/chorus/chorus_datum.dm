/datum/chorus
	var/datum/chorus_form/form
	var/list/units = list()
	var/list/buildings = list()

/datum/chorus/New()
	..()
	var t = pick(subtypesof(/datum/chorus_form))
	set_form(new t())

/datum/chorus/Destroy()
	for(var/u in units)
		var/mob/living/carbon/alien/chorus/C = u
		C.set_selected_building(null)
	QDEL_NULL(form)
	. = ..()

/datum/chorus/proc/add_unit(var/mob/living/carbon/alien/chorus/c)
	if(c in units)
		return
	units += c
	if(form)
		form.setup_new_unit(c)
		form.send_rscs(c)
	update_huds()

/datum/chorus/proc/remove_unit(var/mob/living/carbon/alien/chorus/c)
	if(!(c in units))
		return
	units -= c

/datum/chorus/proc/add_building(var/b)
	buildings |= b
	update_huds(TRUE, FALSE)

/datum/chorus/proc/remove_building(var/b)
	buildings -= b
	update_huds(TRUE, FALSE)

/datum/chorus/proc/set_form(var/datum/chorus_form/t)
	form = t
	for(var/rt in t.resources)
		var/r = new rt()
		resources += r
	for(var/u in units)
		form.setup_new_unit(u)
		form.send_rscs(u)
	update_huds()

/datum/chorus/proc/update_nano_basic(var/datum/chorus_resource/resource)
	for(var/u in units)
		var/mob/living/carbon/alien/chorus/c = u
		c.update_nano_resource(resource)

/datum/chorus/proc/update_huds(var/update_buildings_units = TRUE, var/update_resources = TRUE, var/specific_unit)
	if(specific_unit)
		specific_unit = list(specific_unit)
	else
		specific_unit = units
	var/list/print_resources
	if(update_resources)
		print_resources = list()
		for(var/r in resources)
			var/datum/chorus_resource/chor = r
			print_resources += "[chor.printed_cost()] [chor.get_amount()]"
	for(var/u in specific_unit)
		var/mob/living/carbon/alien/chorus/c = u
		if(update_resources)
			c.update_resources(print_resources)
		if(update_buildings_units)
			c.update_buildings_units(buildings.len, units.len)

/datum/chorus/proc/get_dist_to_nearest_building(var/atom/A)
	var/atom/a = get_atom_closest_to_atom(A, buildings)
	if(a)
		. = get_dist(A, a)

/datum/chorus/proc/get_building_type_amount(var/type)
	. = 0
	for(var/b in buildings)
		if(istype(b, type))
			.++

/datum/chorus/proc/is_follower(var/m)
	return (m in units)