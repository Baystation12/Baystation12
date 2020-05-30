/datum/chorus_form
	var/name = "DEBUG"
	var/desc = "DEBUG"
	var/form_state = "DEBUG"
	var/possession_state = "DEBUG"
	var/join_message = "You feel more loyal to"
	var/leave_message = "You are no longer under the control of"
	var/implant_name = "curious object"
	var/implant_state = "implant"
	var/list/buildings = list() //All possible buildings
	var/list/resources = list()

/datum/chorus_form/proc/setup_form(var/mob/living/chorus/c)
	c.icon_state = form_state
	for(var/type in resources)
		var/datum/chorus_resource/resource = new type()
		c.resources += resource
	var/list/n_b = list()
	for(var/type in buildings)
		var/datum/chorus_building/cb = new type()
		n_b["[cb.type]"] = cb
	buildings = n_b
	send_rscs(c)

/datum/chorus_form/proc/self_click(var/mob/living/chorus/c)
	return

/datum/chorus_form/proc/send_rscs(var/mob/living/chorus/c)
	for(var/b in buildings)
		var/datum/chorus_building/cb = buildings[b]
		send_rsc(c, cb.get_rsc(), cb.get_rsc_path())

/datum/chorus_form/proc/shape_implant(var/obj/item/weapon/implant/chorus_loyalty/cl)
	cl.name = implant_name
	cl.icon_state = implant_state

/datum/chorus_form/proc/get_buildings_by_tier()
	. = list()
	for(var/b in buildings)
		var/datum/chorus_building/cb = buildings[b]
		LAZYADD(.["[cb.build_level]"], cb)

/datum/chorus_form/proc/get_building_by_type(var/type)
	return buildings["[type]"]

/datum/chorus_form/proc/print_end_game_screen(var/mob/living/chorus/C)
	to_world("\The [C] was a [name] Chorus")