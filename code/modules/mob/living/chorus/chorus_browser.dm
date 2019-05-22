/mob/living/chorus
	var/list/nano_data

/mob/living/chorus/proc/set_default_nano_data()
	nano_data = list("buildings" = list(), "selected" = null, "has_selected" = FALSE, "resources" = list())
	var/list/building_tiers = get_buildings_by_tier()
	var/tier = 1
	while(building_tiers.len)
		nano_data["buildings"][++nano_data["buildings"].len] = list()
		if(!building_tiers["[tier]"])
			continue
		for(var/b in building_tiers["[tier]"])
			var/datum/chorus_building/cb = b
			nano_data["buildings"][nano_data["buildings"].len][++nano_data["buildings"][nano_data["buildings"].len].len] = list("state" = cb.type, "image" = cb.get_print_icon_state())
		building_tiers -= "[tier]"
		tier += 1
	for(var/r in resources)
		var/datum/chorus_resource/resource = r
		nano_data["resources"][++nano_data["resources"].len] = list("print" = resource.printed_cost(), "amount" = 0)
		resource.index = nano_data["resources"].len

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