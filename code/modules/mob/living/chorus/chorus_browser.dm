/mob/living/chorus
	var/list/nano_data

/mob/living/chorus/proc/set_default_nano_data()
	var/list/building_tiers = get_buildings_by_tier()
	var/list/buildings = list()
	for(var/tier in building_tiers)
		var/list/buildings_in_tier = list()
		for(var/datum/chorus_building/cb in building_tiers[tier])
			buildings_in_tier += list(list("state" = cb.type, "image" = cb.get_print_icon_state()))
		buildings += list(buildings_in_tier)
	var/list/rscs = list()
	for(var/datum/chorus_resource/r in resources)
		rscs += list(list("print" = r.printed_cost(), "amount" = 0))
		r.index = rscs.len
	nano_data = list("buildings" = buildings, "selected" = null, "has_selected" = FALSE, "resources" = rscs)

/mob/living/chorus/proc/open_building_menu()
	if(phase == CHORUS_PHASE_EGG)
		ui_interact(src)

/mob/living/chorus/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/uistate = GLOB.self_state)
	if(selected_building)
		nano_data["has_selected"] = TRUE
		nano_data["selected"] = selected_building.get_nano_data(src)
	else
		nano_data["has_selected"] = FALSE


	ui = SSnano.try_update_ui(user, src, ui_key, ui, nano_data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chorus.tmpl", "Chorus Menu" , 650, 600, state = uistate)
		ui.set_initial_data(nano_data)
		ui.open()
		ui.set_auto_update(TRUE)

/mob/living/chorus/proc/update_nano_resource(var/datum/chorus_resource/resource)
	nano_data["resources"][resource.index]["amount"] = resource.get_amount()

/mob/living/chorus/self_can_use_topic(var/src_object)
	return STATUS_INTERACTIVE
