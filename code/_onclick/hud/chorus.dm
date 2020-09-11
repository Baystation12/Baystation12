/mob/living/carbon/alien/chorus
	hud_type = /datum/hud/chorus

/datum/hud/chorus
	var/obj/screen/chorus_current_building/selected
	var/obj/screen/chorus_building_cost/cost
	var/obj/screen/chorus_resource/followers
	var/obj/screen/chorus_resource/buildings
	var/list/resources = list()

/datum/hud/chorus/FinalizeInstantiation(ui_style = 'icons/mob/screen1_Midnight.dmi')
	adding = list()
	other = list()
	resources = list()


	var/obj/screen/chorus_current_building/ccb = new()

	adding += ccb
	selected = ccb

	var/obj/screen/chorus_building_cost/cbc = new()

	adding += cbc
	cost = cbc

	adding += new /obj/screen/chorus_cancel_building()
	adding += new /obj/screen/chorus_open_blueprints()
	var/obj/screen/intent = new /obj/screen/intent()
	intent.screen_loc = "WEST+6:8, SOUTH+1:8"
	action_intent = intent
	adding += intent

	for(var/i in 1 to 4)
		var/obj/screen/chorus_resource/res = new()
		res.maptext_x = 108 - (i%2) * 98
		res.maptext_y = 28 - (i>2 ? 16 : 0)
		res.icon_state = "resources_[i]"
		resources += res

	followers = new()
	followers.icon_state = "resource_followers"
	followers.maptext_x = 58
	followers.maptext_y = -7
	adding += followers

	buildings = new()
	buildings.icon_state = "resource_buildings"
	buildings.maptext_x = 132
	buildings.maptext_y = -7
	adding += buildings

	adding += resources
	adding += new /obj/screen/chorus_build()

	mymob.healths = new /obj/screen()
	mymob.healths.SetName("health")
	mymob.healths.icon = 'icons/mob/screen1_Midnight.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.screen_loc = ui_construct_health
	adding += mymob.healths

	mymob.client.screen = list()
	mymob.client.screen += src.adding

/datum/hud/chorus/proc/update_buildings_units(var/b, var/f)
	followers.update_resource(f)
	buildings.update_resource(b)

/datum/hud/chorus/proc/update_resources(var/list/prints)
	for(var/i in 1 to prints.len)
		var/obj/screen/chorus_resource/res = resources[i]
		var/p = prints[i]
		res.update_resource(p)

/datum/hud/chorus/proc/update_selected(var/datum/chorus_building/n_build)
	selected.update_to_building(n_build)
	if(n_build)
		cost.update_to_cost(n_build.get_printed_cost(mymob))
	else
		cost.update_to_cost(list())

/obj/screen/chorus_current_building
	name = "Building"
	screen_loc = "WEST:8,SOUTH:8"
	icon = 'icons/mob/screen_chorus_big.dmi'
	icon_state = "basic"
	maptext_width = 92
	maptext_x = 62
	maptext_y = 38

/obj/screen/chorus_current_building/proc/update_to_building(var/datum/chorus_building/build)
	overlays.Cut()
	if(build)
		var/image/I = build.get_image()
		I.pixel_y = 17
		I.pixel_x = 17
		overlays += I
		maptext = "<p style=\"font-size:5px\">[build.get_name()]</p>"
	else
		maptext = null

/obj/screen/chorus_building_cost
	name = "Cost"
	screen_loc = "WEST:8,SOUTH:8"
	icon = 'icons/mob/screen_chorus_big.dmi'
	icon_state = "cost"
	maptext_x = 60
	maptext_y = 8
	maptext_width = 92
	maptext_height = 30

/obj/screen/chorus_building_cost/proc/update_to_cost(var/list/cost)
	var/list/dat = list()
	dat += {"
	<p style=\"font-size:5px\">
		<center>
			<table>
				<tr>
					<td>"}
	for(var/i = 1; i <= 4; i++)
		if(cost.len >= i)
			dat += "[cost[i]["print"]] [cost[i]["amount"]]"
		if(i == 4)
			break
		if(i == 2)
			dat += "</td></tr><tr><td>"
		dat += "</td><td>"
	dat += "</td></tr></table></center></p>"
	maptext = jointext(dat,null)

/obj/screen/chorus_cancel_building
	name = "Cancel"
	screen_loc = "WEST+5:8, SOUTH:8"
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "cancel"

/obj/screen/chorus_cancel_building/Click()
	if(usr && istype(usr, /mob/living/carbon/alien/chorus))
		var/mob/living/carbon/alien/chorus/C = usr
		C.set_selected_building(null)

/obj/screen/chorus_open_blueprints
	name = "Blueprints"
	screen_loc = "WEST+5:8, SOUTH+1:8"
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "blueprints"


/obj/screen/chorus_open_blueprints/Click()
	if(usr && istype(usr, /mob/living/carbon/alien/chorus))
		var/mob/living/carbon/alien/chorus/C = usr
		C.open_building_menu()

/obj/screen/chorus_resource
	name = "Resources"
	screen_loc = "EAST-4:-8, SOUTH:8"
	icon = 'icons/mob/screen_chorus_big.dmi'
	icon_state = "resources"
	maptext_width = 50

/obj/screen/chorus_resource/proc/update_resource(var/print)
	maptext = "<p style=\"font-size:5px\">[print]</p>"

/obj/screen/chorus_build
	name = "Build"
	screen_loc = "WEST+6:8, SOUTH:8"
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "build"

/obj/screen/chorus_build/Click()
	if(usr && istype(usr, /mob/living/carbon/alien/chorus))
		var/mob/living/carbon/alien/chorus/c = usr
		c.start_building()